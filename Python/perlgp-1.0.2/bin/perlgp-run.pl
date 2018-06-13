#!/usr/bin/perl -w
#GPL#

use lib '.', $ENV{PERLGP_LIB} ||  die "
  PERLGP_LIB undefined
  please see README file concerning shell environment variables\n\n";

use Population;
use Individual;
use Algorithm;
use Cwd;

use Getopt::Long;
my $loop;
GetOptions(loop=>\$loop); # see NB below

if ($loop) { # keep running forever (without the -loop option of course)
  while (1) { # useful if you have unavoidable crashes
    # (virtual) memory limit
    my $maxmem = 2*1024*1024;
    system "ulimit -v $maxmem; $0"; # NB: no options passed on
    warn "perlgp crashed - restarting in 60 seconds...\n";
    sleep 60;
  }
}


# get the name of this run from the current directory.
# this will be used for filenames to save populations etc.
my ($exptid) = cwd() =~ m:([^/]+)$:;

# make an empty Population object
my $population = new Population( ExperimentId => $exptid,
			       );

# and fill it from disk or tar file
$population->repopulate();

# or fill it up with new Individuals
while ($population->countIndividuals() < $population->PopulationSize()) {
  $population->addIndividual(new Individual( Population => $population,
				             ExperimentId => $exptid,
			  DBFileStem => $population->findNewDBFileStem()));
}

my $algorithm = new Algorithm( Population => $population );

# run the algorithm!
$algorithm->run();



