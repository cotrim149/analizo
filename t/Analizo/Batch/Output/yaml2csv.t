package t::Analizo::Batch::Output::yaml2csv;
use strict;
use warnings;
use base qw(t::Analizo::Test::Class);
use Test::More 'no_plan';
use t::Analizo::Test;

use Analizo::Batch::Output::yaml2csv;

sub constructor : Tests {
  my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("../../../samples/animals/java"); 
  isnt($yaml2csv, undef);
  can_ok($yaml2csv, 'extract_lines');
  can_ok($yaml2csv, 'extract_labels');
  can_ok($yaml2csv, 'write_csv');
  
}

sub extract_labels : Tests {
  my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("t/samples/animals/java"); 

  isnt($yaml2csv, undef);
  is($yaml2csv->extract_labels(),18); 
  my @labels = $yaml2csv->extract_labels();
  is($labels[0],"_filename"); 
  is($labels[17],"sc"); 
    
}

sub extract_lines : Tests {
  my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("t/samples/animals/java"); 
  isnt($yaml2csv, undef);
  is($yaml2csv->extract_lines(extract_labels()), 4);
} 

sub write_csv : Tests {
 my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("samples/animals/cpp"); 
 isnt($yaml2csv, undef); 
 is($yaml2csv->write_csv(), 1); 
}

__PACKAGE__->runtests;
