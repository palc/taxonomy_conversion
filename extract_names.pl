#!/usr/bin/perl

open ($tax,"<$ARGV[0]");
while (<$tax>) {
    chomp;
    ($kingdom,$phylum,$class,$order,$family,$genus,$species) = $_ =~ /k_(\w+)\;\s+p_(\w+)\;\s+c_(\w+)\;\s+o_(\w+)\;\s+f_(\w+)\;\s+g_(\w+)\;\s+s_(\w+)/;
    print "$kingdom\n$phylum\n$class\n$order\n$family\n$genus\n$genus $species\n";
}
close($tax);
