#!/usr/bin/perl
use strict;
use warnings;

my $xml = <<'EOB';
<people>
    <student>
        <name>
            <first>Alex</first>
            <last>Karelas</last>
        </name>
    </student>
    <student>
        <name>
            <first>John</first>
            <last>Doe</last>
        </name>
    </student>
    <teacher>
        <name>
            <first>Mary</first>
            <last>Poppins</last>
        </name>
    </teacher>
    <teacher>
        <name>
            <first>Peter</first>
            <last>Gabriel</last>
        </name>
    </teacher>
</people>
EOB
 
my $obj = xml_to_object($xml);
my @students = $obj->path('student');
foreach my $student (@students) {
    print $student->path('name/last')->value, "\n";
}
