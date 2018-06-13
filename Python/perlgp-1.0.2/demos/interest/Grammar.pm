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
  my ($ia, $ir, $yd, $ny, $x, $y, $z, @output);
  foreach $input (@$data) {
    ($ia, $ir, $yd, $ny) = ($input->{ia}, $input->{ir},
                            $input->{yd}, $input->{ny});
    ($x, $y, $z) = (0, 0, 100);
    # begin evolved bit

    {STMNT}

    push @output, {NUM};
    # end evolved bit
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

$F{STMNT} = [ copies(3, '{STMNT}
    {STMNT}'),
copies(9, '{VAR} = {NUM};'),
copies(2, 'if ({NUM}>0) {
    {STMNT}
    }'),
copies(3, 'for (my $i=0; --$z>0 && $i<{NUM}; $i++) {
    {STMNT}
    }'),
];

$T{STMNT} = [ '# nothing' ];

$F{NUM} = [ '{NUM}*{NUM}',
	    'pdiv({NUM},{NUM})',
	    '({NUM} + {NUM})',
	    '({NUM} - {NUM})',
	    # 'ppow({NUM},{NUM})',
            copies(3, '{NUMX}'),
	    copies(6, '{VAR}'),
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

$T{NUM} = $T{NUMX} = [ 1 ];
$T{VAR} = [ qw($ia $ir $yd $ny $x $y) ];
$T{POW} = [ 2 .. 7 ];
$T{DENOM} = [ 100 ]; # [ 25, 50, 100, 200 ];

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
