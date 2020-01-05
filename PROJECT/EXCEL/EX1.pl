#!/usr/bin/perl
use strict;
use warnings;
use Spreadsheet::XLSX;


##-----------------------------------------##
##        Read excel file                  ##
##-----------------------------------------##



my $workbook = Spreadsheet::XLSX->new('/home/srm/Downloads/aa.xlsx');



my @datarow;
my $hash;
my @header;
#foreach my $sheet (@{$workbook -> {Worksheet}}) {
foreach my $sheet ($workbook->worksheets()) {
      #printf("Sheet: %s\n", $sheet->{Name});
			next if ($sheet->{Name} ne 'INSTALLED');
 #    printf("Sheet: %s\n", $sheet->{Name});
			foreach my $row ( $sheet -> {MinRow} .. $sheet -> {MaxRow} ) {
							my %this_set;
							my $pri_key;
							foreach my $col ( $sheet -> {MinCol} ..$sheet -> {MaxCol} ) {
										my $cell = $sheet ->{Cells} [$row] [$col];
										if (defined $cell) {
												my $val =  $cell -> {Val};
												next if ($val ne '');
												$datarow[$col] = $val;										
										} else {
												next;
										}
							}
			 }
}

