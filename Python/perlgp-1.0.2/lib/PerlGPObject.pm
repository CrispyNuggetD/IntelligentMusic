package PerlGPObject;
#GPL#

#
# universal base class for all PerlGPObjects.
#

use Carp;

# universal constructor
sub new {
  my ($class, @args) = @_;
  my $self = { Class=>$class };
  bless $self, $class;
  $self->_init(@args); # @args is actually a hash table, see %p in _init
  return $self;
}

sub _init {
  my ($self, %p) = @_;

  # store all key=>value pairs given in the constructor in the object hash
  foreach my $key (%p) {
    $self->{$key} = $p{$key};
  }
}

# check that certain key=>value pairs were given in the constructor
# or _init() routine and belong in the $self hash reference
sub compulsoryParams {
  my ($self, @keys) = @_;
  my $bad = 0;
  foreach $key (@keys) {
    warn("Missing key=>value pair: $key\n") && $bad++ unless (defined $self->{$key});
  }
  die "Missing key=>value pairs in $self->{Class} constructor... exiting.\n" if ($bad);
}

# ensure that $self->{key} contains a defined or undefined (default) value
# (get/set autoload routine checks that $self->{key} exists)
sub optionalParams {
  my ($self, @keys) = @_;
  foreach $key (@keys) {
    $self->{$key} = undef unless (defined $self->{$key});
  }
}


sub DESTROY {
  my $self = shift;
}


# provide basic Get and Set routines using AUTOLOAD
#
# implicit Get if paramater exists:
# my $x = $obj->Xcoord;
# implicit Set if paramater exists, and you can chain them (returns $self)
# $obj->Xcoord(12.0)->Ycoord(3.5);
#
sub AUTOLOAD {
  my ($self, @args) = @_;

  my ($mystery) = $AUTOLOAD =~ /(\w+)$/i;

  if (exists $self->{$mystery}) {
    if (@args > 1) {
      # Set: multi-valued using array reference
      $self->{$mystery} = [ @args ];
    } elsif (@args) {
      # Set: single valued
      $self->{$mystery} = $args[0];
    } else {
      # Get: return value
      return $self->{$mystery};
    }
  } else {
    croak "unknown method/parameter $mystery accessed via AUTOLOAD for $self";
  }
  return $self;
}

1;
