from evaluate import *
from scales import *
from generate import *

'''
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
'''

#freq,wavetype,phaseshift,volume

instrumentSine = [[note("C4"),"sine",0,1]]
instrumentSquare = [[note("C4"),"square",0,1]]
instrumentSawtooth = [[note("C4"),"sawtooth",0,1]]
instrumentTriangle = [[note("C4"),"triangle",0,1]]

ipiano = ([[note("C4"),"sine",0,0.7],[2*note("C4"),"sine",0,0.1],[3*note("C4"),"sine",0,0.025],
[4*note("C4"),"sine",0,0.05],[5*note("C4"),"sine",0,0.08],[6*note("C4"),"sine",0,0.08],
[7*note("C4"),"sine",0,015]])

instrumentA = [[note("20"),"sine",0,1],[note("40"),"square",0,0.05],[270,"triangle",0,0.1]]

instrumentB = [[note("C4"),"sine",0,1],[note("C5"),"sine",0,0.5]]

instrumentC = [[16091, 'sine', 297, 0.39617561117064704], [5094, 'sawtooth', 0, 0.7905015632160612], [6045, 'triangle', 287, 0.7768707019823357], [14138, 'triangle', 343, 0.3881716046425887], [168, 'triangle', 3, 0.5526042011050525]]


'''
,[8*note("C4"),"sine",0,1],[9*note("C4"),"sine",0,1],
[10*note("C4"),"sine",0,1],[11*note("C4"),"sine",0,1],[12*note("C4"),"sine",0,1],
[13*note("C4"),"sine",0,1],[14*note("C4"),"sine",0,1],[15*note("C4"),"sine",0,1],
[16*note("C4"),"sine",0,1],[17*note("C4"),"sine",0,1],[18*note("C4"),"sine",0,1],
[19*note("C4"),"sine",0,1],[20*note("C4"),"sine",0,1],[21*note("C4"),"sine",0,1],
[22*note("C4"),"sine",0,1],[23*note("C4"),"sine",0,1],[24*note("C4"),"sine",0,1],
[25*note("C4"),"sine",0,1],[26*note("C4"),"sine",0,1],[27*note("C4"),"sine",0,1],
[28*note("C4"),"sine",0,1],[29*note("C4"),"sine",0,1],[30*note("C4"),"sine",0,1],
[31*note("C4"),"sine",0,1],[32*note("C4"),"sine",0,1],[33*note("C4"),"sine",0,1],
[34*note("C4"),"sine",0,1],[35*note("C4"),"sine",0,1],[36*note("C4"),"sine",0,1],
[37*note("C4"),"sine",0,1],[38*note("C4"),"sine",0,1],[39*note("C4"),"sine",0,1],
[40*note("C4"),"sine",0,1]
'''
'''
def instrument1():
	#newInstrument()
	#exec(randomNotes()) #randomNotes() need to return a string
	#GenerateNote(32,note1, [note2,note3,note4])
	
	#addInstrumentToSong()
	
	freqComponents = [[note("C4"),"sine"],[300,"square"]]
	##Add volume of each component later
	print freqComponents
	return freqComponents
'''

def instrument2():
	newInstrument()
	#GenerateNote(32,note5, [note6,note7,note8])
	#GenerateNote(32,note9, [note10,note11,note12])
	#GenerateNote(32,note13, [note14,note15,note16])

	addInstrumentToSong()
	return

##Make 3 times generate different instruments;
##Variable control currentBarGenerate (if needed)
##Function GenerateNewNote


##have another python script generate the python script for instruments
##OR HOW: For GP is it generate in another python function??

#Pop sound after first note; need to program ADSR later

