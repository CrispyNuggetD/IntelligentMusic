package BaseAlgorithm;
#GPL#

use PerlGPObject;

@ISA = qw(PerlGPObject);

sub _init {
  my ($self, %p) = @_;
  my %defaults = ();
  $self->SUPER::_init(%defaults, %p);
}

sub run {
  my ($self, %p) = @_;

  die "you must implement a Algorithm::run() method\n";
}


1;
