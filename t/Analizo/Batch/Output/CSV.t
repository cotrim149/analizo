package t::Analizo::Batch::Output::CSV;
use strict;
use warnings;
use base qw(t::Analizo::Test::Class);
use Test::More 'no_plan';
use t::Analizo::Test;

use Analizo::Batch::Output::CSV;
use Analizo::Batch::Output::yaml2csv;
use Analizo::Batch::Job::Directories;

my $TMPDIR = tmpdir();
my $TMPFILE = "$TMPDIR/output.csv";

sub setup : Tests(setup) {
  system("mkdir -p $TMPDIR");
}

sub teardown : Tests(teardown) {
  system("rm -rf $TMPDIR");
}

sub constructor : Tests {
  my $output = __create();
  isa_ok($output, 'Analizo::Batch::Output::CSV');

  my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("../../../samples/animals/java"); 
  isnt($yaml2csv, undef);
  can_ok($yaml2csv, 'extract_lines');
  can_ok($yaml2csv, 'extract_labels');
  can_ok($yaml2csv, 'write_csv');
}

sub writing_data : Tests {
  my $output = __create();

  my $job1 = new Analizo::Batch::Job::Directories('t/samples/animals/cpp');
  $job1->execute();
  $output->push($job1);

  my $job2 = new Analizo::Batch::Job::Directories('t/samples/animals/java');
  $job2->execute();
  $output->push($job2);

  $output->file($TMPFILE);
  $output->flush();

  my @lines = readfile $TMPFILE;

  ok(scalar(@lines) == 3, 'must write data to output file');

  ok($lines[0] =~ /^\w+(,\w+)+$/, 'first line must contain column names');

  my $empty_lines = grep { /^\s*$/ } @lines;
  ok($empty_lines == 0, 'CSV output must not contain empty lines');
}

sub job_metadata : Tests {
  my $job = mock(new Analizo::Batch::Job::Directories('t/samples/animals/cpp'));
  $job->mock('metadata', sub { [ ['data1', 88], [ 'data2', 77 ] ] });
  $job->mock('id', sub { 99 });
  $job->execute();

  my $output = __create();
  $output->file($TMPFILE);
  $output->push($job);
  $output->flush();

  my @lines = readfile($TMPFILE);

  ok($lines[0] =~ /^id,data1,data2/, 'must list metadata fields');
  ok($lines[1] =~ /^99,88,77/, 'must include metadata values');
}

sub must_write_list_data_as_string : Tests {
  my $job = mock(new Analizo::Batch::Job::Directories('t/samples/animals/cpp'));
  $job->execute();
  $job->mock(
    'metadata',
    sub { [['values', ['onething','otherthing']],] }
  );

  my $output = __create();
  $output->file($TMPFILE);
  $output->push($job);
  $output->flush();

  my @lines = readfile $TMPFILE;
  like($lines[1], qr/,"onething;otherthing",/);

}

sub must_write_hash_data_as_string : Tests {
  my $job = mock(new Analizo::Batch::Job::Directories('t/samples/animals/cpp'));
  $job->execute();
  $job->mock(
    'metadata',
    sub { [['data', { 'key1' => 'value1', 'key2' => 'value2'}]]}
  );

  my $output = __create();
  $output->file($TMPFILE);
  $output->push($job);
  $output->flush();

  my @lines = readfile($TMPFILE);
  like($lines[1], qr/,"key1:value1;key2:value2",/);
}

sub __create {
  my @args = @_;
  return new Analizo::Batch::Output::CSV(@args);
}

sub extract_labels : Tests {
  my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("t/samples/animals/java"); 
  isnt($yaml2csv, undef);
  is($yaml2csv->extract_labels(),18); 
  my @labels = $yaml2csv->extract_labels();
  is($labels[0],"_filename"); 
  is($labels[17],"sc");   
}

sub extract_lines_cpp : Tests {
  my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("t/samples/animals/cpp"); 
  isnt($yaml2csv, undef);
  my @array_of_values = $yaml2csv->extract_lines(extract_labels());
  isnt(@array_of_values, undef);
  is($array_of_values[0], '- animal.h ');    
}

sub extract_lines_java : Tests {
  my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("t/samples/animals/java"); 
  isnt($yaml2csv, undef);
  my @array_of_values = $yaml2csv->extract_lines(extract_labels());
  isnt(@array_of_values, undef);
  is($array_of_values[0], '- Animal.java ');    
} 

sub write_csv_cpp : Tests {
  my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("t/samples/animals/cpp"); 
  $yaml2csv->write_csv(); 
  isnt($yaml2csv, undef);  
  open(my $file_cpp, "<", $yaml2csv->{job_directory} . "-details.csv") || die "Cannot open ".$yaml2csv->{job_directory} . "-details.csv\n".$!;
  is(-e $file_cpp, 1);
}


sub write_csv_java : Tests {
  my $yaml2csv = Analizo::Batch::Output::yaml2csv->new("t/samples/animals/java");
  $yaml2csv->write_csv(); 
  isnt($yaml2csv, undef);  
  open(my $file_java, "<", $yaml2csv->{job_directory} . "-details.csv") || die "Cannot open ".$yaml2csv->{job_directory} . "-details.csv\n".$!;
  is(-e $file_java, 1);
}


__PACKAGE__->runtests;

1;
