package Git::PurePerl::Config;

use Moo;
use MooX::Types::MooseLike::Base qw( InstanceOf );
use namespace::clean;

extends 'Config::GitLike';

has '+confname' => ( default => "gitconfig" );

has git => (
    is => 'ro',
    isa => InstanceOf['Git::PurePerl'],
    required => 1,
    weak_ref => 1,
);

sub dir_file {
    my $self = shift;
    return $self->git->gitdir->file("config");
};

1;
