#!/usr/bin/perl -w
#GPL#

use Getopt::Long;
use Cwd;

my @logscale;
my ($timebased, %gnu);
my $title = '';
my ($refresh, $help, $geometry);
GetOptions('logscale=s@'=>\@logscale,
	   'timebased'=>\$timebased,
	   'xrange=s'=>\$gnu{xrange},
	   'yrange=s'=>\$gnu{yrange},
	   'y2range=s'=>\$gnu{y2range},
	   'title=s'=>\$title,
	   'refresh=i'=>\$refresh,
	   'geometry=s'=>\$geometry,
	  );

my $tlog = shift || 'results/tournament.log';

die "usage: plot-tlog.pl [ tournament_log_file ]
       (default is results/tournament.log)

options: -logscale y -logscale y2 ...
         -xrange '[1000:2000]'
         -yrange '[0:1]'
         -y2range '[0:200]' (code size)
" if ($help);


my $cwd = cwd();
($title) = $cwd =~ m{([^/]+)$} unless ($title);

my @h;
while (! -e $tlog || (@h = `head -10 $tlog`) < 2) {
  print "waiting for output file ($tlog)...\n";
  sleep 30;
}

my @preamble;

foreach $axis (@logscale) {
  push @preamble, "set logscale $axis\n";
}

my $xcol;
if ($timebased) {
  my ($timezero) = split ' ', `head -1 $tlog`;
  $xcol = "((\\\$1-$timezero)/60/60)";
  push @preamble, "set xlabel 'hours since start of run'\n";
} else {
  $xcol = 2;
  push @preamble, "set xlabel 'tournament'\n";
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


my $persist = $refresh ? '' : '-persist';
my $geoopt = $geometry ? "-geometry $geometry" : '';

do {
  my $complexity = '';
  if (-s 'results/complexity.log') {
    $complexity = ", 'results/complexity.log' using $xcol:3 axes x1y2 title 'Population complexity' with lines 7";
  }
  system "gnuplot $persist $geoopt $title <<EOI
set data style lines
set key below
set y2tics
set y2label 'Code size/complexity'
set ylabel 'Fitness'
@preamble
plot '$tlog' using $xcol:3 title 'Best ever training fitness', '' using $xcol:4 title 'BoT training fitness', '' using $xcol:5 title 'BoT testing fitness', '' using $xcol:7 axes x1y2 title 'Code size' with lines 0 $complexity
@postamble
EOI
";
exit if ($?); # child error
} while ($refresh);
