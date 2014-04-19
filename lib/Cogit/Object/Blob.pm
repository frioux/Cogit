package Cogit::Object::Blob;

use Moo;
use namespace::clean;

extends 'Cogit::Object';

has '+kind' => ( default => sub { 'blob' } );

1;
