from __future__ import division
from itertools import chain
from pyknon.genmidi import Midi
from pyknon.music import Note, NoteSeq
from PIL import Image
import colorsys
import math
import sys

if len(sys.argv)>1:
	imagePath = sys.argv[1]
else:
	print("Supply a path as a argument.")
	sys.exit()
im = Image.open(imagePath)
im = im.resize((10,10))
im.save("output.png")
data = list(im.getdata())
all = []
seq = [0,3,4,2,5,7,8,3,5,4,3,1,6,4,2,4,0,3,4,2,5,7,8,3,5,4,3,1,6,4,2,4,2,3,4,3,5,4,3,1,6,4,3,1,6,4,2,4,2,3,4,2,5,7,8,3,5,4,3,1,6,4,2,4]
h = []
s = []
v = []

#print all
baseSeq = [0,0,4,7,0,0,4,7,4,4,7,11,4,4,7,11]
	
#seq = chain.from_iterable(data)
midi = Midi(number_tracks=2,tempo=120)
#Note(note from 0-11, pitch(octave), length(in beat))
#midi.seq_notes(NoteSeq([Note(x%12, 4, 1/8) for x in seq]))
midi.seq_notes(NoteSeq([Note(x, 4, 1/4) for x in baseSeq]),track=0)
midi.seq_notes(NoteSeq([Note(x, 6, 1/16) for x in seq]),track=1)
midi.write("output.mid")
#fluidsynth -T wav -F output.wav Piano.sf2
