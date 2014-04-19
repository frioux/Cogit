package Git::PurePerl::Pack::WithIndex;

use Moo;
use Git::PurePerl::PackIndex::Version1;
use Git::PurePerl::PackIndex::Version2;
use MooX::Types::MooseLike::Base 'InstanceOf';
use Path::Class;
use Check::ISA;
use namespace::clean;

extends 'Git::PurePerl::Pack';

has index_filename => (
    is => 'rw',
    coerce => sub { file($_[0]) if !obj($_[0], 'Path::Class::File'); $_[0]; },
    #isa => InstanceOf['Path::Class::File'],
);

has index => (
    is => 'rw',
    isa => InstanceOf['Git::PurePerl::PackIndex'],
);

sub BUILD {
    my $self = shift;
    my $index_filename = $self->filename;
    $index_filename =~ s/\.pack/.idx/;
    $self->index_filename($index_filename);

    my $index_fh = IO::File->new($index_filename) || confess($!);
    $index_fh->binmode();
    $index_fh->read( my $signature, 4 );
    $index_fh->read( my $version,   4 );
    $version = unpack( 'N', $version );
    $index_fh->close;

    if ( $signature eq "\377tOc" ) {
        if ( $version == 2 ) {
            $self->index(
                Git::PurePerl::PackIndex::Version2->new(
                    filename => $index_filename
                )
            );
        } else {
            confess("Unknown version");
        }
    } else {
        $self->index(
            Git::PurePerl::PackIndex::Version1->new(
                filename => $index_filename
            )
        );
    }
}

sub get_object {
    my ( $self, $want_sha1 ) = @_;
    my $offset = $self->index->get_object_offset($want_sha1);
    return unless $offset;
    return $self->unpack_object($offset);
}

1;

