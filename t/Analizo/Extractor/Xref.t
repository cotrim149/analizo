package t::Analizo::Extractor::Xref;

use base qw(Test::Class);
use Test::More 'no_plan';

use strict;
use warnings;
use File::Basename;

use Analizo::Extractor;

eval ('$Analizo::Extractor::QUIET = 1;');

sub constructor : Tests {
	use_ok('Analizo::Extractor::Xref');
	my $extractor = Analizo::Extractor->load('Xref');
	isa_ok($extractor, 'Analizo::Extractor::Xref');
	isa_ok($extractor, 'Analizo::Extractor');
}

sub has_a_model : Tests {
	isa_ok((Analizo::Extractor->load('Xref'))->model, 'Analizo::Model');
}

sub current_module : Tests {
	my $extractor = Analizo::Extractor->load('Xref');
	
	$extractor->current_module('module1.pl');
	is($extractor->current_module, 'module1.pl', 'must be able to set the current module');

	$extractor->current_module('module2.pm');
	is($extractor->current_module, 'module2.pm', 'must be able to set the current module');
}

__PACKAGE__->runtests;

