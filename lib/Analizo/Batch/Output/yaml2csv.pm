use strict;
use warnings;
#package Analizo::Batch::Output::YAML2CSV;
package yaml2csv;

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

#  seek($yaml_handler, 0, 0);
  while(!eof $yaml_handler)
  { 
    # Le uma linha
    my $line = readline $yaml_handler; 
    # Se a linha não for "---" e der match com o REGEX
    if($line ne "---\n" and $line =~ m/(\w+):/)
    {
    # Adiciona as colunas
    # $1 armazena o match do REGEX
      push @labels, $1;
      if($1 eq "sc")
      {
      # Funciona como o break
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
	
  #seek($yaml_handler, 0, 0);
  # Enquanto não chega ao fim do arquivo
  while(!eof $yaml_handler)
  {
    # Le uma linha
    my $line = readline $yaml_handler;
    # Se a linha não for "---" e der match com o REGEX
    if($line ne "---\n" and $line =~ m/( (\d+)| (\w+)| - (\w+).(\w+))/)
    {
      push @lines, $1;
    }
  }
  return @lines;
}
1;
