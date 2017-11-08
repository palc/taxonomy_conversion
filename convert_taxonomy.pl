#!/usr/bin/perl

#converts qiime style taxonomy to rdp style

if (scalar(@ARGV) < 2) {
    print STDERR "Usage: $0 <taxa to taxid file> <new taxonomy file>\n";
    exit(1);
}

open($tid,"<$ARGV[0]");
while (<$tid>) {
    chomp;
    ($name,$id) = split(/\t/);
    $taxa{$name}=$id;
}
close($tid);


$unclass = 1;
print "0*Root*-1*0*rootrank\n";
open($tf,"<$ARGV[1]");
while (<$tf>) {
    chomp;
    $depth = 1;
    $parent_taxid = 0;
    #($kingdom,$phylum,$class,$order,$family,$genus,$species) = $_ =~ /k_(\w+)\;\s+p_(\w+)\;\s+c_(\w+)\;\s+o_(\w+)\;\s+f_(\w+)\;\s+g_(\w+)\;\s+s_(\w+)/;

    ($kingdom,$phylum,$class,$order,$family,$genus,$species) = ("","","","","","","");

    ($id) = $_ =~ /^(.+?)\t/;

    if ($_ =~ /k_(\w+)\;/) {
        $kingdom = $1;
        if (!exists $done{$kingdom}) {
            print "$taxa{$kingdom}*$kingdom*$parent_taxid*$depth*kingdom\n";
            $done{$kingdom} = 1;
        }
        $parent_taxid = $taxa{$kingdom};
        $depth++;
    }

    if ($_ =~ /p_(\w+)\;/) {
        $phylum = $1;
        if (!exists $done{$phylum}) {
            print "$taxa{$phylum}*$phylum*$parent_taxid*$depth*phylum\n";
            $done{$phylum} = 1; 
        }
        $parent_taxid = $taxa{$phylum};
        $depth++;
    }

    if ($_ =~ /c_(\w+)\;/) {
        $class = $1;
        if (!exists $done{$class}) {
            print "$taxa{$class}*$class*$parent_taxid*$depth*class\n";
            $done{$class} = 1;
        }
        $parent_taxid = $taxa{$class};
        $depth++;
    }

    if ($_ =~ /o_(\w+)\;/) {
        $order = $1;
        if (!exists $done{$order}) {
            print "$taxa{$order}*$order*$parent_taxid*$depth*order\n";
            $done{$order} = 1;
        }
        $parent_taxid = $taxa{$order};
        $depth++;
    }

    if ($_ =~ /f_(\w+)\;/) {
        $family = $1;
        if (!exists $done{$family}) {
            print "$taxa{$family}*$family*$parent_taxid*$depth*family\n";
            $done{$family} = 1;
        }
        $parent_taxid = $taxa{$family};
        $depth++;
    }

    if ($_ =~ /g_(\w+)\;/) {
        $genus = $1;
        if (!exists $done{$genus}) {
            print "$taxa{$genus}*$genus*$parent_taxid*$depth*genus\n";
            $done{$genus} = 1;
        }
        $parent_taxid = $taxa{$genus};
        $depth++;
    }

    if ($_ =~ /s_(\w+)/) {
        $species = $1;
        if (!exists $done{$species} && exists $taxa{$species}) {
            print $taxa{$species}."*$species*$parent_taxid*$depth*species\n";
            $done{$species} = 1;
        }
        $parent_taxid = $taxa{$species};
        $depth++;
    }
}
close($tf);
