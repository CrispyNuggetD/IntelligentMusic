import numpy as np
from parameters import *

def plot():
	print ""
	from evaluate import song

	dataHeight = np.max(np.abs(song))

	totalBitsOfNote = len(song)
	normalisedData = np.float16(song/np.max(np.abs(song)))

	####Plottting sine wave####
	import matplotlib.pylab as plt
	x = np.arange(totalBitsOfNote)
	#plt.ion()
	if normalise == 1:
		plt.plot(x,normalisedData)
	else:
		plt.plot(x,song)
	if plotBars == 0:
		global plotBars
		plotBars = totalBitsOfNote
	plt.xlabel('Bit')
	plt.ylabel('Loudness')
	#plt.axis('tight')
	if toPlot == 1:
		print "Plotting sound wave..."
		if normalise == 1:
			print "Normalisation is on; Max amplitude is 1"
		if plotOffsetBars == 0:
			if normalise == 1:
				plt.axis([0,plotBars,-1,1])
			else:
				print "Max amplitude: " + str(dataHeight)
				plt.axis([0,plotBars,-dataHeight,dataHeight])
		else:
			if normalise == 1:
				if toPlotBefore == 1:
					plt.axis([smallOffsetDataPoint,bigOffsetDataPoint,-1,1])
				else:
					plt.axis([plotOffsetBars, bigOffsetDataPoint,-1,1])
			else:
				print "Max amplitude: " + str(dataHeight)
				if toPlotBefore == 1:
					plt.axis([smallOffsetDataPoint, bigOffsetDataPoint,-dataHeight,dataHeight])
				else:
					plt.axis([0, bigOffsetDataPoint,-dataHeight,dataHeight])

		print "Sound wave plotted!"
		plt.show()
	else:
		print "Soundwave not plotted. Set toPlot to 1 in parameters.py to plot"
	####Plottting sine wave####

	print ""
	return

	#normalisedData = np.float16(data/np.max(np.abs(data)))