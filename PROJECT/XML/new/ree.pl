use strict;
use warnings;

my $file = $ARGV[0];

use Spreadsheet::WriteExcel::FromXML;
Spreadsheet::WriteExcel::FromXML->XMLToXLS( "file.xml", "file.xls" );
