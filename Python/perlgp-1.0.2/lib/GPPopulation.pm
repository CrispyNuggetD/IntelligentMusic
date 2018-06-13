package GPPopulation;
#GPL#

use BasePopulation;

@ISA = qw(BasePopulation);

sub _init {
  my ($self, %p) = @_;

  my %defaults = ( MigrationSize => 50,
		 );

  $self->SUPER::_init(%defaults, %p);

  $self->optionalParams(qw(PopulationDir));

  die "  PERLGP_SCRATCH undefined or directory not found
  please see README file concerning shell environment variables\n\n"
    unless (defined $ENV{PERLGP_SCRATCH} && -d $ENV{PERLGP_SCRATCH});

  $self->PopulationDir("$ENV{PERLGP_SCRATCH}/$self->{ExperimentId}");
  mkdir $self->PopulationDir(), 0755 unless (-d $self->PopulationDir());

}

sub addIndividual {
  my ($self, $indiv) = @_;
  die "Population::addIndividual() - new individual must have a DBFileStem\n"
    unless ($indiv->DBFileStem());
  $usedfilestems{$indiv->DBFileStem()} = 1;

  $self->SUPER::addIndividual($indiv);
}

my $g_filenum = 1;

sub findNewDBFileStem {
  my $self = shift;
  my $fs;
  while (($fs = sprintf("%s/%s/Individual-%06d",
	        $ENV{PERLGP_SCRATCH}, $self->ExperimentId(), $g_filenum)) &&
	 $usedfilestems{$fs}) {
    $g_filenum++;
  }
  return $fs;
}

sub repopulate {
  my ($self, %p) = @_;

  # option: $p{RandomFraction} only load up some of the files

  my @glob = glob("$self->{PopulationDir}/Individual-*");

  # note: could possible add here a time stamp check on the tar file
  # and scratch directory

  # if no files were found at all then look for a tar file
  if (@glob == 0 && $ENV{PERLGP_POPS}) {
    my $tarfile = sprintf "%s/%s.tar.gz", $ENV{PERLGP_POPS}, $self->ExperimentId();
    if (-s $tarfile) {
      warn "updating $self->{PopulationDir} from $tarfile\n";
      system "ulimit -t 300; cd $ENV{PERLGP_SCRATCH} ; tar xzf $tarfile";
    }
    # and re-do the glob
    @glob = glob("$self->{PopulationDir}/Individual-*");
  }


  # now just add new Individuals for each unique filestem found
  foreach my $fs (@glob) {
    $fs =~ s/\.\w+$//; # chop off the file extension .pag or .dir (usually)
    next if ($usedfilestems{$fs}++);
    next if ($p{RandomFraction} && rand() > $p{RandomFraction});

    $self->addIndividual(new Individual( Population => $self,
					 ExperimentId => $self->ExperimentId(),
					 DBFileStem => $fs,
					 ));
  }
}

sub backup {
  my $self = shift;
  if ($ENV{PERLGP_POPS}) {
    my $tarfile = sprintf "%s/%s.tar.gz",
      $ENV{PERLGP_POPS}, $self->ExperimentId();
    my $retval = system "ulimit -t 300; cd $ENV{PERLGP_SCRATCH} ; tar czf $tarfile $self->{ExperimentId}";
    unlink $tarfile if ($retval);
  }
}

sub emigrate {
  my $self = shift;
  return unless ($self->MigrationSize());

  my $edir = sprintf "%s/gp-migrants",
    $ENV{PERLGP_SCRATCH};
  system "rm -rf $edir" if (-d $edir);
  mkdir $edir, 0755;
  if (-d $edir) {
    my @migrants = $self->selectCohort($self->MigrationSize());
    for (my $i=0; $i<@migrants; $i++) {
      my $filestem = sprintf "%s/Migrant-%03d", $edir, $i;
      $migrants[$i]->save(FileStem=>$filestem);
    }
    my $tarfile = $self->export_tar_file();
    my $retval = system "ulimit -t 300; cd $ENV{PERLGP_SCRATCH} ; tar czf $tarfile gp-migrants";
    unlink $tarfile if ($retval);
    system "rm -rf $edir";
  }
}

sub export_tar_file {
  my $self = shift;
  return sprintf "%s/%s.export.tar.gz",
    $ENV{PERLGP_POPS}, $self->ExperimentId();
}

sub immigrate {
  my $self = shift;
  return unless ($ENV{PERLGP_POPS} && $self->MigrationSize());

  # find all the 
  my $owntarfile = $self->export_tar_file();
  my $numberless_exptid = $self->ExperimentId();
  $numberless_exptid =~ s/-\d+$//; # e.g. anttrail-03 -> anttrail
  my @imports = grep $_ ne $owntarfile,
    glob "$ENV{PERLGP_POPS}/$numberless_exptid*export.tar.gz";
  if (@imports) {
    # unpack one of the tar files
    my $import = $imports[int rand @imports];
    system "ulimit -t 300; cd $ENV{PERLGP_SCRATCH}; tar xzf $import; rm -f $import";
    # now /scratch/gp-migrants is full of migrants
    my @files = glob "$ENV{PERLGP_SCRATCH}/gp-migrants/*";
    my %usedfilestems;
    foreach my $fs (@files) {
      $fs =~ s/\.\w+$//; # chop off the file extension .pag or .dir (usually)
      next if ($usedfilestems{$fs}++);

      # choose a random individual from THIS population
      my $ind = $self->randomIndividual();
      # and load up genome from this immigrant db file
      $ind->load(FileStem=>$fs);
      # and init the fitness of the 'new' individual
      $ind->initFitness();
    }
    system "cd $ENV{PERLGP_SCRATCH}; rm -rf gp-migrants";
  }
}


sub initFitnesses {
  my $self = shift;
  foreach my $ind (@{$self->Individuals()}) {
    $ind->initFitness();
  }
}


# reinitialise all individuals with new GP trees!
sub cleanSweep {
  my $self = shift;
  foreach my $ind (@{$self->Individuals()}) {
    $ind->initTree();
    $ind->eraseMemory();
  }
}


1;
