package Git::PurePerl::Object::Commit;
use Moose;
use MooseX::StrictConstructor;
use Moose::Util::TypeConstraints;
use Encode qw/decode/;
use namespace::autoclean;

extends 'Git::PurePerl::Object';

has '+git' => ( required => 1 );
has '+kind' => ( default => 'commit' );
has 'tree_sha1'   => ( is => 'rw', isa => 'Str', init_arg => 'tree' );
has '_parent' => ( init_arg => 'parent', is => 'rw', isa => 'Str' );
has 'parent_sha1s' => ( is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] });
has 'author' => ( is => 'rw', isa => 'Git::PurePerl::Actor' );
has 'authored_time' => ( is => 'rw', isa => 'DateTime' );
has 'committer' =>
    ( is => 'rw', isa => 'Git::PurePerl::Actor' );
has 'committed_time' => ( is => 'rw', isa => 'DateTime' );
has 'comment'        => ( is => 'rw', isa => 'Str' );
has 'encoding'       => ( is => 'rw', isa => 'Str' );

my %method_map = (
    'tree'      => 'tree_sha1',
    'parent'    => '_push_parent_sha1',
    'author'    => 'authored_time',
    'committer' => 'committed_time'
);

sub BUILD {
    my $self = shift;
    return unless $self->has_content;
    my @lines = split "\n", $self->content;
    my %header;
    while ( my $line = shift @lines ) {
        last unless $line;
        my ( $key, $value ) = split ' ', $line, 2;
        push @{$header{$key}}, $value;
    }
    $header{encoding}
        ||= [ $self->git->config->get(key => "i18n.commitEncoding") || "utf-8" ];
    my $encoding = $header{encoding}->[-1];
    for my $key (keys %header) {
        for my $value (@{$header{$key}}) {
            $value = decode($encoding, $value);
            if ( $key eq 'committer' or $key eq 'author' ) {
                my @data = split ' ', $value;
                my ( $email, $epoch, $tz ) = splice( @data, -3 );
                $email = substr( $email, 1, -1 );
                my $name = join ' ', @data;
                my $actor
                    = Git::PurePerl::Actor->new( name => $name, email => $email );
                $self->$key($actor);
                $key = $method_map{$key};
                my $dt
                    = DateTime->from_epoch( epoch => $epoch, time_zone => $tz );
                $self->$key($dt);
            } else {
                $key = $method_map{$key} || $key;
                $self->$key($value);
            }
        }
    }
    $self->comment( decode($encoding, join "\n", @lines) );
}

sub _build_content {
    my $self = shift;

    my $content;

    $content .= 'tree ' . $self->tree_sha1 . "\n";
    $content .= 'parent ' . $self->parent . "\n" if $self->parent;
    $content
        .= "author "
        . $self->author->name . ' <'
        . $self->author->email . "> "
        . $self->authored_time->epoch . " "
        . DateTime::TimeZone->offset_as_string( $self->authored_time->offset )
        . "\n";
    $content
        .= "committer "
        . $self->committer->name . ' <'
        . $self->author->email . "> "
        . $self->committed_time->epoch . " "
        . DateTime::TimeZone->offset_as_string(
        $self->committed_time->offset )
        . "\n";
    $content .= "\n";
    my $comment = $self->comment;
    chomp $comment;
    $content .= "$comment\n";

    return $content;
}

sub tree {
    my $self = shift;
    return $self->git->get_object( $self->tree_sha1 );
}


sub _push_parent_sha1 {
    my ($self, $sha1) = @_;

    push(@{$self->parent_sha1s}, $sha1);
}

sub parent_sha1 {
    return shift->parent_sha1s->[0];
}

sub parent {
    my $self = shift;
    return $self->git->get_object( $self->parent_sha1 );
}

sub parents {
    my $self = shift;

    return map { $self->git->get_object( $_ ) } @{$self->parent_sha1s};
}

__PACKAGE__->meta->make_immutable;

