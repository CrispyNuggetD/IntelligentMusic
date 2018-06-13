#!/usr/bin/perl -w

use Getopt::Long;

my @logscale;
my %gnu;
my $title = '';
my ($refresh, $help);
my ($xcol, $ycol, $acol) = (2, 3);
GetOptions('logscale=s@'=>\@logscale,
	   'xrange=s'=>\$gnu{xrange},
	   'yrange=s'=>\$gnu{yrange},
	   'y2range=s'=>\$gnu{y2range},
	   'title=s'=>\$title,
	   'refresh=i'=>\$refresh,
	   'xcol=i'=>\$xcol,
	   'ycol=i'=>\$ycol,
	   'acol=i'=>\$acol, # a for Answer
	   'help'=>\$help,
	  );

die "usage: plot-fit.pl [ tournament_log_file ]
       (default is results/tournament.log)

options: -logscale y -logscale y2 ...
         -xrange '[1000:2000]'
         -yrange '[0:1]'
" if ($help);

while (! -e 'results/recent.testing.output') {
  print "waiting for output files...\n";
  sleep 30;
}

my @preamble;

foreach $axis (@logscale) {
  push @preamble, "set logscale $axis\n";
}

foreach $varname (qw(xrange yrange y2range)) {
  push @preamble, "set $varname $gnu{$varname}\n" if (defined $gnu{$varname});
}

if ($title) {
  push @preamble, "set title '$title'\n";
  $title = qq(-title "$title");
}

my @postamble;

if ($refresh) {
  push @postamble, "pause $refresh\n";
  print "ctrl-c to kill auto-refresh...\n";
}

my $persist = $refresh ? '-geometry 600x400+10+10' : '-persist';
do {
  system "gnuplot $persist $title <<EOI
set data style points
set key below
set ylabel 'predicted final amount'
set xlabel 'final amount'
@preamble
plot 'results/best.training.output' using $xcol:$ycol title 'Best ever training outputs' with points 3,\\
'results/best.testing.output' using $xcol:$ycol title 'Best ever testing outputs' with points 5,\\
'results/recent.training.output' using $xcol:$ycol title 'BoT training outputs' with points 2,\\
'results/recent.testing.output' using $xcol:$ycol title 'BoT testing outputs' with points 7,\\
x with lines 0
@postamble
EOI
";
exit if ($?); # child error
} while ($refresh);
