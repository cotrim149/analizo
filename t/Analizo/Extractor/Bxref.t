package t::Analizo::Extractor::Bxref;
use base qw(Test::Class);
use Test::More 'no_plan'; # REMOVE THE 'no_plan'

use strict;
use warnings;
use File::Basename;

use Analizo::Extractor;

eval('$Analizo::Extractor::QUIET = 1;'); # the eval is to avoid Test::* complaining about possible typo

sub constructor : Tests {
  use_ok('Analizo::Extractor::Bxref');
  my $extractor = Analizo::Extractor->load('Bxref');
  isa_ok($extractor, 'Analizo::Extractor::Bxref');
  isa_ok($extractor, 'Analizo::Extractor');
}

__PACKAGE__->runtests;
