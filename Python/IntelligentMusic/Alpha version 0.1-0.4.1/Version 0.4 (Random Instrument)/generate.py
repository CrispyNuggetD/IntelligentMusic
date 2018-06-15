from scales import *
import numpy as np

def randomInstrument(number=5):
	"This generates an instrument of (number) waveforms"
	
	print "Generating a random instrument with " + str(number) + " waveforms..."
	print ""

	nowNumber = 1
	global randomInstruments
	randomInstruments = [] 
	while nowNumber <= number:
		currentWave = np.random.random_integers(19980) + 20

		waveType = np.random.random_integers(4)
		if waveType == 1:
			waveType = "sine"
		elif waveType == 2:
			waveType = "square"
		elif waveType == 3:
			waveType = "sawtooth"
		elif waveType == 4:
			waveType = "triangle"

		phaseshift = np.random.random_integers(360) - 1

		volume = np.random.uniform()

		if nowNumber == 1:
			print ("1st random waveform is: " + str(currentWave) 
+ "Hz, " + waveType + ", Volume = " + str(volume))
		elif nowNumber == 2:
			print ("2nd random waveform is: " + str(currentWave)
+ "Hz, " + waveType + ", Volume = " + str(volume))
		elif nowNumber == 3:
			print ("3rd random waveform is: " + str(currentWave)
+ "Hz, " + waveType + ", Volume = " + str(volume))
		else:
			print (str(nowNumber) + "th random note is: " + str(currentWave)
+ "Hz, " + waveType + ", Volume = " + str(volume))
		nowNumber += 1

		randomInstruments = randomInstruments + [[currentWave,waveType,phaseshift,volume]]
	print ""
	print randomInstruments
	return randomInstruments
	

def randomNotes(length=16,number=8,addfreq=[],
volume=1,attack=0,delay=0,release=0,clipping=0):
	#threshold for RNG, e.g. 0.6 (define in parameters)

	#include write to python file later
	#in writing, define "overwriteGeneratedRandomNotes = 1 or 0"
	#in accessing, use "largest file number" to detect which file to open

	#randomNotes = "test"
	#randomNotes = randomNotes + "\ntest again"
	#print randomNotes

	#Need to change GenerateNotes function later to include other variables

	print "Generating " + str(number) + " random notes..."
	print "Note 0 is C0, Note 108 is B8"
	print ""

	nowNumber = 1
	global randomNotes
	randomNotes = [] 
	while nowNumber <= number:
		currentNote = np.random.random_integers(108)
		
		if nowNumber == 1:
			print "1st random note is: " + str(currentNote)
		elif nowNumber == 2:
			print "2nd random note is: " + str(currentNote)
		elif nowNumber == 3:
			print "3rd random note is: " + str(currentNote)
		else:
			print str(nowNumber) + "th random note is: " + str(currentNote)
		nowNumber += 1

		randomNotes = randomNotes + [[length, currentNote]]
	print ""
	print randomNotes
	return randomNotes

'''
####BELOW TO GENERATE RANDOM NOTES AS IN VERSION 0.1 NEED TO CHANGE randomNotes to string
#randomNotes = (randomNotes + "GenerateNote(" +
str(length) + ',note("' + str(currentNote) + '"))\n')
'''