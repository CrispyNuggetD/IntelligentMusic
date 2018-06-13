package Algorithm;

use TournamentGP;
use PDL;

# the PerlGP library is distributed under the GNU General Public License
# all software based on it must also be distributed under the same terms

@ISA = qw(TournamentGP);

sub _init {
  my ($self, %p) = @_;

  my %defaults = ( TrainingSet => 'train',
		   TestingSet =>  'test',

		   DataFile => 'liver-disorders.dat',

		   CVfold => 10,

		   FitnessDirection => 'up',

		   # Bob has hardly ever changed the following 4 params
		   TournamentKillAge => 4,
		   Tournaments => 10e20,
		   TournamentSize => 50,
		   TournamentParents => 20,

		   WorstPossibleFitness => 0, # maybe try -1
		   ForkForEval => 0,

		   KeepBest => 0,
		   LogInterval => 10,  # log data every X tournaments
		   ComplexityInterval => 0,

		   RefreshInterval => 0,

		   PopulationBackupInterval => 0,
		   EmigrateInterval => 0,
		   ImmigrateInterval => 0,

		   RecentFileStem => '',
		   BestFileStem => '',
		 );

  $self->SUPER::_init(%defaults, %p);
}

sub loadSet {
  my ($self, $file) = @_;

  my $exptid = $self->Population->ExperimentId;
  my ($exptnum) = $exptid =~ /(\d+)$/;
  $exptnum = 1 if (!defined $exptnum);
  my $leave_out_chunk = $exptnum % $self->CVfold();

  my @classes;
  my @ids;
  my @inputs;

  my $row = 0;
  open(DAT, $self->{DataFile}) || die;
  while(<DAT>) {
    next if (/^#/); # or whatever
    $row++;

    # CV input selection here
    my $chunk = $row % $self->CVfold();
    if (($file eq 'test' && $chunk == $leave_out_chunk) ||
	($file eq 'train' && $chunk != $leave_out_chunk)) {

      push @ids, sprintf "%05d", $row;
      my ($class, @temp) = split;

      # classes are 1 and 2, but we want 0 and 1
      push @classes, $class - 1;

      # convert @temp from 1:85.000000 2:92.000000 3:45.000000
      # into a hash (1 => 85, 2 => 92, 3=>45)
      my %inputs = map { my ($name, $val) = split /:/, $_; ($name, 1*$val) } @temp;
      push @inputs, \%inputs;

    }
  }
  close(DAT);

  return { ids => \@ids,
	   knownclasses => byte(@classes),
	   inputs => \@inputs,
	 };
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

  my $knownclasses = $p{Input}{knownclasses};
  my $predclasses = $p{Output}{predclasses};

  # do some safety checks - make sure there are the same
  # number of predictions as data instances
  return $self->WorstPossibleFitness()
      unless (defined $knownclasses && defined $predclasses &&
	      $knownclasses->nelem > 0 &&
	      $knownclasses->nelem == $predclasses->nelem);

  # use a fixed time cutoff only for training data
  # return $self->WorstPossibleFitness()
  #   if ($p{Input}{maxkeywordfrac} == $self->MaxKNOWNFracTraining &&
  #	$p{TimeTaken}/$knownclasses->nelem() > 0.01);

  my $invpredclasses = (1 - $predclasses);
  my $invknownclasses = (1 - $knownclasses);

  my $tp = ($knownclasses * $predclasses)->sum;       # true positives
  my $fp = ($invknownclasses * $predclasses)->sum;    # false positives
  my $tn = ($invknownclasses * $invpredclasses)->sum; # true negatives
  my $fn = ($knownclasses * $invpredclasses)->sum;    # false negatives

  my $denom = sqrt(($tn+$fn)*($tn+$fp)*($tp+$fn)*($tp+$fp));
  # final calculation
  my $mcc = $denom ? ($tp*$tn-$fn*$fp)/$denom : $self->WorstPossibleFitness();
  return $mcc;  ### optionally subtract $p{TimeTaken}/$predclasses->nelem;
}

sub saveOutput {
  my ($self, %p) = @_;
  my ($id, $knownclass, $predclass);

  die unless ($p{Filename} && $p{Input} && $p{Output});

  if (open(FILE, ">$p{Filename}")) {
    printf FILE "# Tournament: %d\n", $self->Tournament();
    if ($p{Individual}) {
      printf FILE "# Individual: %s\n", $p{Individual}->DBFileStem();
      printf FILE "# Fitness:    %s\n", $p{Individual}->Fitness();
    }
    if (defined $p{Input}{knownclasses} && defined $p{Output}{predclasses} &&
	$p{Input}{knownclasses}->nelem) {

      my $n = $p{Input}{knownclasses}->nelem;
      my $knownfrac = $p{Input}{knownclasses}->sum/$n;
      my $seqfrac = $p{Output}{predclasses}->sum/$n;

      printf FILE "# KnownFraction: %-6.4f\n", $knownfrac;
      printf FILE "# PredFraction:  %-6.4f\n", $seqfrac;

      printf FILE "# Columns: ID KnownClass PredictedClass\n";

      for (my $i=0; $i<$n; $i++) {
	$id = $p{Input}{ids}->[$i];
	$knownclass = $p{Input}{knownclasses}->at($i);
	$predclass = $p{Output}{predclasses}->at($i);
	printf FILE "%-10s %u %u\n",
	  $id, $knownclass, $predclass;
      }
    }
    close(FILE);
  }
}

1;
