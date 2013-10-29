package Git::PurePerl::Object::Blob;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

extends 'Git::PurePerl::Object';

has '+kind' => ( default => 'blob' );

__PACKAGE__->meta->make_immutable;

1;
