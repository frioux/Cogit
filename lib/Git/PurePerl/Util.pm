use strict;
use warnings;

package Git::PurePerl::Util;

# FILENAME: Util.pm
# CREATED: 29/05/12 21:46:21 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Helper tools for Git::PurePerl

use Sub::Exporter -setup => {
    exports => [qw( current_git_dir find_git_dir is_git_dir )],
    groups  => { default => [qw( current_git_dir )], },
};
use Path::Class qw( dir );

=head1 SYNOPSIS

	use Git::PurePerl::Util;
	use Git::PurePerl;

	my $repo = Git::PurePerl->new(
		gitdir => current_git_dir(),
	);

=cut

=head1 FUNCTIONS

=head2 is_git_dir

Determines if the given C<$dir> has the basic requirements of a Git repository dir.

( ie: either a checkouts C<.git> folder, or a bare repository )

	if ( is_git_dir( $dir ) ) {
		...
	}

=cut

sub is_git_dir {
    my ($dir) = @_;
    return if not -e $dir->subdir('objects');
    return if not -e $dir->subdir('refs');
    return if not -e $dir->file('HEAD');
    return 1;
}

=head2 find_git_dir

	my $dir = find_git_dir( $subdir );

Finds the closest C<.git> or bare tree that is either at C<$subdir> or somewhere above C<$subdir>

If C<$subdir> is inside a 'bare' repo, returns the path to that repo.

If C<$subdir> is inside a checkout, returns the path to the checkouts C<.git> dir.

If C<$subdir> is not inside a git repo, returns a false value.

=cut

sub find_git_dir {
    my $start = shift;

    return $start if is_git_dir($start);

    my $repodir = $start->subdir('.git');

    return $repodir if -e $repodir and is_git_dir($repodir);

    return find_git_dir( $start->parent )
      if $start->parent->absolute ne $start->absolute;

    return undef;
}

=head2 current_git_dir

Finds the closest C<.git> or bare tree by walking up parents.

	my $git_dir = current_git_dir();

If C<$CWD> is inside a bare repo somewhere, it will return the path to the bare repo root directory.

If C<$CWD> is inside a git checkout, it will return the path to the C<.git> folder of that checkout.

If C<$CWD> is not inside any recognisable git repo, will return a false value.

=cut

sub current_git_dir {
    return find_git_dir( dir('.') );
}

1;

