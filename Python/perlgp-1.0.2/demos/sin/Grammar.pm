package Grammar;

# the PerlGP library is distributed under the GNU General Public License
# all software based on it must also be distributed under the same terms


# NODETYPES must be {LIKE} {THIS} - capitals only in curly brackets
# therefore you can't have things like $input->{X} in your code, sorry.
#
# Every type should be defined as an anonymous array.
# You must define the ROOT type, and while functions are optional,
# every type *must have at least one terminal* defined.  ROOT should
# start with 'package Individual;' and define evaluateOutput subroutine.
#
# If you need to make new functions (e.g. pdiv), define them in Individual.pm
# and you can use them here
#
# Due to the limitations of the SDBM module, each string you define
# must be less than 1000 characters

# Functions
%F = ();
# Terminals
%T = ();

$F{ROOT} = [ <<'___',
package Individual;

{EVLINIT}
sub evaluateOutput {
  my ($self, $data) = @_;
  my ($x, $y, $z, @output);
  foreach $input (@$data) {
    $x = $input->{x};
    # begin evolved bit

    $y = {NUM};

    # end evolved bit
    push @output, { 'y'=> $y };
  }
  return \@output;
}
___
];

$F{EVLINIT} = [ <<'___',
sub evolvedInit {
  my $self = shift;
  $self->NodeMutationProb(1/{DENOM});
  $self->NodeXoverProb(1/{DENOM});
}
___
];

$F{NUM} = [ '{NUM}*{NUM}',
	    'pdiv({NUM},{NUM})',
	    '({NUM} + {NUM})',
	    '({NUM} - {NUM})',
            copies(6, '{NUMX}'),
	    copies(2, '{VAR}'),
	  ];

$T{ROOT} = [ 'sub evaluateOutput { return }' ];
$T{EVLINIT} = [ <<'___',
sub evolvedInit {
  my $self = shift;
  $self->NodeMutationProb(0.666);
  $self->NodeXoverProb(0.666);
}
___
];

$T{NUM} = $T{NUMX} = [ 1, 2, 3, 5, 7 ];
$T{VAR} = [ '$x' ];
$T{POW} = [ 2 .. 7 ];
$T{DENOM} = [ 50 ]; # [ 25, 50, 100, 200 ];

# this helper routine will give you multiple copies of
# something, i.e qw(1 1 1 2 3) is equivalent to (copies(3, 1), 2, 3)
sub copies {
  my ($num, @things) = @_;
  my @result;
  while ($num-->0) {
    push @result, @things;
  }
  return @result;
}

1;
