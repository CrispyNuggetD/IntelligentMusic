#!/usr/bin/perl -w

my $numpoints = 50;

# function returns the value of an investment
# after a certain number of years

# ia = initial amount
# ir = interest rate, e.g. 0.045
# yd = yearly deposit (see below)
# ny = number of years

sub function {
  my ($ia, $ir, $yd, $ny) = @_;

  my $sum = $ia;
  foreach (1 .. $ny) {
    $sum += $yd;
    $sum *= (1+$ir);
  }
  return $sum;
}

foreach $file (qw(train.dat test.dat)) {
  open(FILE, ">$file") || die;
  foreach (1 .. $numpoints) {
    my $ia = int(rand(2000));
    my $ir = 0.01 + rand(0.09);
    my $yd = int(rand(100));
    my $ny = 1 + int(rand(10));
    my $y = function($ia, $ir, $yd, $ny);
    printf FILE "%d %.15f %d %d %.15f \n", $ia, $ir, $yd, $ny, $y;
  }
  close(FILE);
}
