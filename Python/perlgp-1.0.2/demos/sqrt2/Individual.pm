package Individual;

use GeneticProgram;

# the PerlGP library is distributed under the GNU General Public License
# all software based on it must also be distributed under the same terms

@ISA = qw(GeneticProgram);

sub _init {
  my ($self, %p) = @_;

  my %defaults = ( NodeMutationProb => 1/100,
		   NodeXoverProb => 1/50,
		   NumericMutationFrac => 1,
		   NumericAllowNTypes => { DENOM=>2 },
		 );

  $self->SUPER::_init(%defaults, %p);
}

sub pdiv {
  return $_[1] ? $_[0]/$_[1] : $_[0];
}

sub extraLogInfo {
  my $self = shift;
  return sprintf "mut %-12.6g xover %-12.6g",
    $self->NodeMutationProb(), $self->NodeXoverProb();
}

1;
