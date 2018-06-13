#!/usr/bin/perl -w
#                          -*- Mode: Cperl -*-


#
# not to be used directly...  called by perlgp-mrun.pl -parallel
#


use lib '/pdc/vol/easy/1.6/lib';
use Getopt::Long;
use Easy;
use Cwd;

die "environment var PERLGP_BIN must be set\n"
  unless ($ENV{PERLGP_BIN} && -d $ENV{PERLGP_BIN});
my $runcmd = "$ENV{PERLGP_BIN}/perlgp-run.pl";

my $loop;

GetOptions("loop"=>\$loop,
	  );

my $loopopt = $loop ? "-loop" : "";

my @dirs = grep { -d $_ } @ARGV;

unless (@dirs) {
  die "run directories can't be seen here\n";
}

my $cwd = cwd();

if ($ENV{SP_HOSTFILE} && open(HOSTS, $ENV{SP_HOSTFILE})) {
  while (<HOSTS>) {
    my ($host) = split;
    if (defined $host && @dirs) {
      my $dir = shift @dirs;

      my $child = fork();
      if (! defined $child) {
	die "fork failed, aborting...\n";
      } elsif ($child == 0) {
	# child process here

	exec("$Easy::RSH $host \" cd $cwd/$dir ; $runcmd $loopopt >& /dev/null \"");
	# must exit or exec here
      }

    }
  }
  close(HOSTS);

} else {
  warn "could not find/read SP_HOSTFILE ($ENV{SP_HOSTFILE})\n";
}
