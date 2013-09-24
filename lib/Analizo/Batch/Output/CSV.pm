package Analizo::Batch::Output::CSV;

use base qw( Analizo::Batch::Output );
use Analizo::Metrics;
use YAML;
use Analizo::Batch::Output::yaml2csv;

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

    #my @metadata = map { _encode_value($_->[1]) } @$metadata;
    my @values = map { _encode_value($summary->{$_}) } @fields;
    my $line = join(',', $job->id, @metadata, @values) . "\n";
    print $fh $line;

	$self->write_details($job->id, $details);

    #print "Writing details file for ... ",  $job->directory, "\n";
    #my $details_yaml = $job->directory . "-details.yml";
    #open DETAILS, '>' . $details_yaml;
    #print DETAILS join('', map { Dump($_)} @$details);
    #close DETAILS;

    #my $yaml2csv = Analizo::Batch::Output::yaml2csv->new($job->directory);
    #$yaml2csv->write_csv();

	

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

	my $csv_filename = "bla" .$count.  "-details.csv";
	#my $csv_filename = $self->{job_directory} . "-details.csv";

	open my $csv_handler, '>'.$csv_filename  || die "Cannot open bla" .$count. "-details.csv\n".$!;
	#open my $csv_handler, '>'.$csv_filename  || die "Cannot open ".$self->{job_directory} . "-details.csv\n".$!;

	print $csv_handler join('', map { Dump($_)} @$details);
  	close $csv_handler;

  #my $number_of_labels = $self->extract_labels();	#*HERE*
  #print $csv_handler join(",", $self->extract_labels());	#*HERE*
  #print $csv_handler "\n";

  #my @array_of_values =  $self->extract_lines($number_of_labels);	#*HERE*
  #foreach(@array_of_values)
  #{
   #  print $csv_handler $_;  
  #}

  #close $csv_handler;
}

1;
