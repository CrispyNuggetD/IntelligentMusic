from __future__ import division

import numpy as np
from scipy.io.wavfile import write

import os

maxLoud = 0.5 #loudness from 0 to 1 
##to be applied at the end as normalisation
##i.e. data / inverse of maxLoud exception for 0

bpm = 60

bitsPerBeat = 44100/(bpm/60)
	#3 beats per second
	#bps is bpm/60 
	#bitsPB is bitrate (44100) / bps
	#to obtain length (in fraction of 44100=1 second)

data = []

def GenerateNote(noteLength,freq,addfreq=[]):
	"This generates a note of freqency in Hz and times of 1/64 notes"

	bitsOfNote = ((noteLength/64)*bitsPerBeat)//1 
		#// by 1 so that bitsOfNote is an integer
		#(how much of a beat) then * bitsPB 
		####change note length to 32 later and generate 1 second
	
	dataPoints = np.arange(0,bitsOfNote)/44100 
		#if bitsOfNote is 44100, from 0 to 44099, 44100 values
		#e.g. bitsOfNote is 22050, at the end, datapoint = (2pi)/2 (half time wave)
		#MUST BE SAME AS x FOR PLOTTING
	
	global data 
		#access current data
	data = np.append(data,(np.array(np.sin(dataPoints*(freq*(2*np.pi))))))
		#Append to current data

	####Additional Frequencies####
	
	for addfreq in addfreq:
		adddata = np.array(np.sin(dataPoints*(addfreq*(2*np.pi))))
		data = [x + y for x, y in zip(adddata, data)]
			#add frequencies
		data = np.float16(data/np.max(np.abs(data)))
			#normalise new wave
	####Additional Frequencies####

	####Plottting sine wave####
	import matplotlib.pylab as plt
	x = np.arange(bitsOfNote)
	plt.plot(x,data)
	plt.xlabel('Bit')
	plt.ylabel('Loudness')
	#plt.axis('tight')
	plt.axis([0,441,-1,1])
	plt.show()
	####Plottting sine wave####

	return


GenerateNote(64,2000,[500,50,1000])
scaled = np.int16(data * 32767)
print scaled

####Increment output wav number####
outputFileName = "Superposition #.wav"
outputVersion = 1
while os.path.isfile(outputFileName.replace("#", str(outputVersion))):
	outputVersion += 1
outputFileName = outputFileName.replace("#", str(outputVersion))
####Increment output wav number####

write(outputFileName, 44100, scaled)