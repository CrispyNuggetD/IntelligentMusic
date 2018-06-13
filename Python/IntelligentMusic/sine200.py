from __future__ import division

import numpy as np
from scipy.io.wavfile import write

maxLoud = 0.5 #loudness from 0 to 1 
##to be applied at the end as normalisation
##i.e. data / inverse of maxLoud exception for 0

data = []

def GenerateNote(freq):
	
	dataPoints = np.linspace(0, 44099, num=44100)/44100 
		#if bitsOfNote is 44100, from 0 to 44099, 44100 values
		#MUST BE SAME AS x FOR PLOTTING
	
	global data 
		#access current data
	data = np.append(data,(np.array(np.sin(dataPoints*(freq*(2*np.pi))))))
		#Append to current data
	
	####Plottting sine wave####
	import matplotlib.pylab as plt
	x = np.arange(44100)
	plt.plot(x,data)
	plt.xlabel('Bit')
	plt.ylabel('Loudness')
	#plt.axis('tight')
	plt.axis([0,44100,-1,1])
	plt.show()
	####Plottting sine wave####

	return


GenerateNote(200)
scaled = np.int16(data * 32767)
print scaled

write('sine200.wav', 44100, scaled)