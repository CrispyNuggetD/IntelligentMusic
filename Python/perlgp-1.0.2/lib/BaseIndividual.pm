package BaseIndividual;
#GPL#

use PerlGPObject;

@ISA = qw(PerlGPObject);

sub _init {
  my ($self, %p) = @_;

  my %defaults = ( );

  $self->SUPER::_init(%defaults, %p);

  $self->compulsoryParams(qw(ExperimentId Population));
}

# things to do before working with a new object
# (like load evolved subroutines in GP)
sub reInitialise {
  my $self = shift;
  return;
}

1;
