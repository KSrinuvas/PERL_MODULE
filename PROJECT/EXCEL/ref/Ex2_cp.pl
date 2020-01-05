#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Spreadsheet::XLSX;
use JSON;
use Text::CSV;
use XML::Writer;
use DBI;
use Data::Dumper;





my ($csv_file,$excel_file,$json_file,$dbi_file,$xml_file,$help);
GetOptions ('Read_EXCEL=s' => \$excel_file,
				    'Write_CSV=s' => \$csv_file,
            'Write_JSON=s' => \$json_file,
            'Write_DBI=s' => \$dbi_file,
            'Write_XML=s' =>  \$xml_file,
            'help|h' => \$help) or die ("Error in command line arguments");


if (not $excel_file)  {
  #  &help();
}

sub help {
    print "$0 is the file name\n";
    my $file = "$0 -Read_EXCEL exmp.xlsx";
    print "To Read the csv file and write any other formats in below\n";
    print " 
    Read_EXECL <Enter the excel file><mandatory>
    Ex : $file
    Write_CSV <Enter the csv file><mandatory>
    Ex : $file -Write_CSV exmp.csv
    Write_JSON <Enter the json file><mandatory>
    Ex : $file -Write_JSON exmp.json
    Write_DBI <Enter the dbi file><mandatory>
    Ex : $file -Write_DBI exmp
    Write_XML <Enter the xml file><mandatory>
    Ex : $file -Write_XML exmp.xml\n";
    exit;   
}

print "hello\n";
 
##############################################################################
##--------------------------------------------------------------------------##
##                Read Excel file build the referance                       ##
##--------------------------------------------------------------------------##
##############################################################################




#my $excel = Spreadsheet::XLSX -> new ('/home/srm/Downloads/aa.xlsx');
my $excel = Spreadsheet::XLSX -> new ('/home/srm/Music/aa/PROJECT/CSV/Emp1.xlsx');

my @data = ();
my $kk; 
my $hash;
foreach my $sheet (@{$excel -> {Worksheet}}) {
				next if ($sheet->{Name} ne 'EMP_DATA');
      	printf("Sheet: %s\n", $sheet->{Name});
        foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) {
							 my @datarow = ();
               foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {
                       my $cell = $sheet -> get_cell($row,$col);
											 if (defined $cell) {
                      	     my $dd = $cell-> {Val};
                          	 if ($dd ne '') {
                                $datarow[$col] = $dd;
                         	  }
                   	 	 } else {
                    	     next;
                     	 }
							}
							print "@datarow\n";
							push(@data,\@datarow);
				}
}




print Dumper(@data);




=c



####################################################################
#------------------------------------------------------------------#
##                Write a json format                             ##
#------------------------------------------------------------------#
####################################################################


Write_Json($hash);

sub Write_Json {
		my $ha = shift;
		open(my $fh,">data.json") || die "Not able to write 'data.json' $!";
		while (my ($k,$v) = each (%{$ha})) {
				#	my $json = encode_json({$k => $v});
					while (my ($k1,$v1) = each (%{$v})) {
							my $json = encode_json({$k => {$k1 => $v1}});
				#			print "$json\n";	
							print $fh "$json\n";
					}
		}
		close($fh);
}
		

####################################################################
#------------------------------------------------------------------#
##                 END of json format                             ##
#------------------------------------------------------------------#
####################################################################





=c


####################################################################
#------------------------------------------------------------------#
##                Write mysql Database format                     ##
#------------------------------------------------------------------#
####################################################################


Write_Dbi($hash);

sub Write_Dbi {
		my $aa = shift;
		## database configuration
		my $dsn = "DBI:mysql:FTOS";
		my $username = "root";
		my $password = "srm";
		my %attr = (
								PrintError => 0,
								RaiseError => 1);
		my $dbh = DBI->connect($dsn,$username,$password,\%attr);
		my @ddl = ("CREATE TABLE HAA (Sno int(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
							 Empid VARCHAR(20) NOT NULL,
							 Name VARCHAR(20) NOT NULL,
							 Age INT(10) NOT NULL,
							 Salary VARCHAR(20) NOT NULL,           
						   Qualification VARCHAR(20) NOT NULL,
							 Exp VARCHAR(20) NOT NULL)");					
		foreach (@ddl) {
					$dbh->do($_);
		}
		print "successfully\n";
	#	$dbh->disconect();
}





				 


############################################################################
#   #------------------------------------------------------------------#   #
#   |                Write CSV format                                  |   #
#   #------------------------------------------------------------------#   #
############################################################################


Write_CSV($hash);

sub Write_CSV {
		my $ref = shift;
		our $count = 0;
		my $aoa = [];
		my (@head,@value,%seen);
		while (my ($k,$v) = each (%{$ref}) ) {
			#	print "$k = > $v\n";
				
				while (my ($k1,$v1) = each (%{$v}) ) {
					#	print "$k1\n";
						foreach my $kk (sort (keys %{$v1})) {
						#			print "$k1 => $kk => $v1->{$kk}\n";
									push(@head,$kk);
									push(@value,$k1,$v1->{$kk});
						}
						@value = grep { !$seen{$_}++ } @value;
						print "@value\n";
					#	push(@{$aoa},\@value);
						@value = ();
						$count++;
				}
				unshift(@head,$k);
				@head = grep { !$seen{$_}++ } @head;
		}
		print "@head\n";
}
		



=cut




############################################################################
#   #------------------------------------------------------------------#   #
#   |                      Write XML format                            |   #
#   #------------------------------------------------------------------#   #
############################################################################


Write_XML('aa.xml',$hash);

sub Write_XML {
		my $file = shift;
		my $ref = shift;
		open(my $fh,">$file") || die "Not able to write '$file' $!"; 
		my $writer = XML::Writer->new( OUTPUT => $fh, DATA_MODE => "true", DATA_INDENT => 2);
		while (my ($k,$v) = each (%{$ref})) {
				print "$k => \n";
				$writer->startTag( 'opt' );
				while (my ($k1,$v1) = each (%{$v}) ) {
						print "     $k1\n";
						$writer->startTag("$k");
						foreach my $kk (sort (keys %{$v1})) {
									print "       $kk => $v1->{$kk}\n";
									$writer->emptyTag("$k1","$kk" => "$v1->{$kk}");
						}
						$writer->endTag();
				}
				$writer->endTag();
				$writer->end();
		}
		close($fh); ## close filehndler
}

	
############################################################################
#                          END XML FILE                                    #
############################################################################



=cut

