package Cogit::DirectoryEntry;

use Moo;
use MooX::Types::MooseLike::Base 'Str', 'InstanceOf';
use namespace::clean;

has mode => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has filename => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has sha1 => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has git => (
    is => 'rw',
    isa => InstanceOf['Cogit'],
    weak_ref => 1,
);

sub object {
    my $self = shift;
    return $self->git->get_object( $self->sha1 );
}

1;

