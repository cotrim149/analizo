package t::Analizo::Extractor::Tree;
use base qw(Test::Class);
use Test::More;
#use Analizo::Extractor::Bxref::Tree;

use strict;
use warnings;
use Analizo::Extractor;

#eval('$Analizo::Extractor::Bxref::Tree::QUIET = 1;'); # the eval is to avoid Test::* complaining about possible typo

sub contructor : Tests {
	use_ok('Analizo::Extractor::Bxref::Tree');
	my $tree = new Analizo::Extractor::Bxref::Tree();
	isa_ok($tree,'Analizo::Extractor::Bxref::Tree');
}

__PACKAGE__->runtests;
