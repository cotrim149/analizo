#package Teste;

use strict;
use warnings;

use Data::Dumper qw(Dumper);

my $temp_filename = "Person.pm";
my @array_modules;
my $modules;

open BXREF, "perl -MO=Xref,-r $temp_filename |" or die $!;

print <BXREF>;

foreach (<BXREF>) {
	if($_ =~ m/^\s*Subroutine (\w*)::/ ){
		$modules = Dumper \@array_modules;
		if ($modules =~ m/$1/) {
			next;
		} else {
			push @array_modules, $1;
			print $1."\n";
		 }
	}
}

