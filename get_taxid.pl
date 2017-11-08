#!/usr/bin/perl

$custom_count=1000000000;
open($taxa,"<$ARGV[0]");
while (<$taxa>) {
    chomp;
    $query = $_;
    $query =~ s/_/ /g;
    $ret = `edirect/esearch -db taxonomy -query "$query" | edirect/efetch`;
    chomp $ret;
    if ($ret ne "") {
        print "$_\t$ret\n";
    } else {
        print STDERR "Query \"$query\" not found. Creating custom ID.\n";
        $custom_count++;
        print "$_\t$custom_count\n";
    }
}
close($taxa);
