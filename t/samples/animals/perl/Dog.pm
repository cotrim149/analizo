package Dog;

use base qw(Mammal);
use strict;
use warnings;

sub name {
  my $self = shift;
	
  $self->{name} = shift if (@_);
	
  return $self->{name};
}

1;
