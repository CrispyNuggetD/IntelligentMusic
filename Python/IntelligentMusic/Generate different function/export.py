from scipy.io.wavfile import write
import os
import numpy as np

from parameters import toExport, outputFileName

####Increment output wav number####
outputFileName = outputFileName + " #.wav"
outputVersion = 1
while os.path.isfile(outputFileName.replace("#", str(outputVersion))):
	outputVersion += 1
outputFileName = outputFileName.replace("#", str(outputVersion))
####Increment output wav number####

def export():
	print ""

	from GenerateNote import song
	global normalisedData
	normalisedData = np.float16(song/np.max(np.abs(song)))
		#normalise new wave
	scaled = np.int16(normalisedData * 32767)
	
	if toExport == 1:
	#Check if user wants to export
		print "Exporting .wav file..."
		write(outputFileName, 44100, scaled)
	
		print "Exported .wav file as " + outputFileName + "!"
	else:
		print ".wav file not exported. Set toExport to 1 in parameters.py to export"

	print ""
	return