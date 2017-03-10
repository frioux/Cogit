package Cogit::Loose;

use Moo;
use MooX::Types::MooseLike::Base 'InstanceOf';
use Compress::Zlib qw(compress uncompress);
use Path::Class;
use Check::ISA;
use namespace::clean;

has directory => (
    is       => 'ro',
    isa      => InstanceOf['Path::Class::Dir'],
    required => 1,
    coerce   => sub { dir($_[0]) if !obj($_[0], 'Path::Class::Dir'); $_[0]; },
);

sub get_object {
    my ( $self, $sha1 ) = @_;

    my $filename
        = file( $self->directory, substr( $sha1, 0, 2 ), substr( $sha1, 2 ) );
    return unless -f $filename;

    my $compressed = $filename->slurp( iomode => '<:raw' );
    my $data       = uncompress($compressed);
    my ( $kind, $size, $content ) = $data =~ /^(\w+) (\d+)\0(.*)$/s;
    return ( $kind, $size, $content );
}

sub put_object {
    my ( $self, $object ) = @_;

    my $filename = file(
        $self->directory,
        substr( $object->sha1, 0, 2 ),
        substr( $object->sha1, 2 )
    );
    $filename->parent->mkpath;
    my $compressed = compress( $object->raw );
    my $fh         = $filename->openw;
    binmode($fh); #important for Win32
    $fh->print($compressed) || die "Error writing to $filename: $!";
}

sub all_sha1s {
    my $self  = shift;
    my $files = Data::Stream::Bulk::Path::Class->new(
        dir        => $self->directory,
        only_files => 1,
    );
    return Data::Stream::Bulk::Filter->new(
        filter => sub {
            [   map { m{[/\\]([a-z0-9]{2})[/\\]([a-z0-9]{38})} ? $1 . $2 : () }
                    @$_
            ];
        },
        stream => $files,
    );
}

1;

