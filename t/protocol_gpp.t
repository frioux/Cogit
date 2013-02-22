#!perl
use strict;
use warnings;
use Git::PurePerl;
use Path::Class;
use Test::More;
use File::Temp;

my $directory = File::Temp->newdir;

my $git = Git::PurePerl->init( directory => $directory );
isa_ok( $git, 'Git::PurePerl', 'can init' );

$git->clone( 'github.com', '/acme/git-pureperl.git' );

ok( $git->all_sha1s->all >= 604 );
ok( $git->all_objects->all >= 604 );

done_testing;
