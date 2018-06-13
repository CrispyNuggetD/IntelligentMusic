#!/usr/bin/perl -w
#                          -*- Mode: Cperl -*-
#
# usage:  ./perlgp-avg-logs.pl NAME1 GLOB1 [NAME2 GLOB2]
#
# where GLOB1 is a glob expression (protected from the shell)
#       such as 'myexpt-*'
# and   NAME1 is just a name you give to it (i.e. myexpt)
#
#
# what it does: it assumes it can find 'results/tournament.log' and
# perhaps other files in each of the directory globs it then
# calculates mean and sd for each column in the last line of the
# tournament.log files and prints out the results for each 'name'
# (experiment type)
#
#
#GPL#

use Getopt::Long;

my $help;
my $se;
my $tlog = "results/tournament.log";
my $timediff = 1;
my @logs = ();
my $base;
my $tournament;

GetOptions("help"=>\$help,
	   "se"=>\$se,  # standard error of mean (not STDERR!)
	   "tlog=s"=>\$tlog,
	   "timediff!"=>\$timediff, # turn off unix time subtraction
                                    # on first column
	   "logs=s@"=>\@logs,       # take logs on these columns
	   "base=s"=>\$base,        # optional log base
	   "tournament=i"=>\$tournament,
	                            # don't take last line, take tournament X
	   );

die `perl -npe 'exit unless /^#/' $0` unless (@ARGV && @ARGV % 2 == 0);

my %globs = @ARGV;
my @names = grep exists $globs{$_}, @ARGV; # to keep them in order

@logs = map { split /\D+/, $_ } @logs;

my %logs; grep $logs{$_}=1, @logs;
my $numcols;

my (%vals, %sum, %sumsq, %strcnt, %n, %mean, %sd);

my $number = qr/-?[0-9.]+(?:[eE]-?\d+)?/;

foreach $name (@names) {
  my @summs = glob "$globs{$name}/$tlog";
  $n{$name} = scalar @summs;

  foreach $summary (@summs) {
    my $line;

    if ($tournament && open(SUMM, $summary)) {
      while (<SUMM>) {
	my @c = split;
	$line = $_;
	last if ($c[1] == $tournament);
      }
      close(SUMM);
    } else {
      $line = `tail -1 $summary`;
    }
    my @cols = split ' ', $line;

    if ($timediff) {
      my $firstline = `grep -v ^# $summary | head -1`;
      my @fcols = split ' ', $firstline;
      $cols[0] -= $fcols[0];
    }

    if ($numcols) {
      die "differing number of columns for $name $summary" unless ($numcols == @cols);
    } else {
      $numcols = @cols;
    }

    foreach $logcol (@logs) {
      $cols[$logcol] = log($cols[$logcol]);
      $cols[$logcol] /= log($base) if ($base);
    }

    for (my $i=0; $i<@cols; $i++) {
      push @{$vals{$name}[$i]}, $cols[$i];
      if ($cols[$i] =~ /^$number$/) {
	# sum up
	$sum{$name}[$i] += $cols[$i];
	$sumsq{$name}[$i] += $cols[$i]*$cols[$i];
      } else {
	# or count how often a non-number occurs
	$strcnt{$name}[$i]{$cols[$i]}++;
      }
    }
  }
  # calculate mean and s.d. of sample
  for (my $i=0; $i<$numcols; $i++) {
    if (defined $sum{$name}[$i]) {
      my $sum = $sum{$name}[$i];
      my $sumsq = $sumsq{$name}[$i];
      my $n = $n{$name};
      $mean{$name}[$i] = $sum/$n;
      if ( $sumsq-$sum*$sum/$n < 0 ) {
	$sd{$name}[$i] = -1;
      } else {
	$sd{$name}[$i] = sqrt( ($sumsq-$sum*$sum/$n) / ($n-1));
      }

      # convert to standard error of mean if necessary
      if ($se && $sd{$name}[$i] > 0) {
	$sd{$name}[$i] /= sqrt($n);
      }
    }
  }
}


# now print out the summaries for each column
# in rows (if you see what i mean...)
print "\nexpt   ";
foreach $name (@names) {
  printf "%16s %8s ", $name, '';
}
print "\nreps   ";
foreach $name (@names) {
  printf "%16d %8s ", $n{$name}, '';
}
print "\n       ";
my $sd = $se ? 's.e.' : 's.d.';
foreach $name (@names) {
  printf "%12s %12s ", 'mean', $sd;
}
print "\n";
for (my $i=0; $i<$numcols; $i++) {
  my $aname = $names[0];
  my $type;
  if (defined $sum{$aname}[$i]) {
    printf "ncol %2d%s", $i, $logs{$i} ? 'L' : ' '; # 'L' for logged
    $type = 'numeric';
  } elsif (defined $strcnt{$aname}[$i] &&
	  keys %{$strcnt{$aname}[$i]} != 1 &&
	  keys %{$strcnt{$aname}[$i]} != $n{$aname}) {
    # it was a string which wasn't all the same or all different
    # in the first 'name'
    printf "scol %2d ", $i;
    $type = 'string';
  } else {
    next;
  }
  foreach $name (@names) {
    if ($type eq 'numeric') {
      # print mean and s.d.
      printf "%12.6g %12.6g ", $mean{$name}[$i], $sd{$name}[$i];
    } else {
      my @most1st =
	sort {$strcnt{$name}[$i]{$b} <=> $strcnt{$name}[$i]{$a}}
	  keys %{$strcnt{$name}[$i]};
      printf "%25s ", $most1st[0];
    }
  }
  if (@names == 2 && $type eq 'numeric' && !$se) {
    printf " d= %10.4g", dcalc(@names, $i);
  }
  print "\n";
}


sub dcalc {
  my ($x, $y, $dcol) = @_;
  my $d = 0;

  if ($sd{$x}[$dcol] <= 0 && $sd{$y}[$dcol] > 0) {
    # compare mean with standard
    $d = ($mean{$y}[$dcol] - $mean{$x}[$dcol])
      / ($sd{$y}[$dcol]/sqrt($n{$y}));
  } elsif ($sd{$y}[$dcol] <= 0 && $sd{$x}[$dcol] > 0) {
    # compare mean with standard
    $d = ($mean{$x}[$dcol] - $mean{$y}[$dcol])
      / ($sd{$x}[$dcol]/sqrt($n{$x}));
  } elsif ($sd{$x}[$dcol] > 0 && $sd{$y}[$dcol] > 0) {
    # comparing two means
    $d = ($mean{$x}[$dcol] - $mean{$y}[$dcol])
      / sqrt( $sd{$x}[$dcol]*$sd{$x}[$dcol]/$n{$x}
	      + $sd{$y}[$dcol]*$sd{$y}[$dcol]/$n{$y} );
  }
  return $d;
}
