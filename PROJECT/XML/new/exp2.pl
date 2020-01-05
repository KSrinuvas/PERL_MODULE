#!/usr/bin/perl
use strict;
use warnings;

use XML::Simple;
use Data::Dumper;
my $file = $ARGV[0];


my $ref = XMLin("$file");

#print Dumper($ref);


print "Enter run recursive function 'yes : no' : ";
my $aa = <STDIN>;
chomp($aa); 


my $hash;

if ($aa eq 'yes') {
		Recu($ref);
}


(open my $fh,">aa.csv") || die "Not able to write 'aa.csv $!";


=c

sub Recu {
    my $ref = shift;

    if (ref($ref) eq 'ARRAY') {
          foreach my $kk (@{$ref}) {
                if (ref($kk) eq 'ARRAY') {
                      Recu($kk);
                } elsif (ref($kk) eq 'HASH') {
                      Recu($kk);
                } else {
                  #    print "$kk\n";
                }
          }
    #     print "\n";
    } elsif (ref($ref) eq 'HASH') {
          while (my ($k,$v) = each(%{$ref})) {
                if (ref($v) eq 'HASH') {
                  # print "$k => \n";
                    Recu($v);
                } elsif (ref($v) eq 'ARRAY') {
                  # print "$k => \n";
                    Recu($v);
                } else {
                    print "$k => $v\n";
                }
							#	print "\n";
          }
         print "\n";
    }
}

=cut




sub Recu {
    my $ref = shift;

    if (ref($ref) eq 'ARRAY') {
          foreach my $kk (@{$ref}) {
                if (ref($kk) eq 'ARRAY') {
                      Recu($kk);
                } elsif (ref($kk) eq 'HASH') {
                      Recu($kk);
                } else {
                  #    print "$kk\n";
                }
          }
    #     print "\n";
    } elsif (ref($ref) eq 'HASH') {
          while (my ($k,$v) = each(%{$ref})) {
                if (ref($v) eq 'HASH') {
                  # print "$k => \n";
                    Recu($v);
                } elsif (ref($v) eq 'ARRAY') {
                  # print "$k => \n";
                    Recu($v);
                } else {
                    print "$k => $v\n";
                }
							#	print "\n";
          }
         print "\n";
    }
}
