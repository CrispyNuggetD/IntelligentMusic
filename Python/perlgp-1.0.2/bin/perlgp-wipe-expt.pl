#!/usr/bin/perl -w
#GPL#

use Cwd;

my $bdir = cwd();

push @ARGV, '.' unless (@ARGV);
foreach $edir (@ARGV) {

  chdir $edir;
  my $dir = cwd();
  ($dir) = $dir =~ m{/([^/]+)$};

  die "you're not in an experiment directory\n
usage: perlgp-wipe-expt.pl [ optional expt directories ]\n"
    unless (-e "Individual.pm" && -e "Algorithm.pm");

  die "PERLGP_SCRATCH not set\n" unless ($ENV{PERLGP_SCRATCH});


  system "rm -rf ./results $ENV{PERLGP_SCRATCH}/$dir";

  if ($ENV{PERLGP_POPS}) {
    system "rm -rf $ENV{PERLGP_POPS}/$dir.*";
  }
  chdir $bdir;

}
