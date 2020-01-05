#!/usr/bin/perl
use strict;
use warnings;
use XML::Simple;
use Data::Dumper;


use Excel::Writer::XLSX;
 
# Create a new Excel workbook
my $workbook = Excel::Writer::XLSX->new( 'perl.xlsx' );
 
# Add a worksheet
my $worksheet = $workbook->add_worksheet(); 







my $file = $ARGV[0];
my $ref = XMLin("$file");



=c

print "Enter run recursive function 'yes : no' : ";
my $aa = <STDIN>;
chomp($aa); 

#print Dumper($ref);
my $hash;


my @abc = ();

if ($aa eq 'yes') {
		Recu($ref);
}

(open my $fh,">aa.csv") || die "Not able to write 'aa.csv $!";

sub Recu {
		my $row = 0;
    my $ref = shift;
    if (ref($ref) eq 'ARRAY') {
          foreach my $kk (@{$ref}) {
                if (ref($kk) eq 'ARRAY') {
                      Recu($kk);
                } elsif (ref($kk) eq 'HASH') {
                      Recu($kk);
                } else {
                    # print "$kk\n";
                }
							#	print"\n";
          }
    } elsif (ref($ref) eq 'HASH') {
					my $col = 0;
          while (my ($k,$v) = each(%{$ref})) {
                if (ref($v) eq 'HASH') {
                  # print "$k => \n";
										$worksheet->write( $row, $col++,$k);
                    Recu($v);
                } elsif (ref($v) eq 'ARRAY') {
										my $aa = join(',',@{$v});
										print "$k =>\n";
										if ($row == 0) {
												$worksheet->write( $row, $col++,$k);
										}
										print "$aa\n";
                   #Recu($v);
                } else {
                   #print "$k => $v\n";
										if ($row == 0) {
												$worksheet->write( $row, $col++,$k);
										} else { 
												$worksheet->write( $row,$col,$v);
												print "$col,$row";
												$col++;
										}
                }
          }
					$row++;
#					print"\n\n\n\n";
    }
}

print Dumper(@abc);

=cut




my @an = qw(title mpaa-rating release-date running-time director); 
while (my ($k,$v) = each (%{$ref}) ) {
	#	print "$k => $v\n";
		while (my ($k1,$v1) = each (%{$v}) ) {
			#	print "$k1 => $v1\n";
			  while (my ($k2,$v2) = each (%{$v1}) ) {
					#	print "$k2 => $v2\n";	
						if (ref($v2) eq 'HASH') {
							   while (my ($k3,$v3) = each (%{$v2}) ) {		
										#	print "$k3 => $v3\n";
								 }
						} elsif (ref($v2) eq 'ARRAY') {
							#	 print "@{$v2}\n";
						} else {
						}
				}
				print"\n";
		}
}






