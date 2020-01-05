#!/usr/bin/perl
use strict;
use warnings;

use XML::Simple;
use Data::Dumper;
use Excel::Writer::XLSX;
my $file = $ARGV[0];
my $hash = XMLin("$file");

print Dumper($hash);


my $wb = Excel::Writer::XLSX->new('reg.xlsx');
my $ws = $wb->add_worksheet('DATA');
my $format = $wb->add_format();
$format->set_color('red');

my $row = 0;
while (my ($k,$v) = each (%{$hash}) ) {
#		print "$k => $v\n";
		my $col = 0;
		$ws->write($row,$col,$k,$format);
		my $row1 = 1;
		foreach my $kk (sort(keys %{$v} )) {
				print "$kk => \n\n\n";
				$ws->write($row+1,$col,$kk);
				foreach my $kk1 (sort(keys %{$v->{$kk} } ) ) {
					#	print "$kk1\n";
						if ($kk1 eq 'cast') {
						#		print "$kk1 => $v->{$kk}->{$kk1}\n";
						#	 	print "$kk1 => $v->{$kk}->{$kk1}->{'person'}\n";
								foreach my $kk3 (keys %{$v->{$kk}->{$kk1}->{'person'}} ) {
						#					print "$kk3\n";
											if (exists $v->{$kk}->{$kk1}->{'person'}->{$kk3}) {
														while (my ($k2,$v2) = each (%{$v->{$kk}->{$kk1}->{'person'}->{$kk3}}) ) {
																	print "$kk3 => $v2\n";
																	$ws->write($row+1,$col+1,$kk3);
																	$ws->write($row+1,$col+2,$kk3);
														}	
														$row++;		
											}
										
								}
								print "\n";
						} elsif ($kk1 eq 'imdb-info') {
								#print "$kk1\n";
								 my $col1 = 3;
								if (exists $v->{$kk}->{$kk1}->{'score'}) {
					#					print "$v->{$kk}->{$kk1}->{'score'}\n";
										 my $p1 = $v->{$kk}->{$kk1}->{'score'};
									#	$ws->write($row1,$col1++,$p1);
								}
								if (exists $v->{$kk}->{$kk1}->{'url'}) {
					#					print "$v->{$kk}->{$kk1}->{'url'}\n";
										my $p2 = $v->{$kk}->{$kk1}->{'url'};
									#	$ws->write($row1,$col1++,$p2);
								}
								if (exists $v->{$kk}->{$kk1}->{'synopsis'}) {
					#					print "$v->{$kk}->{$kk1}->{'synopsis'}\n";
										my $p3 =  $v->{$kk}->{$kk1}->{'synopsis'};
									#	$ws->write($row1,$col1++,$p3);
								}
								$row1++;
						} elsif ($kk1 eq 'genre') { 
								#print "$kk1 => 
								foreach my $kk2 (@{$v->{$kk}->{$kk1}}) {
					#					print "$kk2\n";
										$ws->write($row+1,$col+3,$kk2);
								}
								$row++;
						#		print "\n";
						}
						else {
							#	$ws->write(0,0,$kk1,$format);
					#			print "$kk1 => $v->{$kk}->{$kk1}\n";
						}
			  }
				$row++;
				print "\n";	
		}
}




