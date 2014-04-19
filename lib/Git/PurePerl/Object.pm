package Git::PurePerl::Object;

use Moo;
use Digest::SHA;
use MooX::Types::MooseLike::Base qw( Str Int InstanceOf );
use namespace::clean;

has kind => (
    is => 'ro',
    isa => sub {
        die "$_[0] is not a valid object type" unless $_[0] =~ m/commit|tree|blob|tag/
    },
    required => 1,
);

# TODO: make this required later
has content => (
    is => 'rw',
    builder => '_build_content',
    lazy => 1,
    predicate => 'has_content',
);

has size => (
    is => 'ro',
    isa => Int,
    builder => '_build_size',
    lazy => 1,
);

has sha1 => (
    is => 'ro',
    isa => Str,
    builder => '_build_sha1',
    lazy => 1,
);

has git => (
    is => 'rw',
    isa => InstanceOf['Git::PurePerl'],
    weak_ref => 1,
);

sub _build_sha1 {
    my $self = shift;
    my $sha1 = Digest::SHA->new;
    $sha1->add( $self->raw );
    my $sha1_hex = $sha1->hexdigest;
    return $sha1_hex;
}

sub _build_size {
    my $self = shift;
    return length($self->content || "");
}

sub raw {
    my $self = shift;
    return $self->kind . ' ' . $self->size . "\0" . $self->content;
}

1;
