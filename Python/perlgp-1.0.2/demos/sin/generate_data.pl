#!/usr/bin/perl -w

my $range = shift;

my $pi = 2*atan2(2,0);
my ($minrange, $maxrange) = (0.1, 3*$pi);
$range = $minrange unless ($range);
$range = $maxrange if ($range>$maxrange);
$range = $minrange if ($range<$minrange);

my $numpoints = int(20*sqrt($range/$minrange));
my $xcentre = 0;
my ($xmin, $xmax) = ($xcentre-$range, $xcentre+$range);

my $rt2 = sqrt(2);
my $rt3 = sqrt(3);

sub function {
  my ($x) = @_;

  return sin($x);
  # for more of a challenge, try: sin($x - $rt3) + $rt2;
}

foreach $file (qw(train.dat test.dat)) {
  open(FILE, ">$file") || die;
  foreach (1 .. $numpoints) {
    my $x = $xmin + rand($xmax-$xmin);
    my $y = function($x);
    printf FILE "%.15f %.15f\n", $x, $y;
  }
  close(FILE);
}
