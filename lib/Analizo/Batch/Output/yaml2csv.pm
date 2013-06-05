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

  open(my $yaml_handler, "<", $self->{file_name}) || return 0;

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
  open(my $yaml_handler, "<", $self->{file_name}) || return 0;
	
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
  my @labels = $self->extract_labels(); 
  my @lines = $self->extract_lines();
  # Nome do arquivo
  my $csvfile = $self->{file_name};
  # Abre o arquivo
  # $csv_handler file handler do arquivo
  
  my @csv_result = ();
  # Variavel onde as linhas serão escritas
  my $csv_line = "";
  # Contador para auxiliar
  my $i = 0;
  # Quantidade de valores por linha
  my $number_of_values = scalar @labels;

  open(my $csv_handler, ">", $csvfile) || die "Couldn't open '".$csvfile."' for reading because: ".$!;
  

  # Para cada elemento no array de colunas
  foreach (@labels){
  # A primeira linha não possui virgula na frente
    if($i == 0){
     $csv_line = $_; # Escreve o primeiro elemeto da linha
     $i = 1;
    }
    else{
     # Concatena os outros valores da linha com a virgula entre eles
     $csv_line = $csv_line . "," . $_;
    }
  }
  # Ao terminar de tratar a primeira linha adiciona ela no array de linhas a serem escritas no arquivo
  push @csv_result, $csv_line;

  # Reinicializa o $i
  $i = 0;
  # Começa a tratar as linhas
  foreach (@lines){
    # No primeiro valor da linha só adiciona, sem virgula
    if($i == 0){
      $csv_line = $_;
      $i++;
    } else {
    # Concatena os elementos com virgula entre eles
    $csv_line = $csv_line . "," . $_;
    $i++;
    # Quando chega no ultimo elemento de acordo com o numero de colunas
    if($i==$number_of_values){
       # Adiciona a linha para o array de linhas a serem escritas no arquivo
       push @csv_result, $csv_line;
       # Reinicializa o $i para a próxima linha
       $i = 0;
      }
    }
  }

  # Para cada linha a ser escrita no arquivo
  foreach (@csv_result){
    # Escreve a linha no arquivo
    print $csv_handler $_;
    print $csv_handler "\n";
  }

  # Fecha o file handler
  close $csv_handler;
  return 1;
}

1;
