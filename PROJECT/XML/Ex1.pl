#!/usr/bin/perl
use strict;
use warnings;
use XML::Writer;

my $writer = new XML::Writer();  # will write to stdout
$writer->startTag("greeting", 
                  "class" => "simple");
$writer->characters("Hello, world!");
$writer->endTag("greeting");
$writer->end();
