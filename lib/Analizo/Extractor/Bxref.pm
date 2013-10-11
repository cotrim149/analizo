package Analizo::Extractor::Bxref;

use strict;
use warnings;

use base qw(Analizo::Extractor);

use File::Temp qw/ tempfile /;

sub new {
  my $package = shift;
  return bless { files => [], @_}, $package;
}

sub add_file {
  my ($self, $file) = @_;
  push (@{$self->{files}}, $file);
}

sub actually_process {
  my $self = shift;
  my ($temp_handle, $temp_filename) = tempfile();
  foreach my $input_file (@_) {
    print $temp_handle "$input_file\n"
  }
  close $temp_handle;

  eval {
    open BXREF, "report - < $temp_filename |" or die $!;
    while (<BXREF>) {
      $self->feed($_);
    }
    close BXREF;
    unlink $temp_filename;
  };
  if($@) {
    warn($@);
    exit -1;
  }
}

1;

