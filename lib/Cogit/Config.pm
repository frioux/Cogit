package Cogit::Config;

use Moo;
use MooX::Types::MooseLike::Base qw( InstanceOf );
use Path::Class;
use namespace::clean;

extends 'Config::GitLike';

has '+confname' => ( default => "gitconfig" );

has git => (
    is => 'ro',
    isa => InstanceOf['Cogit'],
    required => 1,
    weak_ref => 1,
);

sub dir_file {
    my $self = shift;
    return dir($self->git->gitdir)->file("config");
};

1;
