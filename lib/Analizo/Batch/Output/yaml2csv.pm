use strict;
use warnings;
package Analizo::Batch::Output::yaml2csv;

sub new 
{
  my ($class, @yaml_file) = @_;
  return bless {file_name => @yaml_file }, $class;
}

sub extract_labels
{
  my ($self) = @_;
  my @labels = ();

  open(my $yaml_handler, "<", $self->{file_name} . "-details.yml")  || return 0;

  while(!eof $yaml_handler)
  { 
    my $line = readline $yaml_handler;
    if($line ne "---\n" and $line =~ m/(\w+):/)
    {
      push @labels, $1;
      if($1 eq "sc")
      {
	close $yaml_handler;
	last;
      }
    }
  }
    
  return @labels;
}


sub extract_lines
{

  my ($self, $number_of_labels) = @_;
  my @lines = ();

  open(my $yaml_handler, "<", $self->{file_name} . "-details.yml")  || return 0;
  
  my $loop_times = 0;

  my $count = 0;
  my @array_of_values = ();

  while(!eof $yaml_handler)
  {
    my $line = readline $yaml_handler;
    if($line ne "---\n" and $line =~ m/( (\d+)| (\w+)| - (\w+).(\w+))/)
    {
      if($number_of_labels eq $loop_times)
      {
        push @lines, "\n";
        push @array_of_values, @lines;
        $loop_times = 0;
        @lines = ();
      }
      push @lines, $1;
      $loop_times++;
    }
  } 
  close $yaml_handler;
  return @array_of_values;
}

sub write_csv 
{
  my ($self) = @_;
  my $csv_filename = $self->{file_name} . "-details.csv";
  open my $csv_handler, '>'.$csv_filename  || die "can not open ".$self->{file_name} . "-details.csv\n".$!;
  #open(my $csv_handler, ">", $self->{file_name} . "-details.csv") || die "can not open ".$self->{file_name} . "-details.csv\n".$!;


  my $number_of_labels = $self->extract_labels();
  print $csv_handler join(",", $self->extract_labels());
  print $csv_handler "\n";

  my @array_of_values =  $self->extract_lines($number_of_labels);

  foreach(@array_of_values)
  {
    print $csv_handler join("," , $_);  

  }
  close $csv_handler;
  return 1;
}

1;
