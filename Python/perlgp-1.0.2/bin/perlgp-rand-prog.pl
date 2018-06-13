#!/usr/bin/perl -w
#GPL#

use lib '.', $ENV{PERLGP_LIB} ||  die "
  PERLGP_LIB undefined
  please see README file concerning shell environment variables\n\n";

use Individual;
use Cwd;
use POSIX qw(tmpnam);
use Getopt::Long;

my $evalevolved;
GetOptions(evalevolved=>\$evalevolved);

my ($exptid) = cwd() =~ m:([^/]+)$:;

my $dbfile = tmpnam();

my $ind = new Individual( Population => 'dummy',
			  ExperimentId => $exptid,
			  DBFileStem => $dbfile );

if ($evalevolved) {
  $ind->evalEvolvedSubs();
}

$ind->saveCode(Filename=>'-');


unlink glob("$dbfile.*");
