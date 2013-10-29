package Git::PurePerl::Protocol::Git;
use Moo;
use MooX::Types::MooseLike::Base qw( Int Str );
use IO::Socket::INET;
use namespace::clean;

extends 'Git::PurePerl::Protocol';

has hostname => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has port => (
    is => 'ro',
    isa => Int,
    default => sub { 9418 },
);

has project => (
    is => 'rw',
    isa => Str,
    required => 1,
);

sub connect_socket {
    my $self = shift;

    my $socket = IO::Socket::INET->new(
        PeerAddr => $self->hostname,
        PeerPort => $self->port,
        Proto    => 'tcp'
    ) || die $! . ' ' . $self->hostname . ':' . $self->port;
    $socket->autoflush(1) || die $!;
    $self->read_socket($socket);
    $self->write_socket($socket);

    $self->send_line( "git-upload-pack "
            . $self->project
            . "\0host="
            . $self->hostname
            . "\0" );
}

1;
