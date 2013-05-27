package Analizo::Batch::Output::yaml2csv;
use strict;
use warnings;
use base qw(Test::Analizo::Class);
use Test::More 'no_plan';
use Test::Analizo;

use Analizo::Batch::Output::yaml2csv;

sub constructor : Tests {
  my $yaml2csv = yaml2csv->new("samples/hello_world/java-detaisl.yml"); 
  isnt($yaml2csv, undef); 
  can_ok($yaml2csv, 'extract_lines');
  can_ok($yaml2csv, 'extract_labels');
}

sub extract_linesTest : Tests {
  my $yaml2csv = yaml2csv->new("java-detaisl.yml");
  isnt($yaml2csv, undef); 
}

__PACKAGE__->runtests;
