#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "usage: $0 gmap.gff3.summary minJ minJS min_novel_J\n\n";

my $gmap_summary_file = $ARGV[0] or die $usage;
my $minJ = $ARGV[1];
my $minJS = $ARGV[2];
my $min_novel_J = $ARGV[3];


my $MIN_ANCHOR_ENTROPY = 1.3; #TODO: make parameterizable!

unless (defined ($minJ) && defined($minJS) && defined($min_novel_J)) {
    die $usage;
}

my $filt_file = "$gmap_summary_file.filt";
open (my $ofh, ">$filt_file") or die "Error, cannot write to $filt_file";


open (my $fh, $gmap_summary_file) or die $!;
while (<$fh>) {
    if (/^\#/) { # header
        print $_;
        print $ofh $_;
        next;
    }

    chomp;
    my $line = $_;
    my @x = split(/\t/);
    my $info = $x[3];
    
    my $J = $x[4];
    my $S = $x[5];
    
    my $left_brkpt_entropy = $x[7];
    my $right_brkpt_entropy = $x[9];
    
    
    if ($info ne '.') {
        my ($geneA, $distA, $trans_brkptA, $breakpointA, 
            $geneB, $distB, $trans_brkptB, $breakpointB, 
            $chim) = split(/;/, $info);

        if ($geneA eq $geneB) {
            print $ofh "#$line\t$chim\tNO SELFIES\n";
            next; 
        }
        
        my $record_pass = 0;

        if (defined($J) && defined($S) && $J =~ /^\d+$/ && $S =~ /^\d+$/) {
            
            ## Examining Illumina PE read support

            my $sumJS = $J + $S;
            if ($distA == 0 && $distB == 0 && $J >= $minJ && $sumJS >= $minJS) {
                # reference junction
                $record_pass = 1;
            }
            elsif ( ($distA > 0 || $distB > 0) && $J >= $min_novel_J  && $sumJS >= $minJS) {
                $record_pass = 1;
            }
        
            ## but...  if only junction reads, the anchors must meet the min entropy requirement.
            if ($J > 0 && $S == 0 && ($left_brkpt_entropy < $MIN_ANCHOR_ENTROPY || $right_brkpt_entropy < $MIN_ANCHOR_ENTROPY) ) {
                print $ofh "#$line\t$chim\tFails to meet min entropy requirement at junction anchor region\n";
                next;
            }
            
        }
        else {
            ## only reporting ref-junction entries
            
            if ($distA == 0 && $distB == 0) {
                $record_pass = 1;
            }
        }
        
        if ($record_pass) {
            print "$line\t$chim\n";
            print $ofh "$line\t$chim\n";
        }
        else {
            print $ofh "#$line\t$chim\tFails to meet minJ or minJS_sum requirement.\n";
        }
    }
    
}


exit(0);
