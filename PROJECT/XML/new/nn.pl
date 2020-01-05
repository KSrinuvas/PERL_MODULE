#!/usr/bin/perl
use strict;
use warnings;

use XML::Simple;
use Data::Dumper;

my $file = $ARGV[0];

use Excel::Writer::XLSX;

my $workbook = Excel::Writer::XLSX->new("abcd.xlsx");
my $worksheet = $workbook->add_worksheet('new');

my $format = $workbook->add_format();


my $ref = XMLin("$file");

print Dumper($ref);

=c

my @array = qw(title director release-date mpaa-rating running-time genre cast person role imdb-info  id imdb-info url synopsis score);
print "@array\n";
my $row = 0;
while (my ($k,$v) = each (%{$ref}) ) {
	#	print "$k => $v\n";
		while (my ($k1,$v1) = each (%{$v}) ) {
	#			print "$k1 => $v1\n";
				my $col = 0;
				while (my ($k2,$v2) = each (%{$v1}) ) {
						if (ref($v2) eq 'ARRAY') {
     					#	print "$k2 => @{$v2}\n";
								my $mm = join(',',@{$v2});
								print "$k2 => $mm\n";
						} elsif (ref($v2) eq 'HASH') {
									while (my ($k3,$v3) = each (%{$v2}) ) {
											if (ref($v3) eq 'HASH') {
												#		print "$k3 => $v3\n";
														while (my ($k4,$v4) = each (%{$v3}) ) {
														#		print "$k4 => $v4\n";
																while (my ($k5,$v5) = each (%{$v4}) ) {
															#			print " $k => $k1 => $k2 => $k3 => $k4 => $k5 => $v5\n";
																}
														}
											} else {
											   # 	print "$k3 => $v3\n";			
											}	
									}
								#	print "\n\n";
						} else {
			  					print "$k2 => $v2\n";
											if ($row == 0) {
														$worksheet->write($row,$col++,$k2);
											} else {
													print "$k2 => \n";
													$worksheet->write($row,$col++,$$v1{$k2});
	  									}
									}
						}
						print"\n";
				}
				$row++;
				print "\n";
}


=cut



my $workbook1 = Excel::Writer::XLSX->new("cd.xlsx");

my $format1 = $workbook->add_format(); # Add a format
$format1->set_bold();
$format1->set_color('red');
$format1->set_align('center');




my @head = qw(title director release-date running-time mpaa-rating);
my $worksheet1 = $workbook1->add_worksheet('second');
my $row = 0;
while (my ($k,$v) = each (%{$ref}) ) {
		my $col = 0;
		#$worksheet1->write(0,0,$k,$format1);
		print "$k => $v\n\n";
		foreach my $kk (sort(keys %{$v})) {
		#		print "$kk => $v->{$kk}\n\n";
				foreach my $kk1 (sort(keys %{$v->{$kk}})) {
						#	print "$kk1 => $v->{$kk}->{$kk1}\n";
							if (ref($v->{$kk}->{$kk1}) eq 'HASH') {
										foreach my $kk2 (sort(keys %{$v->{$kk}->{$kk1}})) {
													if (ref($v->{$kk}->{$kk1}->{$kk2}) eq 'HASH') {
															foreach my $kk3 (sort(keys %{$v->{$kk}->{$kk1}->{$kk2}}) ) {
																#		print "$kk3 => $v->{$kk}->{$kk1}->{$kk2}->{$kk3}\n";
																		foreach my $kk4 (sort(keys %{$v->{$kk}->{$kk1}->{$kk2}->{$kk3} }) )	{
																					print "$kk4 => $v->{$kk}->{$kk1}->{$kk2}->{$kk3}->{$kk4}\n";
																		}
															}
															next;	
													} 
												#	print "$kk2 => $v->{$kk}->{$kk1}->{$kk2}\n";
										}
							} elsif (ref($v->{$kk}->{$kk1}) eq 'ARRAY') {
			
							} else {
									#	print "$kk1 => $v->{$kk}->{$kk1}\n";
							}
				}
				print "\n";
		}
}




