#!/usr/bin/perl

open($taxa,"<$ARGV[0]");
while (<$taxa>) {
    chomp;
    if ($_ eq "unclassified") {next;}
    $ret = `edirect/esearch -db taxonomy -query "$_" | edirect/efetch`;
    chomp $ret;
    if ($ret ne "") {
        print "$_\t$ret\n";
    } else {
        print STDERR "Query \"$_\" not found.\n";
    }
}
close($taxa);
