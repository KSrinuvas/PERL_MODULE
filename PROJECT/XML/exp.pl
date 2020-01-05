#!/usr/bin/perl
use strict;
use warnings;
use XML::LibXML;
use JSON;
use Data::Dumper;

my $file = '/home/srm/aa/XML/playlist.xml';
my $dom = XML::LibXML->load_xml(location => $file);
my $hash; 
foreach my $movie ($dom->findnodes('/playlist/movie') )	{
		 my $id = $movie->findvalue('./@id');
		 foreach my $data ($movie->findnodes('./*')) {
				my $name =  $data->nodeName();
				if ($name eq 'cast') {
						foreach my $cast ($data->findnodes('./*')) {
						#  	print $cast->findvalue('./@name'),"  => " ,$cast->findvalue('./@role'),"\n";
								push(@{$$hash{$id}{$name}{$cast->nodeName()}{'Name'}},$cast->findvalue('./@name'));
								push(@{$$hash{$id}{$name}{$cast->nodeName()}{'Role'}},$cast->findvalue('./@role'));
						}
				} elsif ($name eq 'imdb-info') {
		 				my $url_val = $data->findvalue('./@url');
						$$hash{$id}{$name}{'url'} = $url_val;
						foreach my $ins ($data->findnodes('./*') ) {
								#	print $ins->nodeName() , " => " ,$ins->to_literal(),"\n";
								#	print $ins->nodeName , " => " ,$ins->to_literal,"\n";
								$$hash{$id}{$name}{$ins->nodeName()} =  $ins->to_literal();
						}
				} elsif ($name eq 'genre') {
						push(@{$$hash{$id}{$name}},$data->textContent());
						$data->removeChildNodes();
						$data->appendText('SUBBA');
				} else {
						$$hash{$id}{$data->nodeName()} = $data->textContent();
				}
	   }
}
print Dumper($hash);



open(OUT,"+>test.xml");
print OUT $dom->toString();
close(OUT);




##----------------------------------------------------------------##
##                      Write a json format                       ##
##----------------------------------------------------------------##

Write_json($hash);


sub Write_json {
			my $ref = shift;
			open(my $fh,'>aa.json') || die "Not able to open file $!";
			foreach my $dd (%{$ref}) {
			#		print Dumper($dd);
					my $js_for = encode_json($dd);
					print "$js_for\n";
					print $fh "$js_for\n";
			}
		#	my $js_for = encode_json($ref);
		#	print $fh "$js_for";
			close($fh);
}
			
			

##-----------------------------------------------------------------##
##----------------------- END JSON FORMAT -------------------------##
##-----------------------------------------------------------------##
=c

open( my $fh, '<', 'aa.json' );
my $json_text   = <$fh>;
my $perl_scalar = decode_json( $json_text );

#print Dumper($perl_scalar);

=cut






##----------------------------------------------------------------##
##                      Write a csv format                        ##
##----------------------------------------------------------------##


use Text::CSV;

my $csv = Text::CSV->new();


Write_csv($hash);

sub Write_csv {
		my $ref = shift;
		print Dumper($hash);
}


##----------------------------------------------------------------##
##                   End csv format                               ##
##----------------------------------------------------------------##



##-----------------------------------------------------------------##
##                    
##-----------------------------------------------------------------##

