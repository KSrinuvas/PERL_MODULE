#!/usr/bin/perl
use strict;
use warnings;

use JSON;
use XML::Simple;
binmode STDOUT, ":utf8";
use utf8;
use Data::Dumper;


my $file = $ARGV[0];

# Read input file in json format
my $json;
open my $fh, "<", "$file";
while (my $line = <$fh>)	{
		chomp($line);
		my $data = decode_json($line);
		Write($data);
}

 

#print Dumper($data);

# Output as XML

#print "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n";
sub Write {
		my $data = shift;
		print XMLout($data);
}
#print "\n";













#####------------------------------------------------------------------#####


use warnings;
use strict;
use Text::CSV;
use JSON::MaybeXS;
use FileHandle ;
use IO::Handle;

local( $/, *FH ) ;
open( FH, '<', '$file' );
my $text = <FH>;

my $data = decode_json($text);

my $csv = Text::CSV->new({auto_diag=>2,binary=>1, eol=>"\n", always_qu
+ote=>1 });

my @fields = qw/ Timestamp    Average         Unit /;
$csv->print(select, \@fields);
for my $datapoint ( @{ $data->{Datapoints} } ) {
    $csv->print(select, [ map {$datapoint->{$_}} @fields ]);
}




#####------------------------------------------------------------------#####
