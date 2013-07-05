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
  my @array_of_values = ();
  my @values = ();
  my @temp_line = ();
  open(my $yaml_handler, "<", $self->{file_name} . "-details.yml")  || return 0;

  while(!eof $yaml_handler)
  {
    my $line = readline $yaml_handler;
    if($line ne "---\n" and $line =~ m/( (\d+)| (\w+)| - (\w+).(\w+))/)
    {
      push @temp_line, $1;
    }
    elsif (@temp_line)
    {
      # identifica quantos arquivos possui
      my $number_of_files = scalar(@temp_line)  - ($number_of_labels + 1);
      my @file_names = ();
      # armazena os arquivos em um vetor temp
      for(my $i = 0; $i < $number_of_files; $i++)
      {
        push @file_names, $temp_line[$i];
      }
      # transforma os arquivos em uma variavel só
      my $files = join(" ", @file_names);
      # coloca os arquivos na primeira posição do vetor
      push @values, $files;

      #adiciona o restante dos valores
      for(my $i=($number_of_files - 1);$i < scalar(@temp_line);$i++)
      {
        push @values, $temp_line[$i];
      }

      #coloca o @values no @array_of_values, pois @values são os valores de uma linha
      push @array_of_values, join(",",@values);
      @temp_line = ();
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

  my @temp = ();

  my $number_of_labels = $self->extract_labels();
  print $csv_handler join(",", $self->extract_labels());
  print $csv_handler "\n";

  my @array_of_values =  $self->extract_lines($number_of_labels);
  # foreach(@array_of_values)
  # {
  #   print $csv_handler $_;
  # }
  print $csv_handler join("\n", @array_of_values);

 
 
  close $csv_handler;

  return 1;
}

1;
