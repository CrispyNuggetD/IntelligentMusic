package SupervisedLearning;
#GPL#

use BaseAlgorithm;

@ISA = qw(BaseAlgorithm);

sub _init {
  my ($self, %p) = @_;

  my %defaults = ( );

  $self->SUPER::_init(%defaults, %p);

  $self->compulsoryParams(qw(TrainingSet TestingSet)); # files or directories
  $self->optionalParams(qw(TrainingData TestingData)); # data structures
}


# load up the data sets (when needed)
# $self->T*ingData is just a (scalar ref to a) data structure
sub loadData {
  my ($self) = @_;

  $self->TrainingData($self->loadSet($self->TrainingSet));
  $self->TestingData($self->loadSet($self->TestingSet));
}

sub loadSet {
  my ($self, $fileordir) = @_;

  die "you must implement the Algorithm::loadSet() method\n";
}

sub fitnessFunction {
  my ($self, %p) = @_;

  die "you must implement the Algorithm::fitnessFunction() method\n";
}

sub saveOutput {
  my ($self, %p) = @_;

  die "you must implement the Algorithm::saveOutput() method\n";
}

1;
