#!/usr/bin/perl -w
#GPL#

use lib '.', $ENV{PERLGP_LIB} ||  die "
  PERLGP_LIB undefined
  please see README file concerning shell environment variables\n\n";

use Getopt::Long;
use Individual;
use Population;
use Cwd;
use POSIX qw(tmpnam);

my ($help);
GetOptions(help=>\$help);

my $frac = shift || 0.1;

die "usage: perlgp-sample-pop.pl [fraction of pop]\n" if ($help);

my ($exptid) = cwd() =~ m:([^/]+)$:;

my $population = new Population( ExperimentId => $exptid );

# and fill it from disk or tar file
$population->repopulate(RandomFraction=>$frac);

if ($population->countIndividuals()) {
  foreach $ind (@{$population->Individuals()}) {
    $ind->saveCode(Filename=>'-');
  }
} else {
  print "empty population\n";
}

