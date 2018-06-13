#!/usr/bin/perl -w
#GPL#

use lib '.', $ENV{PERLGP_LIB} ||  die "
  PERLGP_LIB undefined
  please see README file concerning shell environment variables\n\n";

use Getopt::Long;
use Individual;
use Cwd;
use POSIX qw(tmpnam);

my ($help, $tree);
GetOptions(help=>\$help, tree=>\$tree);

my $file = shift;

die "usage: perlgp-show-prog.pl [-tree] filestem\n" if ($help || !$file);

my ($exptid) = cwd() =~ m:([^/]+)$:;

my ($filestem) = $file =~ /(.+?)(\.\w*)?$/;

my $ind = new Individual( Population => 'dummy',
			  ExperimentId => $exptid,
			  DBFileStem => $filestem );

if ($tree) {
  my $tmp = tmpnam();
  $ind->saveTree(Filename=>$tmp);
  system "daVinci $tmp";
  unlink $tmp;
} else {
  $ind->saveCode(Filename=>'-');
}
