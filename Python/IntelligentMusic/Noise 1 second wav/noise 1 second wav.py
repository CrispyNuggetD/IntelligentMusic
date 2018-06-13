import numpy as np
from scipy.io.wavfile import write

data = np.random.uniform(-1,1,44100) # 44100 random samples between -1 and 1 (2 now)
print data
scaled = np.int16(data/np.max(np.abs(data)) * 32767)
print np.abs(data)
print np.max(np.abs(data))
print data/np.max(np.abs(data))
print scaled

write('test.wav', 44100, scaled)