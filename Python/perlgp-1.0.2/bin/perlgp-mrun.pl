#!/usr/bin/perl -w
#                          -*- Mode: Cperl -*-
#
# usage:  perlgp-mrun.pl -num 30 EXPT_DIR [EXPT2_DIR ...]
#
# EXPT_DIR must be relative to/exist in the current directory!
#
# what it does:
#  creates EXPT_DIR-01 EXPT_DIR-02 ... EXPT_DIR-30
#  and either runs them in series
#  or if -queue is specified sends them to the local queuing system
#  You will need to MODIFY this program so it works for your system
#
# at the end of the runs:
#  you can compare the tournament logs with perlgp-avg-logs.pl
#
#GPL#

use Getopt::Long;

die "environment var PERLGP_BIN must be set\n"
  unless ($ENV{PERLGP_BIN} && -d $ENV{PERLGP_BIN});

my $number = 30;       # how many replicates of 'exptdir' to run
my $loop;              # add -loop to the perlgp-run.pl command

                       # time limits are enforced with bash 'ulimit' if you
                       # don't use a queuing system
my $hours;             # max time for jobs to run
my $minutes = 0;       # the same in minutes if you prefer (overrides $hours)


my $queue;             # send jobs to queueing system
my $subsleep = 1;      # how long to sleep between job submissions (secs)
my $nodetype = '1V';   # node type for cluster

my $parallel;          # send jobs in parallel to cluster

my $chain = 1;         # chain jobs with esubmit's -F option
my $continue;          # doesn't copy any directories, but
                       # continues from an old job.
                       # if combined with -chain, will wait for current
                       # jobs to finish (sets -F option to
                       # the last line in the file EXPT_DIR-xx/results/jobids)
                       # make sure $ENV{PERLGP_JOBID} is set

my $wipe = 1;          # use -nowipe to prevent wiping

my $wipecmd = "$ENV{PERLGP_BIN}/perlgp-wipe-expt.pl";
my $runcmd = "$ENV{PERLGP_BIN}/perlgp-run.pl";
my $parallelcmd = "$ENV{PERLGP_BIN}/perlgp-prun.pl";

my $help;

GetOptions("number=i"=>\$number,
	   "minutes|mins=i"=>\$minutes,
	   "hours|hrs=i"=>\$hours,
	   "nodetype=s"=>\$nodetype,
	   "subsleep=i"=>\$subsleep,
	   "loop!"=>\$loop,
	   "wipe!"=>\$wipe,
	   "queue"=>\$queue,
	   "parallel"=>\$parallel,
	   "continue"=>\$continue,
	   "chain=i"=>\$chain,
	   "help"=>\$help,
	   "runcmd=s"=>\$runcmd,
	   );

my @masters = @ARGV;

my @okmasters = grep -d $_, @masters;

die `perl -npe 'exit unless /^#/' $0` if ($help || @okmasters != @masters);

die "-loop should only be used with -queue or -minutes or -hours options\n"
  if ($loop && ! ($queue || $parallel || $minutes || $hours));

die "can't use -chain and -parallel together, sorry\n" if ($chain > 1 && $parallel);

my $loopopt = $loop ? '-loop' : '';

grep s{/+$}{}, @masters; # remove trailing slashes if any

$minutes = $hours*60 unless ($minutes);
my $seconds = $minutes*60;
die "you didn't set the queue time\n" if (($queue || $parallel) && !$minutes);

$wipecmd = '/bin/true' unless ($wipe);

my $numwidth = length($number);
$numwidth = 2 if ($numwidth < 2);
my $format = "%0${numwidth}d";

my @dirnums = map sprintf($format, $_), (1 .. $number);

my @dirs;
my %subdirs;
foreach my $dirnum (@dirnums) {
  foreach my $master (@masters) {
    my $copydir = "$master-$dirnum";
    unless (-d $copydir) {
      # copy master directory
      # clear out any results directory or stored populations
      # -L option makes a real copy of a dir which is a symlink
      system "cp -rL $master $copydir; cd $copydir; $wipecmd";
    } elsif ($continue) {
      print "continuing from previous run for $copydir\n";
    } else {
      print "did you know $copydir already exists?\n";
    }
    die "some problem creating $copydir\n" unless (-d $copydir);
    push @dirs, $copydir;
    push @{$subdirs{$master}}, $copydir;
  }
}

unless ($queue || $parallel) {
  foreach $dir (@dirs) {
    print "starting $dir at ", `date`;
    my $ulimit = $seconds ? "ulimit -t $seconds;" : '';
    my $rv = system "$ulimit cd $dir; $runcmd $loopopt";
    die "interrupted\n" if (!$ulimit && $rv);
    print "finished $dir at ", `date`;
  }
} else { # use the queueing system

  print "sending jobs to queuing system...\nmake sure there are no jobs of the same type currently queued.\n";

  ### LOCAL STUFF FOR QUEUING
  # PDC module command
  die "MODULESHOME not set/available, can't do queueing\n"
    unless ($ENV{MODULESHOME} && -d $ENV{MODULESHOME});
  sub module { eval `$ENV{MODULESHOME}/bin/modulecmd perl @_`; }
  # use the PDC queueing stuff
  module('add easy');

  if ($parallel) {
    my $nodes = $nodetype;
    $nodes =~ s/^\d*/$number/;  # e.g. 1V -> 16V

    foreach $master (@masters) {
      my $res = `esubmit -t $minutes -n $nodes -m -v $parallelcmd $loopopt @{$subdirs{$master}}`;

      my ($jid) = $res =~ /(\d+)\s*$/;
      if ($jid) {
	print "$master queued with -t $minutes -n $nodes\n";
      } else {
	print "WARNING: no job id from $master submission\n";
      }
      sleep $subsleep;
    }
  } else {
    my %lastjid;
    foreach (1 .. $chain) {
      foreach $dir (@dirs) {

	# if -continue or chain>1, find which job to wait for
	if (($continue || $chain>1) &&
	    -e "$dir/results/jobids" && !$lastjid{$dir}) {
	  my $waitjid = `tail -1 $dir/results/jobids`;
	  chomp($waitjid);
	  $lastjid{$dir} = $waitjid;
	  # Note: you need to set PERLGP_JOBID for this to work
	}

	my $chopt = $lastjid{$dir} ? "-F $lastjid{$dir}" : '';
	# actually send the job
	my $res = `cd $dir; esubmit -v -m -n $nodetype -t $minutes $chopt $runcmd $loopopt`;
	# collect the job id
	my ($jid) = $res =~ /(\d+)\s*$/;
	if ($jid) {
	  $lastjid{$dir} = $jid;
	  print "$dir queued with job id $jid (options: -n $nodetype -t $minutes $chopt)\n";
	} else {
	  print "WARNING: no job id from $dir submission\n";
	}
	sleep $subsleep;
      }
    }
  }
}
