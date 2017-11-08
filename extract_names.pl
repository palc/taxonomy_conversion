#!/usr/bin/perl

$unclass=1;

if (scalar(@ARGV) < 5) {
    print STDERR "Usage: $0 <original taxonomy file> <new taxonomy file> <original fasta file> <new RDP fasta file> <taxa file>\n";
    exit(1);
}

open ($tax,"<$ARGV[0]");
open ($newtax,">$ARGV[1]");
while (<$tax>) {
    chomp;
    ($id,$kingdom,$phylum,$class,$order,$family,$genus,$species) = $_ =~ /^(.+?)\tk_(\w+)\;\s+p_(\w+)\;\s+c_(\w+)\;\s+o_(\w+)\;\s+f_(\w+)\;\s+g_(\w+)\;\s+s_(\w+)/;

    if ($phylum =~ /^(unknown|unclassified|unidentified)$/i) {$phylum = "$kingdom"."_$1$unclass"; $unclass++;}
    if ($class =~ /^(unknown|unclassified|unidentified)$/i) {$class = "$phylum"."_$1$unclass"; $unclass++;}
    if ($order =~ /^(unknown|unclassified|unidentified)$/i) {$order = "$class"."_$1$unclass"; $unclass++;}
    if ($family =~ /^(unknown|unclassified|unidentified)$/i) {$family = "$order"."_$1$unclass"; $unclass++;}
    if ($genus =~ /^(unknown|unclassified|unidentified)$/i) {$genus = "$family"."_$1$unclass"; $unclass++;}
    #if ($species eq "unclassified") {$species = "$genus"."_unclassified";}

    #print "$kingdom\n$phylum\n$class\n$order\n$family\n$genus\n$genus $species\n";
    $names{$kingdom}=1;
    $names{$phylum}=1;
    $names{$class}=1;
    $names{$order}=1;
    $names{$family}=1;
    $names{$genus}=1;
    $names{"$genus"."_$species"}=1;

    print $newtax "$id\tk_$kingdom; p_$phylum; c_$class; o_$order; f_$family; g_$genus; s_$genus"."_$species\n";
    $newfasta{$id} = "Root;$kingdom;$phylum;$class;$order;$family;$genus;$genus"."_$species";
}
close($tax);
close($newtax);

open($oldfasta_file,"<$ARGV[2]");
open($newfasta_file,">$ARGV[3]");
while (<$oldfasta_file> ) {
    chomp;
    if ($_ =~ /^>(.+?)$/) {
        $id = $1;
        if (!exists $newfasta{$id}) {print STDERR "Error: Fasta ID $id not found. Exiting.\n"; exit(1);}
        print $newfasta_file ">$id\t$newfasta{$id}\n";
        next;
    }

    print $newfasta_file "$_\n";
}
close($newfasta_file);
close($oldfasta_file);

open($taxa_file, ">$ARGV[4]");
foreach $taxa (sort keys %names) {
    print $taxa_file "$taxa\n";
}
close($taxa_file);
