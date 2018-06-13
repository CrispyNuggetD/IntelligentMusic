from __future__ import division
from itertools import chain
from pyknon.genmidi import Midi
from pyknon.music import Note, NoteSeq
from PIL import Image
import colorsys
import math
import sys

def nah_vomiting(vomit_limit):
	counter = 0
	while counter < vomit_limit:
		yield counter%3
		counter += 1

if len(sys.argv)>1:
	imagePath = sys.argv[1]
else:
	print("Supply a path as a argument.")
	sys.exit()
im = Image.open(imagePath)
im = im.resize((20,20))
im.save("output.png")
data = list(im.getdata())
all = []
seq = []
h = []
s = []
v = []
for i in data:
	print(i)
	c = colorsys.rgb_to_hsv(i[0]/255,i[1]/255,i[2]/255)
	#all.append(c)
	#h.append(int(c[0]*12))
	#s.append(int(c[1]*8)+1)
	#v.append(c[2])
	if c[2] > 0.5:
		s = 1/8
	else:
		s = 1/16
	seq.append( (int(c[0]*12),int(c[1]*8)+1,s))
	
#print all

#baseSeq = chain.from_iterable( nah_vomiting(len(seq)) )
#Note(note from 0-11, pitch(octave), length(in beat))
#midi.seq_notes(NoteSeq([Note(x%12, 4, 1/8) for x in seq]))

baseSeq = []
for i in range(int(len(seq)/4)):
	baseSeq.append([0,2,4,4][i%4])

print baseSeq

midi = Midi(number_tracks=2,tempo=90)
midi.seq_notes(NoteSeq([Note(x, 4, 1/4) for x in baseSeq]),track=0,time=4)
midi.seq_notes(NoteSeq([Note(x[0], x[1], 1/16) for x in seq]),track=1)
midi.write("output.mid")
#fluidsynth -T wav -F output.wav Piano.sf2
