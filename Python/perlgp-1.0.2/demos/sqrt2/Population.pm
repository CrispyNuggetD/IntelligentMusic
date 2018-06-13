package Population;

use GPPopulation;

# the PerlGP library is distributed under the GNU General Public License
# all software based on it must also be distributed under the same terms

@ISA = qw(GPPopulation);

sub _init {
  my ($self, %p) = @_;

  my %defaults = ( PopulationSize => 2000,
		 );

  $self->SUPER::_init(%defaults, %p);
}




1;
