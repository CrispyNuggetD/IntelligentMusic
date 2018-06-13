package BasePopulation;
#GPL#

use PerlGPObject;

@ISA = qw(PerlGPObject);

my %usedfilestems;

sub _init {
  my ($self, %p) = @_;

  my %defaults = ( PopulationSize => 2000,
		   Individuals => [ ],
		 );

  $self->SUPER::_init(%defaults, %p);

  $self->compulsoryParams(qw(ExperimentId));
}

sub countIndividuals {
  my $self = shift;
  return scalar @{$self->{Individuals}};
}

sub addIndividual {
  my ($self, $indiv) = @_;
  push @{$self->{Individuals}}, $indiv;
}


sub randomIndividual {
  my $self = shift;
  return $self->{Individuals}->[int rand @{$self->{Individuals}}];
}

sub selectCohort {
  my ($self, $size) = @_;
  my (%seen, @cohort);
  my $psize = $self->countIndividuals();
  while (keys %seen < $size && keys %seen < $psize) {
    my $ind = $self->randomIndividual();
    push @cohort, $ind unless ($seen{$ind}++); # make sure no duplicates
  }
  return @cohort;
}


1;
