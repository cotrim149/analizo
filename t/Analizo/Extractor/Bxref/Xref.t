package t::Analizo::Extractor::Bxref::Xref;

use base qw(Test::Class);
use Test::More;

use strict;
use warnings;
use File::Basename;

use Analizo::Extractor;

eval ('$Analizo::Extractor::QUIET = 1;');

sub new_xref_extractor () {
	my $model = new Analizo::Model;
	return Analizo::Extractor::Bxref::Xref->new( model => $model);
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
	my $xref = new Analizo::Extractor::Bxref::Xref;

	$file_name = $xref->_strip_current_directory("$pwd/sample/animal.pm");
	is($file_name, "sample/animal.pm", "must return name of the file");
}

sub extracting_module_name : Tests {
	my $xref = new Analizo::Extractor::Bxref::Xref();
	my $module_name;

	$module_name = $xref->_file_to_module("analizo/t/sample/animal.pm");
	is($module_name, "animal", "must return name of the module");

	$module_name = $xref->_file_to_module("analizo/t/sample/animal.pl");
	is($module_name, "animal", "must return name of the module");
}

__PACKAGE__->runtests;

