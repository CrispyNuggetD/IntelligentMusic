from scales import *
from GenerateNote import *
from write import *
from plot import *


note1 = note("C3")
note2 = note("E3")
note3 = note("G3")
note4 = note("C4")
note5 = note("D3")
note6 = note("F#3")
note7 = note("A3")
note8 = note("D4")

##Make note import into array later and change Generate note to accept array only; use *argv or something


GenerateNote(64,note1, [note2,note3,note4])
GenerateNote(64,note1, [note2,note3,note4])
#Pop sound after first note; need to program ADSR later

export()

plot()
