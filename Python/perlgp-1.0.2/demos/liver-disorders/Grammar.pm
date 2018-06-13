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

sub classify {
  my $in = shift;
  return {BOOL};
}

{EVLINIT}
___
];

$T{ROOT} = [ 'sub classify { return 0; }' ];

$F{BOOL} = [ copies(1, '({BOOL} || {BOOL})',
                       '{BOOL} && {BOOL}'),
             copies(5, '{NUM} > {NUM}'),
];

$T{BOOL} = [ 0, 1 ];


$F{NUM} = [ copies(4, '({NUM} {OP} {NUM})'),
            copies(1, 'log({NUM})', 'abs({NUM})'),
            copies(5, '$in->{{VARNAME}}'),
            copies(5, '{INT}'),
];

$T{VARNAME} = [ qw(1 2 3 4 5 6) ];

$T{OP} = [ qw(+ - * /) ];

$T{NUM} = $T{INT} = [ 0 .. 100 ];

$F{EVLINIT} = [ <<'___',
sub evolvedInit {
  my $self = shift;
  $self->NodeMutationProb(1/{DENOM});
  $self->NodeXoverProb(1/{DENOM});
}
___
];

$T{EVLINIT} = [ <<'___',
sub evolvedInit {
  my $self = shift;
  $self->NodeMutationProb(0.666);
  $self->NodeXoverProb(0.666);
}
___
];


# this will be evolved by "numeric mutation" during the run...
$T{DENOM} = [ 25 ]; # [ 25, 50, 100, 200 ];


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
