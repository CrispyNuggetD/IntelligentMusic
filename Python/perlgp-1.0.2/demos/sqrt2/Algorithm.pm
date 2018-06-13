package Algorithm;

use TournamentGP;

# the PerlGP library is distributed under the GNU General Public License
# all software based on it must also be distributed under the same terms

@ISA = qw(TournamentGP);

sub _init {
  my ($self, %p) = @_;

  my %defaults = ( TrainingSet => 'train.dat',
		   TestingSet => 'test.dat',
		   FitnessDirection => 'down',
		   TournamentKillAge => 4,
		   Tournaments => 100000,
		   LogInterval => 10,
		 );

  $self->SUPER::_init(%defaults, %p);
}

sub loadSet {
  my ($self, $file) = @_;
  return sqrt(2);
}

sub fitnessFunction {
  my ($self, %p) = @_;

  # %p gives you Input => data structure
  #              Output => data structure
  #              TimeTaken => total seconds for evaluation
  #              CodeSize => number of nodes in tree (result of getSize)

  die "fitnessFunction needs params Input, Output, TimeTaken, CodeSize\n"
    unless (defined $p{Input} && defined $p{Output} &&
	    defined $p{TimeTaken} && defined $p{CodeSize});

  return $self->WorstPossibleFitness()
    unless (defined $p{Input} && defined $p{Output});

  return abs($p{Input} - $p{Output});
}

sub saveOutput {
  my ($self, %p) = @_;
  die unless ($p{Filename} && $p{Output} && $p{Output});

  if (open(FILE, ">$p{Filename}")) {
    printf FILE "# Tournament: %d\n", $self->Tournament();
    if ($p{Individual}) {
      printf FILE "# Individual: %s\n", $p{Individual}->DBFileStem();
      printf FILE "# Fitness:    %s\n", $p{Individual}->Fitness();
    }

    if (defined $p{Input} && defined $p{Output}) { 
      print FILE "# Columns: OutputY RealY\n";
      printf FILE "%.36f %.36f\n", $p{Output}, $p{Input};
    } else {
      print FILE "# undefined output!!!\n";
    }
    close(FILE);
  }
}

1;
