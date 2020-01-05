#!/usr/bin/perl
use strict;
use warnings;
use Spreadsheet::XLSX;
use JSON;
my (@header,@datarow);
my $kk; 
my $hash;

 
my $excel = Spreadsheet::XLSX -> new ('/home/srm/Downloads/aa.xlsx');
 
foreach my $sheet (@{$excel -> {Worksheet}}) {
			
        #printf("Sheet: %s\n", $sheet->{Name});
				next if ($sheet->{Name} ne 'INSTALLED');
      	#printf("Sheet: %s\n", $sheet->{Name});
        foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) {
       				 my $this_set;
							 my $pri_key; 
             #  foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {
                foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {
                
                     # my $cell = $sheet -> {Cells} [$row] [$col];
                       my $cell = $sheet -> get_cell($row,$col);

											 if (defined $cell) {
                      	   # my $dd = $cell->value();
                      	     my $dd = $cell-> {Val};
                        	  #$datarow[$col] = $dd unless ($dd eq '');
                          	 if ($dd ne '') {
                                $datarow[$col] = $dd;
                         	  }
                   	 	 } else {
                    	     next;
                     	 }
                      ## header
                      if ($row == 0) {
                            $header[$col] = $datarow[$col];
														$kk = $datarow[4];
                      } else {
                            if ($col == 4) {
                                  $pri_key = $datarow[$col];
															  	#	print "$pri_key\n";
                            } else {
                                  my $key = $header[$col];
                                  my $val = $datarow[$col];
                                  $this_set->{$key} = $val;
                            }
                      }
                }
                if ($row > 0) {
                     # push @{$hash->{$pri_key}},$this_set;
											 $$hash{$kk}{$pri_key} = $this_set;
                }				
       }
 
}


use Data::Dumper;

#print Dumper($hash);





####################################################################
#------------------------------------------------------------------#
##                Write a json format                             ##
#------------------------------------------------------------------#
####################################################################

JSON_Write($hash);

sub JSON_Write {
			my $ref = shift;
		#	print Dumper($ref);
			my $json = encode_json($ref);
			print"$json\n";
}






				 

