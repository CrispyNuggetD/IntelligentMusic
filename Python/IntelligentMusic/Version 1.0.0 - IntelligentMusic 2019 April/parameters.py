from __future__ import division

####Set Variables Here####
bpm = 60

#plotting
toPlot = 1 #1 to plot; 0 to not plot
plotBars = 0 #0 for one wave. 0 and len(song) in totalBitsOfNotes for total song length. Divide by bitrate to plot specific bits. Divide by frequency to plot specific waves.
plotOffsetBars = 0
toPlotBefore = 0 #1 to plot plotBars BEFORE the plotOffsetBars, 0 for only AFTER
normalise = 1 #1 to normalise; 0 to retain original amplitude

#exporting
toExport = 1 #1 to export; 0 to not export
outputFileName = "Export/Sample"

maxLoud = 0.5 #loudness from 0 to 1 
##to be applied at the end as normalisation i.e. data * maxLoud 
####Variables####





####Calculations####
#data = []
song = []
bitsPerBeat = 44100/(bpm/60)
	#3 beats per second
	#bps is bpm/60 
	#bitsPB is bitrate (44100) / bps
	#to obtain length (in fraction of 44100=1 second)
plotBars = plotBars * bitsPerBeat
plotOffsetBars = plotOffsetBars * bitsPerBeat
bigOffsetDataPoint = plotOffsetBars+plotBars
smallOffsetDataPoint = plotOffsetBars-plotBars
####Calculations####