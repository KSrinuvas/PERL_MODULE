#!/usr/bin/perl
use strict;
use warnings;

use XML::Simple;
use Data::Dumper;
use Excel::Writer::XLSX;
my $file = '/home/srm/Downloads/playlist.xml';
my $hash = XMLin("$file");
use Text::CSV qw(csv);
use DBI;
##print Dumper($hash);

=c

## Excel workbook
my $wb = Excel::Writer::XLSX->new("aa1.xlsx");
## Excel worksheet
my $ws = $wb->add_worksheet('PLAYLIST');

## Add Excel formats 
my $format = $wb->add_format();
$format->set_color('red');

my $format1 = $wb->add_format();
$format1->{Wrap};

my $format2 = $wb->add_format();
$format2->set_color('blue');

my @Header = qw(movie_id director mpaa-rating release-date running-time title Name Role genre score url synopsis);
$ws->write('A1', \@Header,$format);



my $row = 1;
while (my ($k,$v) = each (%{$hash}) ) {
	#	#print "$k => $v\n";
		my $rr = 1;
		my $rr1 = 1;
		my $rr2 = 1;
		foreach my $kk (sort(keys %{$v} )) {
				my $col = 0;
				my $col1 = 1;	
				#print "$kk => \n\n\n";
				$ws->write($row,$col,$kk,$format2);
				foreach my $kk1 (sort(keys %{$v->{$kk} } ) ) {
					#	#print "$kk1\n";
						
						if ($kk1 eq 'cast') {
								$rr = $row;
								$rr1 = $row;
								$rr2 = $row;
						#		#print "$kk1 => $v->{$kk}->{$kk1}\n";
						#	 	#print "$kk1 => $v->{$kk}->{$kk1}->{'person'}\n";
								foreach my $kk3 (keys %{$v->{$kk}->{$kk1}->{'person'}} ) {
		#									#print "$kk3\n";
											$ws->write($row,$col+6,$kk3);
											if (exists $v->{$kk}->{$kk1}->{'person'}->{$kk3}) {
														while (my ($k2,$v2) = each (%{$v->{$kk}->{$kk1}->{'person'}->{$kk3}}) ) {
																#	#print "$kk3 => $v2\n";
																	$ws->write($row,$col+7,$v2);
																#	#print "$k2 => $v2\n";
														}
														
											}
											$row++;
								}
						#		#print "\n";
						} elsif ($kk1 eq 'imdb-info') {
								##print "$kk1\n";
								if (exists $v->{$kk}->{$kk1}->{'score'}) {
										#print "$v->{$kk}->{$kk1}->{'score'}\n";
										$ws->write($rr2,$col+9,$v->{$kk}->{$kk1}->{'score'});
								}
								if (exists $v->{$kk}->{$kk1}->{'url'}) {
										#print "$v->{$kk}->{$kk1}->{'url'}\n";
										$ws->write($rr2,$col+10,$v->{$kk}->{$kk1}->{'url'});
								}
								if (exists $v->{$kk}->{$kk1}->{'synopsis'}) {
										#print "$v->{$kk}->{$kk1}->{'synopsis'}\n";
										$ws->write($rr2,$col+11,$v->{$kk}->{$kk1}->{'synopsis'},$format1);
								}
						} elsif ($kk1 eq 'genre') { 
								##print "$kk1 => 
								foreach my $kk2 (@{$v->{$kk}->{$kk1}}) {
										$ws->write($rr1,$col+8,$kk2);
#										#print "$kk2\n";
										$rr1++;
								}
						#		#print "\n";
						}
						else {
	#							#print "$kk1 => $v->{$kk}->{$kk1}\n";
						  	$ws->write($rr,$col1,$v->{$kk}->{$kk1});
								$col1++;
						}
			  }
				$rr++;
				$row++;
				#print "\n";	
		}
}


=cut






my @DATA = ();



