#dataPoints is an array from 1 to how many bits there are for the note length. Previously in generate note datapoint is used; now the datapoint need to be changed to noteData[0]

from __future__ import division
import numpy as np
import itertools
from scipy import signal

from parameters import *
from scales import *


#*waveforms (arrays)
#for wave in waveforms

'''
def newInstrument():
	global data
	data = []

	return
'''

def GenerateNote(freqComponents,noteData):
	"This generates a note of frequency in Hz and times of 1/64 notes"
	print ""

	#noteData[0] is length; [1] is note freq
	
	#global data 
		##access current data

	data = []

	print "Current bits: " + str(len(data)) + " (" + str(len(data)/44100) + " bars)"
		#show bits of current data
	
	for noteData in noteData:
		localData = "" 
		#initialise localData

		bitsOfNote = ((noteData[0]/64)*bitsPerBeat)//1 
		#// by 1 so that bitsOfNote is an integer
		#(how much of a beat) then * bitsPB 
		####change note length to 32 later and generate 1 second
	
		for multipleNotes in noteData[1]:
			print "Generating melody (" + str(multipleNotes) + "Hz) " + "(length: " + str(noteData[0]) + ")..."
			
			freqRatio = multipleNotes/freqComponents[0][0]
			
			for waveform in freqComponents:
				finalFreq = freqRatio*waveform[0]
		
				print "		Generating waveform (" + str(waveform[1]) + ", " + str(finalFreq) + "Hz, " + str(waveform[2]) + u"\u00b0" +" Phaseshift)..."
			
				####dataPoints
				if finalFreq == 0:
					phaseshift = 0
				else:
					phaseshift = (waveform[2]/360*(44100/finalFreq))//1
						#Convert to fraction of waveform and calculate number of bits to offset dataPoints
				
				dataPoints = np.arange(0 + phaseshift, bitsOfNote + phaseshift)
					#i.e. how much of the waveform to generate; array of what point of wave to generate
					#if bitsOfNote is 44100, from 0 to 44099, 44100 values
					#e.g. bitsOfNote is 22050, at the end, datapoint = 0.5				#divided by 44100 so sampling rate is preserved; 44100 values
			
				dataPoints = dataPoints/44100 
					#bit of waveform to generate 

				dataPoints = dataPoints*(2*np.pi)
					#e.g. end dataPoint is 0.5, dataPoint will be (2pi)/2 (half wave)
				####dataPoints
	
				vol = waveform[3]
					#volume
	
				if waveform[1] == "sine":
				#addData refers to additional data
					addData = vol*np.sin(dataPoints*finalFreq)
					#make array; DO NOT Append to current data
					#adddata to not overwrite original data
				elif waveform[1] == "square":
					addData = vol*signal.square(dataPoints*finalFreq)
					#square
				elif waveform[1] == "sawtooth":
					addData = vol*signal.sawtooth(dataPoints*finalFreq)
					#sawtooth
				elif waveform[1] == "triangle":
					addData = vol*signal.sawtooth((dataPoints*finalFreq),0.5)
					#triangle
				if localData == "":
					localData = addData
				else:
					localData = [x + y for x, y in zip(addData, localData)]
					#add frequencies and append to original (the note/ chord) data

		data = np.append(data, localData)
			#add to original (the song) data
		print "Completed bits after generation: " + str(len(data)) + " (" + str(len(data)/44100) + " bars)"


		print ""

	global song
	song = [x + y for x, y in list(itertools.izip_longest(song, data, fillvalue=0))]

	return



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
	####Additional Frequencies####
	
	'''

	
'''
def addInstrumentToSong():
	global song
	song = [x + y for x, y in list(itertools.izip_longest(song, data, fillvalue=0))]
	
	global totalBitsOfNote
	totalBitsOfNote = len(song)
		#MUST BE SAME AS x FOR PLOTTING
	return
'''