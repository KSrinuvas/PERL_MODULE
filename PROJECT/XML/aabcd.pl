#!/usr/bin/perl
use strict;
use warnings;


use Spreadsheet::WriteExcel;

my $workbook = Spreadsheet::WriteExcel->new('perl.xls'); # Step 1
my $worksheet   = $workbook->add_worksheet();         


my $format = $workbook->add_format(
                                    border  => 6,
                                    valign  => 'vcenter',
                                    align   => 'center',
                                  );
 
$worksheet->merge_range('A1:D4', 'Vertical and horizontal', $format);



$worksheet->write('E1', 'Hi Excel!'); 
$workbook->close();
