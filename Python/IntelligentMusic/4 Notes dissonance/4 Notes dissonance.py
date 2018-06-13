from scales import *
from GenerateNote import *
from write import *
from plot import *


note1 = note("C3")
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

##Make note import into array later and change Generate note to accept array only; use *argv or something


GenerateNote(16,note1, [200,note3,note4,400])
GenerateNote(16,note5, [211.8654434251,note7,note8,423.7308868502])
GenerateNote(16,note9, [224.4348305885,note11,note12,448.8696611771])
GenerateNote(16,note13, [237.7499245133,note15,note16,475.4998490268])

#Pop sound after first note; need to program ADSR later

export()

plot()
