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
