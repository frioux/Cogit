#!perl
use strict;
use warnings;
use inc::Module::Install 0.91;

name 'Git-PurePerl';
all_from 'lib/Git/PurePerl.pm';
author 'Leon Brocard <acme@astray.com>';
abstract 'A Pure Perl interface to Git repositories';
license 'perl';

resources repository => 'git://github.com/bobtfish/git-pureperl.git';

requires        'Archive::Extract'           => '0';
requires        'Compress::Raw::Zlib'        => '0';
requires        'Compress::Zlib'             => '0';
requires        'Data::Stream::Bulk'         => '0';
requires        'DateTime'                   => '0';
requires        'Digest::SHA1'               => '0';
requires        'File::Find::Rule'           => '0';
requires        'IO::Digest'                 => '0';
requires        'Moose'                      => '0';
requires        'MooseX::StrictConstructor'  => '0';
requires        'MooseX::Types::Path::Class' => '0';

WriteAll;
