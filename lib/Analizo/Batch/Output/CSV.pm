package Analizo::Batch::Output::CSV;

use base qw( Analizo::Batch::Output );
use Analizo::Metrics;
use YAML;

sub push {
  my ($self, $job) = @_;
  $self->{jobs} ||= [];
  push @{$self->{jobs}}, $job;
}

sub write_data {
  my ($self, $fh) = @_;
  my @fields = ();
  my @metadata_fields;

	$count = 1;

  for my $job (@{$self->{jobs}}) {
	
    my ($summary, $details) = $job->metrics->data();
    my $metadata = $job->metadata;

    unless (@fields) {
      @fields = sort(keys(%$summary));
      @metadata_fields = map { $_->[0] } @$metadata;

      my $header = join(',', 'id', @metadata_fields, @fields) . "\n";
      print $fh $header;
    }

    my @values = map { _encode_value($summary->{$_}) } @fields;
    my $line = join(',', $job->id, @metadata, @values) . "\n";
    print $fh $line;

	$self->write_details($job->id, $details);

	$count++;
  }
}

my $__encoders = {
  _default => sub { $_[0] },
  ARRAY => sub { '"' . join(';', @{$_[0]}) . '"' },
  HASH => sub { '"' . join(';', map { join(':', $_, $_[0]->{$_}) } sort(keys(%{$_[0]}))) . '"' },
};

sub _encode_value($) {
  my ($value) = @_;
  my $encoder = $__encoders->{ref($value)} || $__encoders->{_default};
  return &$encoder($value);
}

sub write_details {
	my ($self, $id, $details) = @_;
	my @labels = ();
	my @values = ();
	my @array_of_values = ();
	my @files_name = ();

	my $csv_filename = "dir" .$count.  "-details.csv";
	#my $csv_filename = $self->{job_directory} . "-details.csv";

	open my $csv_handler, '>'.$csv_filename  || die "Cannot open dir" .$count. "-details.csv\n".$!;
	#open my $csv_handler, '>'.$directory  || die "Cannot open ".$directory . "-details.csv\n".$!;

	$test = join('', map { Dump($_)} @$details);
	
	@lines = split(/\n/, $test);

	foreach $line (@lines)
  	{ 
    	if($line ne "---\n" and $line =~ m/(\w+):/)
    	{
			if($1 eq "sc")
			{
				push @labels, $1;
				last;
			} 
			else 
			{
				push @labels, $1.",";
			}
      		
  		}
	}

	my $number_of_labels = scalar(@labels);

	foreach $line (@lines)
  	{
    	if($line =~ m/( .*)/)
    	{
      		if($1 =~ m/(- (.*))/ )
      		{
        		push @files_names, $1." ";
      		}
      		else
      		{
        		push @values, $1;  
      		}
      		if($number_of_labels == ((@values)+1))
      		{ 
        		push @array_of_values, @files_names;
        		push @array_of_values, ",";
        		push @array_of_values, join(",", @values);
        		push @array_of_values, "\n";
        		@values = ();
        		@files_names = ();
      		}
    	}
  	}	


	print $csv_handler @labels;
	print $csv_handler "\n";
	
	foreach (@array_of_values)
	{
		print $csv_handler $_;
	}

  	close $csv_handler;
}

1;
