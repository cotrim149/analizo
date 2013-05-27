use yaml2csv;
use base qw(Test::Class);
use Test::More 'no_plan';

sub constructor : Tests {
  my $yaml2csv = yaml2csv->new("java-detaisl.yml"); 
  isnt($yaml2csv, undef); 
  can_ok($yaml2csv, 'extract_lines');
  can_ok($yaml2csv, 'extract_labels');
}

sub extract_linesTest : Tests {
  my $yaml2csv = yaml2csv->new("java-detaisl.yml");
  isnt($yaml2csv, undef); 
}

__PACKAGE__->runtests;
