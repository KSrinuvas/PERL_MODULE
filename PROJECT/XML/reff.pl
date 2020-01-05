#!/usr/bin/perl
use strict;
use warnings;
use Excel::Writer::XLSX;

my $workbook = Excel::Writer::XLSX->new('reff.xlsx');

my $worksheet = $workbook->add_worksheet();
my $format = $workbook->add_format();
$format->set_text_wrap();
$worksheet->write(0, 0, "It's\na bum\nwrap", $format);

$worksheet->write(1, 0, "hello sgsgd sg agg\n gsdga ");



$worksheet->write(2, 0, " Young Ender Wiggin is recruited by the International Military
        to lead the fight against the Formics, a genocidal alien race
        which nearly annihilated the human race in a previous invasion." ,$format);
