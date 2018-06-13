#*waveforms (arrays)
#for wave in waveforms

from __future__ import division
import numpy as np
import itertools
from scipy import signal

from parameters import *


def newInstrument():
	global data
	data = []

	return

def GenerateNote(noteLength,freq,addfreq=[]):
	"This generates a note of frequency in Hz and times of 1/64 notes"
	print ""

	bitsOfNote = ((noteLength/64)*bitsPerBeat)//1 
		#// by 1 so that bitsOfNote is an integer
		#(how much of a beat) then * bitsPB 
		####change note length to 32 later and generate 1 second
	
	dataPoints = np.arange(0,bitsOfNote)/44100 
		#if bitsOfNote is 44100, from 0 to 44099, 44100 values
		#e.g. bitsOfNote is 22050, at the end, datapoint = (2pi)/2 (half time wave)
	
	print "Generating base melody (" + str(freq) + "Hz)..."
	global data 
		#access current data
	print "Current bits: " + str(len(data))
		#show bits of current data

	localData = np.sin(dataPoints*(freq*(2*np.pi)))
		#make array; DO NOT Append to current data

	'''
	localData = signal.square(dataPoints*(freq*(2*np.pi)))
		#square

	localData = signal.sawtooth(dataPoints*(freq*(2*np.pi)))
		#sawtooth

	localData = signal.sawtooth(dataPoints*(freq*(2*np.pi)),0.5)
		#triangle

	localData = np.sin(dataPoints*(freq*(2*np.pi)))
		#sine

	'''


	####Additional Frequencies####
	freqNo = 1
	for addfreq in addfreq:
		print "Combining with additional frequency " + str(freqNo) + " (" + str(addfreq) + " Hz)..."
		adddata = np.array(np.sin(dataPoints*(addfreq*(2*np.pi))))
			#adddata to not overwrite original data
		localData = [x + y for x, y in zip(adddata, localData)]
			#add frequencies and append to original data
		freqNo += 1
	data = np.append(data, localData)
		#add to original data
	print "Completed bits after generation: " + str(len(data))
	####Additional Frequencies####
	
	print ""
	return

def addInstrumentToSong():
	global song
	song = [x + y for x, y in list(itertools.izip_longest(song, data, fillvalue=0))]
	
	global totalBitsOfNote
	totalBitsOfNote = len(song)
		#MUST BE SAME AS x FOR PLOTTING
	return