while (my ($k,$v) = each (%{$hash}) ) {
	#	#print "$k => $v\n";
		foreach my $kk (sort(keys %{$v} )) {
				#print "$kk => \n\n\n";
				my @data = ();
				push(@data,$kk);
				foreach my $kk1 (sort(keys %{$v->{$kk} } ) ) {
					#	#print "$kk1\n";
						if ($kk1 eq 'cast') {
						#		#print "$kk1 => $v->{$kk}->{$kk1}\n";
						#	 	#print "$kk1 => $v->{$kk}->{$kk1}->{'person'}\n";
								my @nn = ();
								my @rl = ();
								foreach my $kk3 (keys %{$v->{$kk}->{$kk1}->{'person'}} ) {
											#print "$kk3\n";
											if (exists $v->{$kk}->{$kk1}->{'person'}->{$kk3}) {
														while (my ($k2,$v2) = each (%{$v->{$kk}->{$kk1}->{'person'}->{$kk3}}) ) {
																#	print "$kk3 => $v2\n";
																	#print "$k2 => $v2\n";
														 			push(@nn,$kk3);
														 			push(@rl,$v2);
														}	
											}
								}
						#		print "@nn\n";
						#		print "@rl\n";
								my $str1 = join(",",@nn);
								my $str2 = join(",",@rl);
							#	push(@data,\@nn,\@rl);
							
								push(@data,$str1,$str2);
						#		#print "\n";
						} elsif ($kk1 eq 'imdb-info') {
								##print "$kk1\n";
								if (exists $v->{$kk}->{$kk1}->{'score'}) {
										#print "$v->{$kk}->{$kk1}->{'score'}\n";
										push(@data,$v->{$kk}->{$kk1}->{'score'});
								}
								if (exists $v->{$kk}->{$kk1}->{'url'}) {
										#print "$v->{$kk}->{$kk1}->{'url'}\n";
										push(@data,$v->{$kk}->{$kk1}->{'url'});
								}
								if (exists $v->{$kk}->{$kk1}->{'synopsis'}) {
										#print "$v->{$kk}->{$kk1}->{'synopsis'}\n";
										push(@data,$v->{$kk}->{$kk1}->{'synopsis'});
								}
						} elsif ($kk1 eq 'genre') { 
								##print "$kk1 =>
								#push(@data,$v->{$kk}->{$kk1});
								my $str4 = join(' & ',@{$v->{$kk}->{$kk1}});
								print "$str4\n";
								foreach my $kk2 (@{$v->{$kk}->{$kk1}}) {
#										#print "$kk2\n";
									#	push(@data,$kk2);
								}
								push(@data,$str4);
						#		#print "\n";
						}
						else {
								#print "$kk1 => $v->{$kk}->{$kk1}\n";
								push(@data, $v->{$kk}->{$kk1});
						}
			  }
				print Dumper(\@data);	
				#print "\n";
				push(@DATA,\@data);
		}
}




#print Dumper(\@DATA);	








Write_CSV(\@DATA);

sub Write_CSV {
		my $hh = shift;
		foreach my $kk (@{$hh}) {
				#	print "$kk\n";
					foreach my $kk1 (@{$kk}) {
							if (ref($kk1) eq 'ARRAY') {
									print "@{$kk1}\n";
							} else {
									print "$kk1\n";
							}
							
					}
		}
}








my $dd = Text::CSV->new('aa.csv');


my @head = qw(movie_id Name Role director genre score url synopsis mpaa_rating release_date running_time title);

unshift(@DATA,\@head);

#print Dumper(\@DATA);
my $aoa = \@DATA;


# Write array of arrays as csv file
csv (in => $aoa, out => "file.csv", sep_char=> ";");





Write_DBI($aoa);


sub Write_DBI {
  my $ref =  shift;  
  my @links = @{$ref};
  # MySQL database configurations
  my $dsn = "DBI:mysql:FTOS";
  my $username = "root"; 
  my $password = 'srm';
  
  # connect to MySQL database
  my %attr = (PrintError=>0,RaiseError=>1 );
  my $dbh = DBI->connect($dsn,$username,$password,\%attr);
  
 	print "connect successfully\n";
	my $head = shift(@links);
	my $size = @{$head};
	my $str = "?," x $size;
	chop($str);
  
  # insert data into the links table
  my $sql = "INSERT INTO XML_CON 
         VALUES($str)";
 
  my $stmt = $dbh->prepare($sql); 
  # execute the query
  foreach my $link(@links){
    $stmt->execute(@{$link});
  }
	print "inset the data successfully\n";
  $stmt->finish();
  # disconnect from the MySQL database
  $dbh->disconnect();

}


 
