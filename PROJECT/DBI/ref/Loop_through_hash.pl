#!/usr/bin/perl
use strict;
use warnings;


use XML::Simple;
use Data::Dumper;

my $xml = XMLin("/home/srm/Downloads/playlist.xml");

print Dumper $xml;
