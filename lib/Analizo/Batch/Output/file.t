use YAML2CSV;
use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
#require YAML2CSV;


sub testReadYAML : Tests {
	my $file = "java-details.yml";
	is(YAML2CSV::readYAML($file),1);
	is(YAML2CSV::readYAML(),0);
}

sub testExtractLabels : Tests
{
	my $file = "java-details.yml";
	open(my $yaml_handler, "<", $file) || return 0;
 	is(YAML2CSV::extract_labels($yaml_handler), 18);

}




__PACKAGE__->runtests;