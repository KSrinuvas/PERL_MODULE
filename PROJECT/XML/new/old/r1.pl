#!/usr/bin/perl
use strict;
use warnings;

use XML::Simple;
use Data::Dumper;
use Excel::Writer::XLSX;
my $file = '/home/srm/Downloads/playlist.xml';
my $ref = XMLin("$file");

#print Dumper($ref);



## Excel workbook
my $wb = Excel::Writer::XLSX->new("aa2.xlsx");
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

Write_EXCEL($ref);
sub Write_EXCEL {
		my $hash = shift;
    my $row = 1;
    while (my ($k,$v) = each (%{$hash}) ) {
    	#	print "$k => $v\n";
    		my $rr = 1;
    		my $rr1 = 1;
    		my $rr2 = 1;
    		foreach my $kk (sort(keys %{$v} )) {
    				my $col = 0;
    				my $col1 = 1;	
    				print "$kk => \n\n\n";
    				$ws->write($row,$col,$kk,$format2);
    				foreach my $kk1 (sort(keys %{$v->{$kk} } ) ) {
    					#	print "$kk1\n";
    						
    						if ($kk1 eq 'cast') {
    								$rr = $row;
    								$rr1 = $row;
    								$rr2 = $row;
    						#		print "$kk1 => $v->{$kk}->{$kk1}\n";
    						#	 	print "$kk1 => $v->{$kk}->{$kk1}->{'person'}\n";
    								foreach my $kk3 (keys %{$v->{$kk}->{$kk1}->{'person'}} ) {
    		#									print "$kk3\n";
    											$ws->write($row,$col+6,$kk3);
    											if (exists $v->{$kk}->{$kk1}->{'person'}->{$kk3}) {
    														while (my ($k2,$v2) = each (%{$v->{$kk}->{$kk1}->{'person'}->{$kk3}}) ) {
    																#	print "$kk3 => $v2\n";
    																	$ws->write($row,$col+7,$v2);
    																#	print "$k2 => $v2\n";
    														}
    											}
    											$row++;
    								}
    						#		print "\n";
    						} elsif ($kk1 eq 'imdb-info') {
    								#print "$kk1\n";
    								if (exists $v->{$kk}->{$kk1}->{'score'}) {
    										print "$v->{$kk}->{$kk1}->{'score'}\n";
    										$ws->write($rr2,$col+9,$v->{$kk}->{$kk1}->{'score'});
    								}
    								if (exists $v->{$kk}->{$kk1}->{'url'}) {
    										print "$v->{$kk}->{$kk1}->{'url'}\n";
    										$ws->write($rr2,$col+10,$v->{$kk}->{$kk1}->{'url'});
    								}
    								if (exists $v->{$kk}->{$kk1}->{'synopsis'}) {
    										print "$v->{$kk}->{$kk1}->{'synopsis'}\n";
    										$ws->write($rr2,$col+11,$v->{$kk}->{$kk1}->{'synopsis'},$format1);
    								}
    						} elsif ($kk1 eq 'genre') { 
    								#print "$kk1 => 
    								foreach my $kk2 (@{$v->{$kk}->{$kk1}}) {
    										$ws->write($rr1,$col+8,$kk2);
    #										print "$kk2\n";
    										$rr1++;
    								}
    						#		print "\n";
    						}
    						else {
    	#							print "$kk1 => $v->{$kk}->{$kk1}\n";
    						  	$ws->write($rr,$col1,$v->{$kk}->{$kk1});
    								$col1++;
    						}
    			  }
    				$rr++;
    				$row++;
    				print "\n";	
    		}
    }
}






