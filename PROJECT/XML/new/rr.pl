#!/usr/bin/perl
use strict;
use warnings;

#!/usr/bin/perl
# This script converts a XML file to CSV format.

# Load the AnyData XML to CSV conversion modules
use XML::Parser;
use XML::Twig;
use AnyData;
my $file = $ARGV[0];
my $input_xml = "$file";
my $output_csv = "test4.csv";


#my $flags->{record_tag} = "movie";
#$flags->{record_tag} = "cast";
my $flags->{record_tag} = "imdb-info";
adConvert( 'XML', $input_xml, 'CSV', $output_csv, $flags );
