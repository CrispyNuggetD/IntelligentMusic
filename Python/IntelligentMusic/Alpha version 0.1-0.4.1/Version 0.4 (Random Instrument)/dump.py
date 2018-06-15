'''
import numpy as np
data = np.array([1, 2, 3])
print data
'''

'''
import numpy as np
data2 = np.linspace(0, 2, num=3) #from 0 to 2, 3 values
print data2
'''

'''
import numpy as np
data = [2,3,4]
data = np.append(data,np.array([1,2,3]))
print data
'''

'''
import numpy as np
data = np.arange(1,3)
print data
'''

use PDL::Audio;
use PDL::Audio::Scales;

sub osc {
   my ($dur,$freq) = @_;
   (gen_asymmetric_fm $dur, $freq, 0.9, 0.6)*
   (gen_env $dur, [0, 1, 2, 9, 10], [0, 1, 0.6, 0.3, 0]);
}

for (scale_list) {
   my ($scale, $desc) = get_scale($_);
   my @mix;
   my $i;
   print "$_ [$desc] $scale\n";
   my $l = $scale->list;
   for (($scale*880)->list) {
       push @mix, ($i*0.2*44100    , osc 0.3*44100, $_/44100);
       push @mix, ($l*0.2*44100+0.1, osc 0.8*44100, $_/44100);
       $i++;
   }
   (audiomix @mix)->scale2short->playaudio;
}