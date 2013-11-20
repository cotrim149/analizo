package t::Analizo::Extractor::Bxref::Xref;

use base qw(Test::Class);
use Test::More;
use Data::Dumper;

use strict;
use warnings;
use File::Basename;

use Analizo::Extractor;
use Analizo::Extractor::Bxref::Xref;
use Analizo::Extractor::Bxref::Tree;

eval ('$Analizo::Extractor::QUIET = 1;');

sub new_xref_extractor () {
	my $model = new Analizo::Model;
	return Analizo::Extractor::Bxref::Xref->new( model => $model);
}

sub new_tree_xref_extractor () {
	return new Analizo::Extractor::Bxref::Tree();
}

sub constructor : Tests {
	use_ok('Analizo::Extractor::Bxref::Xref');
	use_ok('Analizo::Extractor::Bxref::Tree');
	my $extractor = new_xref_extractor();
	isa_ok($extractor, 'Analizo::Extractor::Bxref::Xref');
	isa_ok($extractor, 'Analizo::Extractor');
}

sub has_a_model : Tests {
	isa_ok((Analizo::Extractor->load('Bxref::Xref'))->model, 'Analizo::Model');
}

sub current_directory : Tests {
	use Cwd;
	my $pwd = getcwd();
	my $file_name;
	my $extractor = new_xref_extractor();

	$file_name = $extractor->_strip_current_directory("$pwd/sample/animal.pm");
	is($file_name, "sample/animal.pm", "must return name of the file");
}

sub extracting_module_name : Tests {
	my $extractor = new_xref_extractor();
	my $module_name;

	$module_name = $extractor->_file_to_module("analizo/t/sample/animal.pm");
	is($module_name, "animal", "must return name of the module");

	$module_name = $extractor->_file_to_module("analizo/t/sample/animal.pl");
	is($module_name, "animal", "must return name of the module");
}

sub qualifing_name : Tests {
	my $extractor = new_xref_extractor();
	my $name;

	$name = $extractor->_qualified_name("animal.pm", "new");
	is($name, "animal::new", "must return name");
}

sub adding_member_in_model : Tests {
	my $extractor = new_xref_extractor();
	my $tree = new_tree_xref_extractor();

	my @files = {'animal.pm','cat.pm', 'dog.pm'};

	$tree->building_tree('/sample/animals/perl/animal.pm  Animal::new  12 (lexical)  $ self  used', @files);
	$extractor->feed($tree);

	#ok (grep { $_ eq 'Animal::new'} @{$extractor->model->{modules}->{'animal.pm'}->{functions}});
	#is ($extractor->current_member, 'Animal::new', $extractor->model->{modules}->{'animal.pm'}->{functions});
}

__PACKAGE__->runtests;

