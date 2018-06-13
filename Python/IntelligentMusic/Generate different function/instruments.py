from GenerateNote import *
from scales import *
from GenerateRandom import *

note1 = note("1")
note2 = note("E3")
note3 = note("G3")
note4 = note("C4")
note5 = note("C#3")
note6 = note("F3")
note7 = note("G#3")
note8 = note("C#4")
note9 = note("D3")
note10 = note("F#3")
note11 = note("A3")
note12 = note("D4")
note13 = note("D#3")
note14 = note("G3")
note15 = note("A#3")
note16 = note("D#4")

def instrument1():
	newInstrument()
	exec(randomNotes())
	#GenerateNote(32,note1, [note2,note3,note4])

	addInstrumentToSong()
	return

def instrument2():
	newInstrument()
	#GenerateNote(32,note5, [note6,note7,note8])
	#GenerateNote(32,note9, [note10,note11,note12])
	#GenerateNote(32,note13, [note14,note15,note16])

	addInstrumentToSong()
	return

##Make 3 times generate different instruments;
##Variable control currentBarGenerate
##Function GenerateNewNote


##have another python script generate the python script for instruments
##OR HOW: For GP is it generate in another python function??

#Pop sound after first note; need to program ADSR later

