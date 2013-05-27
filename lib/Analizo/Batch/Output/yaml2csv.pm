use strict;
use warnings;
package Analizo::Batch::Output::yaml2csv;

use base qw( Analizo::Batch::Output);

sub new 
{
  my ($class, @yaml_file) = @_;
  return bless {file_name => @yaml_file }, $class;
}


sub extract_labels
{
  my ($self) = @_;
  my @labels = ();

  open(my $yaml_handler, "<", $self->{file_name}) || return 0;

  while(!eof $yaml_handler)
  { 
    my $line = readline $yaml_handler;
    if($line ne "---\n" and $line =~ m/(\w+):/)
    {
      push @labels, $1;
      if($1 eq "sc")
      {
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
  open(my $yaml_handler, "<", $self->{file_name}) || return 0;
	
  while(!eof $yaml_handler)
  {
    my $line = readline $yaml_handler;
    if($line ne "---\n" and $line =~ m/( (\d+)| (\w+)| - (\w+).(\w+))/)
    {
      push @lines, $1;
    }
  }
  return @lines;
}
1;
