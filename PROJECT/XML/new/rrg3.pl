#!/usr/bin/perl
use strict;
use warnings;

use XML::Simple;
use Data::Dumper;
use Excel::Writer::XLSX;
my $file = $ARGV[0];
my $hash = XMLin("$file");

print Dumper($hash);


my $wb = Excel::Writer::XLSX->new('reg1.xlsx');
my $ws = $wb->add_worksheet('DATA');
my $format = $wb->add_format();
$format->set_color('red');


my $format1 = $wb->add_format();
$format1->{Wrap};



my $str =  "NASA must devise a strategy to return Apollo 13 to Earth safely
        after the spacecraft undergoes massive internal damage putting
        the lives of the three astronauts on board in jeopardy.";

$ws->write(0,8,$str);
$ws->write(0,9,10);

#$ws->write(0,5,0);


$ws->write(0,0,"hello hi \n this hso sfs sgsg asg ",$format1);



my $row = 1;


while (my ($k,$v) = each (%{$hash}) ) {
#		print "$k => $v\n";
		my $col = 0;
		$ws->write($row,$col,$k,$format);
		foreach my $kk (sort(keys %{$v} )) {
				$ws->write($row,$col,$kk,$format);
				print "$kk => \n\n\n";
				my $row1 = 1;
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
																	$ws->write($row,$col+1,$kk3);
																	$ws->write($row,$col+2,$v2);
														}	
											}
											$row++;
								}
							#	$row++;
								print "\n";
						} elsif ($kk1 eq 'imdb-info') {
								#print "$kk1\n";
								if (exists $v->{$kk}->{$kk1}->{'score'}) {
					#					print "$v->{$kk}->{$kk1}->{'score'}\n";
										$ws->write($row,$col+3,$v->{$kk}->{$kk1}->{'score'});
										print "$row1\n";
								}
								if (exists $v->{$kk}->{$kk1}->{'url'}) {
					#					print "$v->{$kk}->{$kk1}->{'url'}\n";
										$ws->write($row,$col+4,$v->{$kk}->{$kk1}->{'url'});
								}
								if (exists $v->{$kk}->{$kk1}->{'synopsis'}) {
					#					print "$v->{$kk}->{$kk1}->{'synopsis'}\n";
										$ws->write($row,$col+5,$v->{$kk}->{$kk1}->{'synopsis'});
								}
						} elsif ($kk1 eq 'genre') { 
								#print "$kk1 => 
								foreach my $kk2 (@{$v->{$kk}->{$kk1}}) {
										print "$kk2\n";
										$ws->write($row,$col+6,$kk2);
								}
								$row++;
						}
						else {
								print "$kk1 => $v->{$kk}->{$kk1}\n";
							#	$ws->write($row,$col+6,$v->{$kk}->{$kk1});
						}
			  }
				$row++;
				print "\n";	
		}
}



print "row value = $row\n";
