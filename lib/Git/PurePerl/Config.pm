package Git::PurePerl::Config;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

extends 'Config::GitLike';

has '+confname' => ( default => "gitconfig" );

has git => (
    is => 'ro',
    isa => 'Git::PurePerl',
    required => 1,
    weak_ref => 1,
);

override dir_file => sub {
    my $self = shift;
    return $self->git->gitdir->file("config");
};

1;
