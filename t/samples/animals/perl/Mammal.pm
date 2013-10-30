package Mammal;

use strict;
use warnings;

sub new {
  my $class = shift;
	
  my $self = {name=>shift}; 
		
  bless ($self,$class);
  return $self;
}

1;
