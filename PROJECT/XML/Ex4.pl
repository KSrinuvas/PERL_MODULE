#!/usr/bin/perl
use strict;
use warnings;

use XML::MyXML qw(tidy_xml xml_to_object);
use XML::MyXML qw(:all);
 
my $xml = "<item><name>Table</name><price><usd>10.00</usd><eur>8.50</eur></price></item>";
print tidy_xml($xml);
