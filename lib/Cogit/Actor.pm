package Cogit::Actor;

use Moo;
use MooX::Types::MooseLike::Base 'Str';
use namespace::clean;

has name => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has email => (
    is => 'ro',
    isa => Str,
    required => 1,
);

1;

__END__

=pod

=head1 SYNOPSIS

 my $committer = Cogit::Actor->new(
   name => q(Arthur Axel 'fREW' Schmidt),
   email => q(frew@foo.com),
 );

=head1 DESCRIPTION

An object representing an author or committer.

=attr name

=attr email
