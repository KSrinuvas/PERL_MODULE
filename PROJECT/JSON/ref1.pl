#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use DBI;

my $abc = [
				  	['Empid','Name','Age','Salary','Qualification','Exp'],
				  	['SRM01','SUNIL',20,'25K','B.tech','2Years'],
				  	['SRM02','CHANDU',22,'50k','M.tech','4Years'],
				  	['SRM03','RAM',24,'40K','M.sc','3Years'],
				  	['SRM04','RAVI',22,'35k','M.ca','2Years']
					];
	






#print Dumper($abc);


Read_Db($abc);
	
sub Read_Db {
		my $ref = shift;
		my $head = shift(@{$ref});
#		print Dumper($head);
		
		## mysql database configuration
		my $dsn  = "DBI:mysql:FTOS";
		my $un = "root";
		my $pw = "srm";
		my %attr = (PrintError => 0,
								RaiseError => 1);		

		## connect database 
		my $dbh = DBI->connect($dsn,$un,$pw,\%attr);
		print "connect database successfully\n";

		my $size = @{$head};
		my $str = "?," x $size;
		chop($str);

		print "$str\n";

		my $sth = $dbh->prepare("INSERT INTO ABCD 
														VALUES (?,?,?,?,?,?) ");
		
		$sth->execute('SRM02','CHANDU',22,'50k','M.tech','4Years');
		
		$str->finish();
		$dbh->disconnect();
		print "insert the table values successfully\n";
		print "--------------------------------------\n";

}
















	
