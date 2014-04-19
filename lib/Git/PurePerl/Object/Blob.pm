package Git::PurePerl::Object::Blob;

use Moo;
use namespace::clean;

extends 'Git::PurePerl::Object';

has '+kind' => ( default => sub { 'blob' } );

1;
