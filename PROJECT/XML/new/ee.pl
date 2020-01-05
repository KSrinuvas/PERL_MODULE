#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use XML::Simple;

my $file = $ARGV[0];

my $ref = XMLin($file);

print Dumper($ref);


use Excel::Writer::XLSX;

my $wb = Excel::Writer::XLSX->new("dd.xlsx");
my $ws = $wb->add_worksheet('new');






my $row = 0;

while (my ($k,$v) = each (%{$ref}) ) {
		my $col = 0;
		my @head = ();
		my @row;
		my @data;
		$ws->write($row,$col,$k);
	#	print "$k => $v\n";
		if (ref($v) eq 'ARRAY')	{
				foreach (@{$v}) {
			#			print "$_\n";
						while (my ($k1,$v1) = each (%{$_} )) {
							#	print "$k1 => \n";
								$ws->write($row+1,$col,$k1);
								foreach my $o (@{$v1}) {
									#	print "$o\n";
										while (my ($k2,$v2) = each (%{$o}) ) {
											#	print "$k2 => $v2\n";
												push(@head,$k2);
												push(@row,$v2);
											#	$ws->write($row+2,$col++,$k2);
										}
								}
								print "@head\n";
								$ws->write($row+2,$col++,\@head);
							#	print "@row\n";
								print "\n";
								@row = ();
						#		@head = ();
						}
				}
		}
}

