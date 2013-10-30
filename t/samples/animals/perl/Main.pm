use strict;
use warnings;
use Cat;
use Dog;

my $cat = Cat->new("Garfield"); 
my $dog = Dog->new("Oddie");

print $cat->name(), "\n";
print $dog->name(), "\n";
