#!/usr/bin/perl
use strict;
use warnings;
use DBI;
##--------------------------------------------##
##               Write Database               ##
##--------------------------------------------##

## database configuration
my $dsn = "DBI:mysql:FTOS";
my $un = "root";
my $pw = "srm";
my %attr = (PrintError => 0,
						RaiseError => 1);


## connect database 

my $dbh = DBI->connect($dsn,$un,$pw,\%attr);

my @ddl = ("CREATE TABLE GG (s.no int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
						Name VARCHAR(20) NOT NULL,
						Age VARCHAR(25) NOT NULL)");

foreach (@ddl) {
		$dbh->do($_);
}

print "create table successfully\n";

=c
my %ha  = ('Name' => 'ss', 'Age' => 10);



my @key = keys %ha;

my @val = values %ha;



my $sth = $dbh->prepare ("INSERT INTO GG (@key)
													VALUES (@val)");

$sth->execute();



=cut







		 


