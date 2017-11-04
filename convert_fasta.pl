#!/usr/bin/perl

open($unclass,"<$ARGV[0]");
while (<$unclass>) {
    chomp;
    ($id,$header) = split(/\t/);
    $headers{$id} = ">$id\tRoot;$header\n";
}
close($unclass);

open($tf,"<$ARGV[1]");
while (<$tf>) {
    chomp;
    ($id,$kingdom,$phylum,$class,$order,$family,$genus,$species) = $_ =~ /^(.+?)\tk_(\w+)\;\s+p_(\w+)\;\s+c_(\w+)\;\s+o_(\w+)\;\s+f_(\w+)\;\s+g_(\w+)\;\s+s_(\w+)/;

    if (exists $headers{$id}) {next;}

    $headers{$id} = ">$id\tRoot;$kingdom;$phylum;$class;$order;$family;$genus";
    if ($species !~ /^sp\.{0,1}$/i) {
        $headers{$id} .= ";$species";
    } else {
        $headers{$id} .= ";unclassified";
    }
    $headers{$id} .= "\n";
}
close($tf);

open($fasta,"<$ARGV[2]");
while (<$fasta>) {
    chomp;
    if ($_ =~ /^>(.+)/) {
        $id = $1;
        print $headers{$id};
        next;
    }

    print "$_\n";
}
close($fasta);
