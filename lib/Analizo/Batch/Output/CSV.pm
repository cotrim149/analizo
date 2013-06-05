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

  for my $job (@{$self->{jobs}}) {

    my ($summary, $details) = $job->metrics->data();
    my $metadata = $job->metadata;

    unless (@fields) {
      @fields = sort(keys(%$summary));
      @metadata_fields = map { $_->[0] } @$metadata;

      my $header = join(',', 'id', @metadata_fields, @fields) . "\n";
      print $fh $header;
    }

    my @metadata = map { _encode_value($_->[1]) } @$metadata;
    my @values = map { _encode_value($summary->{$_}) } @fields;
    my $line = join(',', $job->id, @metadata, @values) . "\n";
    print $fh $line;

    print "Writing details file for ... ",  $job->directory, "\n";
    my $details_yaml = $job->directory . "-details.yml";
    open DETAILS, '>' . $details_yaml;
    print DETAILS join('', map { Dump($_)} @$details);
    close DETAILS;

    # yaml2cvs is a perl script from yamltk (Leo Charre > yamltk-1.08) 
    my $details_csv = $job->directory . "-details.csv";
    system("yaml2csv " . $details_yaml . " > " . $details_csv);
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

1;
