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
		   RefreshInterval => 1000,
		   Tournaments => 100000,
		   LogInterval => 10,
		 );

  $self->SUPER::_init(%defaults, %p);
}

# load data from files generated with ./generate_data.pl
# there's no reason why you couldn't just generate the data
# here in loadSet(), but the example here shows that you can
# load data from files...
sub loadSet {
  my ($self, $file) = @_;
  my @set;
  open(FILE, $file) || die "can't read data set $file\n";
  while (<FILE>) {
    my ($ia, $ir, $yd, $ny, $y) = split;
    push @set, { 'ia'=>$ia,
		 'ir'=>$ir,
		 'ny'=>$ny,
		 'yd'=>$yd,
		 'y'=>$y, };

  }
  close(FILE);
  return \@set;
}

sub refresh {
  my $self = shift;
  system "./generate_data.pl";
  $self->loadData();
  $self->BestFitness($self->WorstPossibleFitness());
  $self->Population()->initFitnesses();
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
    unless (@{$p{Input}} && @{$p{Output}} && @{$p{Input}} == @{$p{Output}});

  # maxerror can help GP use powers... (domain specific knowledge!)
  my $maxerror = 1e15;

  my $sumerror = 0;
  my $error;
  for (my $i=0; $i<@{$p{Input}}; $i++) {
    $error = ($p{Output}->[$i] - $p{Input}->[$i]{'y'})**2;
    $error = $maxerror if ($error > $maxerror);
    $sumerror += $error;
  }
  return sqrt($sumerror/@{$p{Input}});
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

    if (@{$p{Input}} && @{$p{Output}} && @{$p{Input}} == @{$p{Output}}) {
      print FILE "# Columns: InitialAmount OutputY RealY Error\n";
      for (my $i=0; $i<@{$p{Input}}; $i++) {
	my $input = $p{Input}->[$i];
	my $output = $p{Output}->[$i];
	my $error = sqrt(($output - $input->{'y'})**2);
	printf FILE "%12.6g %12.6g %12.6g %12.6g\n",
	  $input->{'ia'}, $output, $input->{'y'}, $error;
      }
    } else {
      print FILE "# NO INPUTS/OUTPUTS or unequal number of them !!!\n";
    }
    close(FILE);
  }
}

1;
