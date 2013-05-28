package Analizo::Batch::Output::yaml2csv::Test;
use strict;
use warnings;
use base qw(Test::Analizo::Class);
use Test::More 'no_plan';
use Test::Analizo;

use Analizo::Batch::Output::yaml2csv;

sub constructor : Tests {
  my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("samples/hello_world/java-detaisl.yml"); 
  isnt($yaml2csv, undef); 
  can_ok($yaml2csv, 'extract_lines');
  can_ok($yaml2csv, 'extract_labels');
  can_ok($yaml2csv, 'write_csv');
}

sub write_csv : Tests {
  my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("samples/hello_world/java-detaisl.yml"); 
  isnt($yaml2csv, undef); 
  #is($yaml2csv->write_csv(), 1); 
}

__PACKAGE__->runtests;
