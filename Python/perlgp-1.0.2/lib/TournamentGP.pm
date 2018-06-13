package TournamentGP;
#GPL#

use SupervisedLearning;

@ISA = qw(SupervisedLearning);

sub _init {
  my ($self, %p) = @_;

  my %defaults = ( TournamentSize => 50,
		   Tournaments => 1000,
		   Tournament => 1,           # current tournament
		   TournamentsSinceBest => 0, # Tourns since best yet 
		   TournamentParents => 20,
		   TournamentKillAge => 2,
		   MateChoiceRandom => 0,

		   TournamentLogFile => 'results/tournament.log',
		   LogInterval => 10,

		   FitnessesFile => 'results/fitnesses',

		   ComplexityLogFile => 'results/complexity.log',
		   ComplexityInterval => 50,

		   RefreshInterval => 0,

		   RecentTrainingOutputFile=>'results/recent.training.output',
		   RecentTestingOutputFile =>'results/recent.testing.output',
		   RecentCodeFile => 'results/recent.pl',
		   RecentTreeFile => 'results/recent.daVinci',
		   RecentFileStem => 'results/recent',

		   BestTrainingOutputFile=>'results/best.training.output',
		   BestTestingOutputFile =>'results/best.testing.output',
		   BestCodeFile => 'results/best.pl',
		   BestTreeFile => 'results/best.daVinci',
		   BestFileStem => 'results/best',

		   KeepBest => 1, # 1 or 0
		   KeepBestDir => 'results/keptbest',
		   KeepMax => 100,  # only keep the most recent X

		   PopulationBackupInterval => 0,

		   EmigrateInterval => 0,
		   ImmigrateInterval => 0,
		   # MigrationSize is a property of Population

                   # Number of seconds system "alarm clock" is set to
                   # kill the evaluation of evolved code.  Note that
                   # you have to increase this as you increase the
                   # number of training examples (disabled when set to
                   # zero)
		   AlarmTime => 0,
		   # Set this to 1 if you're getting 'panic: leave scope inconsistency'
		   # errors after the alarm which are killing the whole run
		   ForkForEval => 0,

		   # if non-zero: don't cache fitness
                   # (if you have a real-time environment, for example)
		   AlwaysEvalFitness => 0,
		 );

  $self->SUPER::_init(%defaults, %p);

  $self->compulsoryParams(qw(Population FitnessDirection));

  $self->optionalParams(qw(BestFitness WorstPossibleFitness));
  unless (defined $self->WorstPossibleFitness()) {
    if ($self->FitnessDirection() =~ /up/i) {
      $self->WorstPossibleFitness(0);
    } else {
      $self->WorstPossibleFitness(1e99);
    }
  }
  $self->BestFitness($self->WorstPossibleFitness());

  # make the results directory if not there
  mkdir "results", 0755 unless (-d "results");

  # make the keep best dir
  mkdir $self->KeepBestDir, 0755
    if ($self->KeepBest() && ! -d $self->KeepBest());

  # look for existing tournament log and set Tournament and BestFitness
  if (open(LOG, $self->TournamentLogFile())) {
    my $lastline;
    while (<LOG>) {
      next if (/^\s*#/);
      $lastline = $_;
    }
    if ($lastline) {
      my ($time, $tournament, $bestfitness) = split ' ', $lastline;
      if (defined $bestfitness) {
	$self->Tournament($tournament+1)->BestFitness($bestfitness);
      }
      $self->parseExtraLogInfo($lastline);
    }
  }
}

sub run {
  my ($self, %p) = @_;
  $self->refresh() if ($self->RefreshInterval());
  $self->loadData() unless ($self->TrainingData());

  # keep track of which machines we ran on
  # and which job ids (from queuing system, if you use it)
  if (-d 'results') {
    system "hostname >> results/hosts";
    if ($ENV{PERLGP_JOBID} && $ENV{$ENV{PERLGP_JOBID}}) {
      if (open JIDS, ">>results/jobids") {
	print JIDS $ENV{$ENV{PERLGP_JOBID}}."\n";
	close(JIDS);
      }
    }
  }

  # now do the tournaments
  for (my $i=0; $i<$self->Tournaments(); $i++) {

    $self->refresh()
      if ($self->RefreshInterval() &&
	  $self->Tournament() % $self->RefreshInterval() == 0);

    $self->tournament();

    last if ($self->stopCondition());

    if ($self->ComplexityInterval() &&
	$self->Tournament() % $self->ComplexityInterval() == 0 &&
	-d $ENV{PERLGP_BIN} && $self->ComplexityLogFile() &&
	open(LOG, ">>$self->{ComplexityLogFile}")) {
      my $frac = 0.1;
      my $gzchars = `$ENV{PERLGP_BIN}/perlgp-sample-pop.pl $frac | gzip -c | wc -c`;
      if ($gzchars) {
	$gzchars =~ s/\s//g;
	my $c = $gzchars/($frac*$self->Population()->countIndividuals());
	printf LOG "%d %-7d %12.6g\n", time(), $self->Tournament(), $c;
      }
      close(LOG);
    }

    # back up the population (to .tar.gz file) if n
    if ($self->PopulationBackupInterval() &&
	$self->Tournament() % $self->PopulationBackupInterval() == 0) {
      $self->Population()->backup();
    }

    # do immigration and emigration
    if ($self->EmigrateInterval() &&
	defined $ENV{PERLGP_POPS} &&
	-d $ENV{PERLGP_POPS} &&
	$self->Tournament() % $self->EmigrateInterval() == 0) {
      $self->Population()->emigrate();
    }
    if ($self->ImmigrateInterval() &&
	defined $ENV{PERLGP_POPS} &&
	-d $ENV{PERLGP_POPS} &&
	$self->Tournament() % $self->ImmigrateInterval() == 0) {
      $self->Population()->immigrate();
    }

    $self->{Tournament}++;
  }
}

#
# SPLIT THIS INTO >1 METHODS (to allow inheritance specialiasation)
#
sub tournament {
  my ($self, %p) = @_;

  my $logtournament = ($self->Tournament() % $self->LogInterval() == 0);

  my @cohort = $self->Population()->selectCohort($self->TournamentSize());

  # sort out the young from the old in @cohort
  my (@young, @old);
  grep {
    if ($_->Age() >= $self->TournamentKillAge()) {
      push @old, $_;
    } else {
      push @young, $_;
    }
  } @cohort;
  # top up @young from @old if not enough
  while (@young < $self->TournamentParents()) {
    push @young, shift @old;
  }

  # evaluate Fitness for each potential parent (the young ones)
  my $bot = $young[0]; # best of tournament; initialise just in case no best
  my $bestfitness = $self->WorstPossibleFitness();
  my $testfitness = $self->WorstPossibleFitness();
  my ($newbest, $bestoutput, $testoutput);
  my ($ind, %fitness);

  my $lastinit;
  foreach $ind (@young) {
    my $output;
    my $fitness = $ind->Fitness();
    if (!defined $fitness || $self->AlwaysEvalFitness()) {
      $ind->reInitialise();
      $lastinit = $ind;
      $ind->Fitness($self->WorstPossibleFitness());
      my $child;
      if ($self->ForkForEval() && ($child = fork())) {
	wait; # forking is sometimes necessary if the alarm call crashes everything
	$ind->eraseMemory(); # force fitness recall from disk
	$fitness = $ind->Fitness();
	if (!defined $fitness) { # genome hash was corrupted somehow
	  $fitness = $self->WorstPossibleFitness();
	  $ind->retieGenome();
	  $ind->initTree();
	}
      } else {
	($fitness, $output) = $self->calcFitnessFor($ind, $self->TrainingData());
	$ind->Fitness($fitness);
        exit if ($self->ForkForEval());
      }
    }

    $fitness{$ind} = $fitness; # for a quicker sort below

    # save output (for later) if it's the best of tournament
    if ($self->decideBetterFitness($fitness, $bestfitness)) {
      $bot = $ind;
      $bestfitness = $fitness;
      $bestoutput = $output; # can be undefined (if it had stored fitness)

      # is this the best over all previous tournaments?
      if ($self->decideBetterFitness($fitness, $self->BestFitness())) {
	$self->BestFitness($fitness);
	$self->TournamentsSinceBest(0);
	$newbest = 1;
      }

      # and while indiv is still in memory, calculate test set outputs
      # if needed for logging
      if ($logtournament || $newbest) {
	$bot->reInitialise() unless ($lastinit && $lastinit == $bot);
	($testfitness, $testoutput) =
	  $self->calcFitnessFor($bot, $self->TestingData());

	# and $bestoutput may be empty if fitness was cached
	$bestoutput = $bot->evaluateOutput($self->TrainingData())
	  unless ($bestoutput);
      }
    }

    # make everyone a little bit older
    $ind->Age(+1);

  }
  # sort @young on fitness
  @young =  sort { $fitness{$a} <=> $fitness{$b} } @young;
  @young = reverse @young if ($self->FitnessDirection() =~ /up/i);

  # do we want a secondary sort on Age (younger better?)
  # there's a problem with the reversing then...

  # do some logging
  if ($logtournament && open(LOG, ">>".$self->TournamentLogFile())) {
    $bot->reInitialise() unless ($lastinit && $lastinit == $bot);
    printf LOG "%d %7d %12.6g %12.6g %12.6g %d %4d %s %s\n",
      time(), $self->Tournament(),
	$self->BestFitness(), $bot->Fitness(), $testfitness,
	  $bot->Age(), $bot->getSize(),
	    $self->extraLogInfo(), $bot->extraLogInfo();
    close(LOG);
  }
  if ($logtournament && $self->FitnessesFile() &&
      open(FIT, ">".$self->FitnessesFile())) {
    print FIT "# sorted fitnesses from last tournament\n";
    foreach $ind (@young) {
      print FIT "$fitness{$ind}\n";
    }
    close(FIT);
  }

  if ($newbest && $bestoutput) {
    # print to file the the best ever
    if ($self->BestTrainingOutputFile()) {
      $self->saveOutput(Input=>$self->TrainingData(),
			Output=>$bestoutput,
			Filename=>$self->BestTrainingOutputFile(),
			Individual=>$bot);
    }
    if ($self->BestTestingOutputFile() && $testoutput) {
      $self->saveOutput(Input=>$self->TestingData(),
			Output=>$testoutput,
			Filename=>$self->BestTestingOutputFile(),
			Individual=>$bot);
    }
    if ($self->BestCodeFile()) {
      $bot->saveCode(Filename=>$self->BestCodeFile(),
		     Tournament=>$self->Tournament());
    }
    if ($self->BestFileStem()) {
      $bot->save(FileStem=>$self->BestFileStem());
    }
    if ($self->KeepBest() && -d $self->KeepBestDir()) {
      $bot->save(FileStem=>sprintf("%s/Tournament-%07d",
				   $self->KeepBestDir(), $self->Tournament()));
      if ($self->KeepMax()) {
	# make sure we don't keep zillions of files
	my $fpi = 2; # number of files per Individual
	my @files = glob("$self->{KeepBestDir}/*");
	if (@files > $fpi*$self->KeepMax()) {
	  my $numtodelete = @files - $fpi*$self->KeepMax();
	  system "cd $self->{KeepBestDir} || exit; ls -1t | tail -$numtodelete | perl -nle unlink";
	}
      }
    }

  } elsif ($logtournament && $bestoutput) {
    # print to file the best of tournament (recent)
    if ($self->RecentTrainingOutputFile()) {
      $self->saveOutput(Input=>$self->TrainingData(),
			Output=>$bestoutput,
			Filename=>$self->RecentTrainingOutputFile(),
			Individual=>$bot);
    }
    if ($self->RecentTestingOutputFile() && $testoutput) {
      $self->saveOutput(Input=>$self->TestingData(),
			Output=>$testoutput,
			Filename=>$self->RecentTestingOutputFile(),
			Individual=>$bot);
    }
    if ($self->RecentCodeFile()) {
      $bot->saveCode(Filename=>$self->RecentCodeFile(),
		     Tournament=>$self->Tournament());
    }
    if ($self->RecentFileStem()) {
      $bot->save(FileStem=>$self->RecentFileStem());
    }
  }

  # make 'families' from the sorted @young and @old indivs.
  # (2 x parents, 2 x bad individuals to be replaced by offspring)
  my @families;
  $self->makeFamilies([@young, @old], \@families);

  # now perform crossover on the families
  grep $self->crossoverFamily($_), @families;

  $self->{TournamentsSinceBest}++;
}

sub makeFamilies {
  my ($self, $cohort, $families) = @_;
  # arrays passed as references otherwise there's a big speed hit.
  my @parents = splice @$cohort, 0, $self->TournamentParents();
  my @rip = splice @$cohort, -$self->TournamentParents();
  while (@parents >= 2 && @rip >= 2) {
    my @family;
    push @family, shift @parents;
    if ($self->{MateChoiceRandom}) { # choose mate randomly (biased to top)
      push @family, splice @parents, int(rand(1+int(rand(@parents)))), 1;
    } else { # or simply pick next best parent
      push @family, shift @parents;
    }
    push @family, splice @rip, 0, 2;

    push @$families, \@family;
  }
}

# should add some daVinci debugging somewhere...
sub crossoverFamily {
  my ($self, $family) = @_;
  my ($parent1, $parent2, $child1, $child2) = @$family;

  # only cross over if parent fitnesses are not the same
  if ($parent1->Fitness() != $parent2->Fitness()) {
    $parent1->tieGenome('p1'); $parent2->tieGenome('p2');
    $child1->tieGenome('c1');  $child2->tieGenome('c2');

    $parent1->crossover($parent2, $child1, $child2);
    $child1->mutate();
    $child2->mutate();

    $parent1->untieGenome(); $parent2->untieGenome();
    $child1->untieGenome();  $child2->untieGenome();
  } else { # if they are, 'punish' one of them...
    $parent2->mutate();
  }

  # warn "p1 $parent1->{tie_level} p2 $parent2->{tie_level} c1 $child1->{tie_level} c2 $child2->{tie_level}\n";
}

sub decideBetterFitness {
  my ($self, $left, $right) = @_;

  if ($self->FitnessDirection() =~ /up/i) {
    return $left > $right;
  } else {
    return $left < $right;
  }
}

sub calcFitnessFor {
  my ($self, $ind, $data) = @_;
  my $starttime = GPMisc::getTime();
  alarm($self->AlarmTime());
  my $output;
  eval {
    $output = $ind->evaluateOutput($data);
  };
  alarm(0);

  # maybe make a global count of the number of evaluations done

  if ($@) {
    if ($@ =~ /alarmed|syntax/) {
      my $code = $ind->getCode();
      print STDERR "problem code:\n\n$code\n\n";
    }
    warn $@;
    return $self->WorstPossibleFitness();
  }

  my $fitness = $self->fitnessFunction(Input=>$data,
				       Output=>$output,
				       TimeTaken=>GPMisc::getTime()-$starttime,
				       CodeSize=>$ind->getSize());

  $fitness = $self->WorstPossibleFitness() if ($fitness =~ /nan|inf/);

  return wantarray ? ($fitness, $output) : $fitness;
}


# you can redefine this to give info about how the
# algorithm is progressing (for example current size of training set)
sub extraLogInfo {
  my $self = shift;
  return '';
}

# this is called when the previous log is read in at the start
# of a run
sub parseExtraLogInfo {
  my ($self, $line) = @_;
}


sub refresh {
  my $self = shift;
  # you can redefine this method to
  # do something every $self->RefreshInterval()
}

sub stopCondition {
  my $self = shift;
  # you can redefine this method to
  # return true when it's time to stop
  return 0;
}


1;
