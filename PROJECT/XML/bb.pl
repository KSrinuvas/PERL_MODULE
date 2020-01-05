#!/usr/bin/perl
use strict;
use warnings;
use XML::LibXML;
use JSON;
use Data::Dumper;

my $file = '/home/srm/aa/XML/playlist.xml';
my $dom = XML::LibXML->load_xml(location => $file);
my $hash; 
foreach my $movie ($dom->findnodes('/playlist/movie') )	{
		 my $id = $movie->findvalue('./@id');
		 foreach my $data ($movie->findnodes('./*')) {
				my $name =  $data->nodeName();
				if ($name eq 'cast') {
						foreach my $cast ($data->findnodes('./*')) {
						#  	print $cast->findvalue('./@name'),"  => " ,$cast->findvalue('./@role'),"\n";
								push(@{$$hash{$id}{$name}{$cast->nodeName()}{'Name'}},$cast->findvalue('./@name'));
								push(@{$$hash{$id}{$name}{$cast->nodeName()}{'Role'}},$cast->findvalue('./@role'));
						}
				} elsif ($name eq 'imdb-info') {
		 				my $url_val = $data->findvalue('./@url');
						$$hash{$id}{$name}{'url'} = $url_val;
						foreach my $ins ($data->findnodes('./*') ) {
								#	print $ins->nodeName() , " => " ,$ins->to_literal(),"\n";
								#	print $ins->nodeName , " => " ,$ins->to_literal,"\n";
								$$hash{$id}{$name}{$ins->nodeName()} =  $ins->to_literal();
						}
				} elsif ($name eq 'genre') {
						push(@{$$hash{$id}{$name}},$data->textContent());
						$data->removeChildNodes();
						$data->appendText('SUBBA');
				} else {
						$$hash{$id}{$data->nodeName()} = $data->textContent();
				}
	   }
}
#print Dumper($hash);



open(OUT,"+>test.xml");
#print OUT $dom->toString();
close(OUT);




##----------------------------------------------------------------##
##                      Write a json format                       ##
##----------------------------------------------------------------##

Write_json($hash);


sub Write_json {
			my $ref = shift;
			open(my $fh,'>aa.json') || die "Not able to open file $!";
			foreach my $dd (%{$ref}) {
			#		print Dumper($dd);
					my $js_for = encode_json($dd);
					#print "$js_for\n";
					#print $fh "$js_for\n";
			}
		#	my $js_for = encode_json($ref);
		#	print $fh "$js_for";
			close($fh);
}
			
			

##-----------------------------------------------------------------##
##----------------------- END JSON FORMAT -------------------------##
##-----------------------------------------------------------------##
=c

open( my $fh, '<', 'aa.json' );
my $json_text   = <$fh>;
my $perl_scalar = decode_json( $json_text );

#print Dumper($perl_scalar);

=cut






##----------------------------------------------------------------##
##                      Write a csv format                        ##
##----------------------------------------------------------------##


use Text::CSV;

my $csv = Text::CSV->new();


Write_csv($hash);

sub Write_csv {
		my $ref = shift;
#		print Dumper($hash);
}


##----------------------------------------------------------------##
##                   End csv format                               ##
##----------------------------------------------------------------##



##-----------------------------------------------------------------##
##                    
##-----------------------------------------------------------------##

use Excel::Writer::XLSX;
my $wb = Excel::Writer::XLSX->new('bb.xlsx');
my $ws = $wb->add_worksheet('DATA');
my $format = $wb->add_format();
$format->set_color('red');



#cc($hash);

=c

my $hh_row;
sub cc {
		my $hh_col = 0;
		my $hh_row = 0;
		my $row = 0;
		my $ref = shift;
	#	print Dumper($ref);
		$ws->write(0,0,'id',$format);
		while (my ($k,$v) = each (%{$ref}) ) {
			#	print "$k => $v\n";
				my $col = 0;
				$ws->write($row+1,$col,$k,$format);
				if (ref($v) eq 'HASH') {
						foreach my $kk (sort(keys %{$v})) {
								if (ref($v->{$kk}) eq 'ARRAY')	{
										foreach my $pp (@{$v->{$kk}}) {
												print "$pp\n";
												if ($row == 0) {
														$ws->write($row,6,$kk,$format);
												} else {
														$ws->write($row,$col+5,$kk,$format);
														$col++;
												}
												print "$row,$col\n";
										}
								#		print "$kk => $v->{$kk}\n";
								} elsif (ref($v->{$kk}) eq 'HASH') {
								#		print "$kk => $v->{$kk}\n";
								} else {
									#	print "$kk => $v->{$kk}\n";
										if ($row == 0) {
												$ws->write($row,$col+1,$kk,$format);
											  $ws->write($row+1,$col+1,$v->{$kk},$format);
												$col++;
										} else {
												$ws->write($row+1,$col+1,$v->{$kk},$format);
												$col++;	
											#	$hh_col +=$col;
											#	print "$row,$col\n";
										}
								}
						}
						print "\n";
				}
				$col++;	
			#	print "$row,$hh_col\n";
				$row++;
		}
}

=cut




my $row = 1;
$ws->write($row,0,'id',$format);
while (my ($k,$v) = each (%{$hash}) ) {
		print "$k => $v\n";
		my $col = 0;
	#	$ws->write($row,$col,$k,$format);
		foreach my $kk (keys %{$v}) {
				if (ref($v->{$kk}) eq 'HASH') { 
		 			#	print "$kk => $v->{$kk}\n";
						foreach my $kk1 (keys %{$v->{$kk}}) {
								if (ref($v->{$kk}->{$kk1}) eq 'HASH') {
										foreach my $kk2 (keys  %{$v->{$kk}->{$kk1}}) {
											#	print "$kk2 => $v->{$kk}->{$kk1}->{$kk2}\n";
											 # $ws->write($row+1,$col,$kk2);
												if (ref($v->{$kk}->{$kk1}->{$kk2}) eq 'ARRAY') {
														print "$kk2\n";
														foreach my $kk3 (@{$v->{$kk}->{$kk1}->{$kk2}}) {
																	$ws->write($row,$col,$k,$format);
																	$ws->write($row,$col,$kk3);
														#			print "$kk3\n";
														}
														$row++;
													#	print "\n";
												}
										}	
										next;
							  }			
							#	print "$kk1 => $v->{$kk}->{$kk1}\n";
						}
				} elsif (ref($v->{$kk}) eq 'ARRAY') {
						foreach my $kk4 (@{$v->{$kk}}) {
						#		print "$kk4\n";
						}
		 			#	print "$kk => $v->{$kk}\n";
					#	print "\n";
				} else {
					#	print "$kk => $v->{$kk}\n";
				}
		}
		$row++;
		print "\n";		
}
