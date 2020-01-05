#!/bin/perl -w
use strict;

use DBI;
use DBIx::XML_RDB;

my $datasource = "DBI:mysql";
my $userid = "root";
my $password = "srm";
my %attr = (PrintError => 0,
						RiseError => 1
					);

my $dbname = "FTOS";

my $xmlout = DBIx::XML_RDB->new($datasource,
              "ODBC", $userid, $password, $dbname) || die "Failed to make new xmlout";
$xmlout->DoSql("select * from MyTable");
print $xmlout->GetData;
