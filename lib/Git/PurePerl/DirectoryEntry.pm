package Git::PurePerl::DirectoryEntry;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

has mode => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has filename => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has sha1 => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has git => (
    is => 'rw',
    isa => 'Git::PurePerl',
    weak_ref => 1,
);

sub object {
    my $self = shift;
    return $self->git->get_object( $self->sha1 );
}

__PACKAGE__->meta->make_immutable;

