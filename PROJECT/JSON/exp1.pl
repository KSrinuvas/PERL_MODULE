#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use DBI;
use Data::Dumper;

##----------------------------------------##
##          Read json file                ##
##----------------------------------------##


my $array_hash;
open(my $fh,"/home/srm/aa/PROJECT/CSV/Emp_hash.json") || die "Not able to open file $!";
Read_Json($fh);
sub Read_Json {
		my $fh = shift;		
    my $json = JSON->new();
    while (my $line = <$fh>) {
    		chomp($line);
    		my $hash = $json->decode($line);
    		push(@{$array_hash},$hash);
    }
}

#print Dumper($array_hash);

## close filehandle
close($fh);


##--------------------------------------------------------##
##                                                        ##
##--------------------------------------------------------##
=c
Write_Dbi(@array);




## write database

sub Write_Dbi {
#		print "@array\n";
		my @keys;
		foreach my $href (@array) {
				@keys = sort(keys %{$href});
		}
	#	print "@keys\n";
		for (my $i = 0; $i < @keys; $i++) {
#				print "$keys[$i] \n";
		}
}
				
=cut	



##########################################################################
##----------------------------------------------------------------------##
##                       Write Database                                 ##
##----------------------------------------------------------------------##
##########################################################################



			
Write_DBI($array_hash);

sub Write_DBI {
		my $aoh = shift;
		#print Dumper($aoh);
		 
		 ## connect database configuration 
		 my $dsn = "DBI:mysql:FTOS";
		 my $uname = "root";
		 my $pw = "srm";
		 my %attr = (PrintError => 0,
								RaiseError => 1
								);
			
		 ## connect database 
		 my $dbh = DBI->connect($dsn,$uname,$pw,\%attr);
	
		 print "CONNECT database\n";
		# my $sth; 
		 foreach my $h1 (@{$aoh}) {
			#		print %$h1,"\n";
				#	my @key = keys %{$h1};
				#	my @val = values %{$h1};
				#	print "@key\n";
			   	my @ab = ();
					my @kk1 = ();
					foreach my $pp (sort(keys %{$h1})) {
							push(@kk1,$pp);
							#print "$pp => $h1->{$pp}\n";
						  my $kk = $$h1{$pp};
							push(@ab,$kk);
					}
				#	print "INsert values successfully\n"; 
					print "@kk1\n";
          print "@ab\n";
					print"\n";
		 }
		 my @ah = qw(Empid Name Age Salary Qualification Exp);
		 my $sth = $dbh->prepare("INSERT INTO `ABCD` 
														VALUES (?,?,?,?,?,?)" );
		 $sth->execute('SRM01','SUNIL',22,'25K','BE','1year');
		 print "insert successfully\n";
		 $sth->finish();
		 $dbh->disconnect();
}




## 


