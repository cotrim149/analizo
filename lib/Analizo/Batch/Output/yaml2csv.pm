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
  my $line = "";

  open(my $yaml_handler, "<", $self->{file_name}) || die "Couldn't open '".$self->{file_name}."' for reading because: ".$!;

while(!eof $yaml_handler) { 
  my $line = readline $yaml_handler; 
  if($line ne "---\n" and $line =~ m/(\w+):/)
    {
      
      if($1 eq "sc")
      {
        push @labels, "$1\n";
	close $yaml_handler;
        last;
      }else
      {
	push @labels, $1;
      }
      
    }
}
  return @labels;
}

sub extract_lines
{

  my ($self, $arrSize) = @_;
  my @lines = ();
  my $i = 0;
  
  open(my $yaml_handler, "<", $self->{file_name}) || die "Couldn't open '".$self->{file_name}."' for reading because: ".$!;
  while(!eof $yaml_handler){ 
    my $line = readline $yaml_handler; 
    if(($line ne "---\n") and ($line =~ m/($\d+| \d+\.\d+| \w+|- \w+.\w+)/))
    {
     
      if($i == ($arrSize -1))
      {
	push @lines, "$1\n";
      }else
      {
	push @lines, $1;
      }
      $i++;
    }
  }
    close $yaml_handler;
    return @lines;
}

sub write_csv 
{
  my ($self) = @_;
  open(my $csv_handler, ">", "saida.csv") || die "nao pode abrir saida.csv".$!;

  my $arrSize = $self->extract_labels();
  print $csv_handler join(",", $self->extract_labels());
  print $csv_handler join(",", $self->extract_lines($arrSize));
  
  close $csv_handler;
  return 1;
}

1;
