#!/usr/bin/perl

use strict;
use warnings;
use DBI;

my $dbh = DBI->connect(
    'DBI:mysql:database=FTOS;host=localhost',
    'root',
    'srm',
    { RaiseError => 1, AutoCommit => 1 },
);

my $sql = 'INSERT INTO foo (Item1,Item2,Item3,Item4) VALUES (?,?,?,?)';
my $sth = $dbh->prepare($sql);

while (<DATA>){
    chomp;
    my @vals = split /\s+/, $_;
    $sth->execute(@vals);
}


__END__
A B C D
E F G H
