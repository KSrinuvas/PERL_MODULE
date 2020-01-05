#!/usr/bin/perl
use strict;
use warnings;

use XML::Simple;
use Data::Dumper;
use Excel::Writer::XLSX;
my $file = $ARGV[0];
my $hash = XMLin("$file");

print Dumper($hash);




my $wb = Excel::Writer::XLS







my $row = 0;
while (my ($k,$v) = each (%{$hash}) ) {
	#	print "$k => $v\n";
		foreach my $kk (sort(keys %{$v} )) {
				my $col = 0;
				print "$kk => \n\n\n";
				foreach my $kk1 (sort(keys %{$v->{$kk} } ) ) {
					#	print "$kk1\n";
						if ($kk1 eq 'cast') {
						#		print "$kk1 => $v->{$kk}->{$kk1}\n";
						#	 	print "$kk1 => $v->{$kk}->{$kk1}->{'person'}\n";
								foreach my $kk3 (keys %{$v->{$kk}->{$kk1}->{'person'}} ) {
										#	print "$kk3\n";
											if (exists $v->{$kk}->{$kk1}->{'person'}->{$kk3}) {
														while (my ($k2,$v2) = each (%{$v->{$kk}->{$kk1}->{'person'}->{$kk3}}) ) {
		#															print "$kk3 => $v2\n";
														}			
											}
										
								}
								print "\n";
						} elsif ($kk1 eq 'imdb-info') {
								#print "$kk1\n";
								if (exists $v->{$kk}->{$kk1}->{'score'}) {
#										print "$v->{$kk}->{$kk1}->{'score'}\n";
								}
								if (exists $v->{$kk}->{$kk1}->{'url'}) {
		#								print "$v->{$kk}->{$kk1}->{'url'}\n";
								}
								if (exists $v->{$kk}->{$kk1}->{'synopsis'}) {
		#								print "$v->{$kk}->{$kk1}->{'synopsis'}\n";
								}
						} elsif ($kk1 eq 'genre') { 
								#print "$kk1 => 
								foreach my $kk2 (@{$v->{$kk}->{$kk1}}) {
#										print "$kk2\n";
								}
						#		print "\n";
						}
						else {
	#							print "$kk1 => $v->{$kk}->{$kk1}\n";
						}
			  }
				print "\n";	
		}
}




