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

  my ($self) = @_;
  my @lines = ();
  open(my $yaml_handler, "<", $self->{file_name} . "-details.yml")  || return 0;
	
  while(!eof $yaml_handler)
  {
    my $line = readline $yaml_handler;
    if($line ne "---\n" and $line =~ m/( (\d+)| (\w+)| - (\w+).(\w+))/)
    {
      push @lines, $1;
    }
  } 
  close $yaml_handler;
  return @lines;
}

sub write_csv 
{
  my ($self) = @_;
  my $csv_filename = $self->{file_name} . "-details.csv";
  open my $csv_handler, '>'.$csv_filename  || return 0;
  #open(my $csv_handler, ">", $self->{file_name} . "-details.csv") || die "can not open ".$self->{file_name} . "-details.csv\n".$!;

  my $arrSize = $self->extract_labels();
  print $csv_handler join(",", $self->extract_labels());
  print $csv_handler join(",", $self->extract_lines($arrSize));
  
  close $csv_handler;
  return 1;
}

1;
