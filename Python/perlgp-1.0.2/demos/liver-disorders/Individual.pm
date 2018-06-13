package Individual;

use GeneticProgram;
use PDL;

# the PerlGP library is distributed under the GNU General Public License
# all software based on it must also be distributed under the same terms

@ISA = qw(GeneticProgram);

sub _init {
  my ($self, %p) = @_;

  my %defaults = ( TreeDepthMax => 30,

		   MinTreeNodes => 1,

		   NodeMutationProb => 1/200,
		   NodeXoverProb => 1/100,

		   NumericMutationFrac => 1,
		   NumericAllowNTypes => { DENOM=>2,
					 },

		   QuickXoverProb => 0.5,
		   XoverHomologyBias => 0.000001,

		   SleepAfterSubEvalError => 0,

		   XoverLogProb => 0.000001,
		   MutationLogProb => 0.000001,
		 );

  $self->SUPER::_init(%defaults, %p);
}


sub evaluateOutput {
  my ($self, $data) = @_;

  # how many data points
  my $n = @{$data->{inputs}};

  # make 1 x $n PDL arrays for the classifications
  # initialised with zeroes
  my $predclasses = zeroes byte, $n;

  # wake-up call
  alarm(10);
  # now do the sequence scanning (slow)
  for (my $i=0; $i<$n; $i++) {
    if (classify($data->{inputs}[$i])) {
      set $predclasses, $i, 1;
    }
  }
  alarm 0;

  return {
	  predclasses => $predclasses,
	 };

}


sub extraLogInfo {
  my $self = shift;
  return sprintf "mut %-12.6g xover %-12.6g",
    $self->NodeMutationProb(), $self->NodeXoverProb();
}

1;
