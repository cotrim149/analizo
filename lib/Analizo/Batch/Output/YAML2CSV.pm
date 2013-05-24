package YAML2CSV;
use strict;
use warnings;



sub readYAML
{
	my ($yaml_file) = @_;
	open(my $yaml_handler, "<", $yaml_file) || return 0;#die "Couldn't open '".$yaml_file."' for reading because: ".$!;
	extract_labels($yaml_handler);
	extract_lines($yaml_handler);
	close $yaml_handler;	
}


sub extract_labels
{
	my ($yaml_handler) = @_;
	my @labels = ();

	seek($yaml_handler, 0, 0);
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

	my ($yaml_handler) = @_;
	my @lines = ();
	
	seek($yaml_handler, 0, 0);

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
# Abre o arquivo
#my $file = "java-details.yml";
#open(my $yaml_handler, "<", $file) || die "Couldn't open '".$file."' for reading because: ".$!;

# Contador
#my $i = 0;
# Armazena os labels das colunas
#my @labels = ();
# Armazena as linhas
#my @lines = ();

# Enquanto não chega ao fim do arquivo
#while(!eof $yaml_handler)
#{ 
	# Le uma linha
#	my $line = readline $yaml_handler; 
	# Se a linha não for "---" e der match com o REGEX
#	if($line ne "---\n" and $line =~ m/(\w+):/)
#	{
		# Adiciona as colunas
		# $1 armazena o match do REGEX
 #   	push @labels, $1;
  #  	if($1 eq "sc")
 #   	{
    		# Funciona como o break
#			last;
 #   	}
  #  }
#}

# Volta para o inicio do arquivo
#seek($yaml_handler, 0, 0);

# Enquanto não chega ao fim do arquivo
#while(!eof $yaml_handler)
#{
#	# Le uma linha
#	my $line = readline $yaml_handler;
#	# Se a linha não for "---" e der match com o REGEX
#	if($line ne "---\n" and $line =~ m/( (\d+)| (\w+)| - (\w+).(\w+))/)
#	{
#		push @lines, $1;
#	}
#}

#close $yaml_handler;

# my $csvfile = "java-details.yml";