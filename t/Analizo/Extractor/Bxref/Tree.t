package t::Analizo::Extractor::Bxref::Tree;
use base qw(Test::Class);
use Test::More;

use strict;
use warnings;
use Analizo::Extractor::Bxref::Tree;

my $tree;

sub before : Test(setup) {
	$tree = new Analizo::Extractor::Bxref::Tree;
}

sub contructor : Tests {
	use_ok('Analizo::Extractor::Bxref::Tree');
	isa_ok($tree,'Analizo::Extractor::Bxref::Tree');
}

sub number_of_global_variables : Tests {
	my @files = ('Person.pm');
	my $num_global_variables;
	
	$tree = $tree->building_tree('Person.pm        (main)           3 (lexical)       $ abc          intro',@files);	
	
	$num_global_variables = $tree->{"Person.pm"}->{"(main)"}->{"global_variables"};

	is($num_global_variables, 1, 'Number of global variables must be 1');		
}

sub file_name : Tests {
	my @files = ('Person.pm');
	my $file;
	
	$tree = $tree->building_tree('Person.pm        Person::setFirstName    25 (lexical)       $ firstName      intro',@files);
	
	foreach (keys %$tree){
		$file = $_;
	}	
	
	is($file,"Person.pm", 'Name of file must be Person.pm');
}

__PACKAGE__->runtests;
