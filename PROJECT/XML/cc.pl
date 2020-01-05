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
					#	$data->removeChildNodes();
					#	$data->appendText('SUBBA');
				} else {
						$$hash{$id}{$data->nodeName()} = $data->textContent();
				}
	   }
}
print Dumper($hash);



#open(OUT,"+>test.xml");
#print OUT $dom->toString();
#close(OUT);


##-----------------------------------------------------------------##
##                    
##-----------------------------------------------------------------##

use Excel::Writer::XLSX;
my $wb = Excel::Writer::XLSX->new('cc.xlsx');
my $ws = $wb->add_worksheet('DATA');
my $format = $wb->add_format();
$format->set_color('red');


my $Row = 0;
while (my ($k,$v) = each (%{$hash}))  {
			my $Col = 0;
			foreach my $kk (keys %{$v}) {
					if (ref($v->{$kk}) eq 'HASH')	{
							#	print "$kk => $v->{$kk}\n";
								foreach my $kk1 (sort(keys %{$v->{$kk}})) {
											if (ref($v->{$kk}->{$kk1}) eq 'HASH') {
													my $row = 1;
													foreach my $kk2 (keys %{$v->{$kk}->{$kk1}}) {
															my $col = 1;
														#	print "$kk2\n";
															if ($kk2 eq 'Name') {
																#	$ws->write($Row,$Col+1,$kk2);
															#		print "$kk2 => @{$v->{$kk}->{$kk1}->{$kk2}}\n";
																	foreach (@{$v->{$kk}->{$kk1}->{$kk2}}) {
																			$ws->write($row,$col,$_);
																	}
																	$row++;
															} else {
																	$ws->write($Row,$Col+2,$kk2);
																	print "$kk2 => @{$v->{$kk}->{$kk1}->{$kk2}}\n";
																	foreach (@{$v->{$kk}->{$kk1}->{$kk2}}) {
																			$ws->write($row,$col+1,$_);
																	}
																	$row++;
															}
														#	$row++;
													}
													print "\n";
													next;
											 }
											#	print "$kk1 => $v->{$kk}->{$kk1}\n";
								}
					}
			}
}

