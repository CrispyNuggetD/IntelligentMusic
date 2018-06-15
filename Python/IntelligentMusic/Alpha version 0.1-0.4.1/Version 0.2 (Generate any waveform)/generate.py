from scales import *
import numpy as np

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