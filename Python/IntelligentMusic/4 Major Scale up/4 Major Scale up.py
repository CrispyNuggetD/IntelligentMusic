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


GenerateNote(16,note1, [note2,note3,note4])
GenerateNote(16,note5, [note6,note7,note8])
GenerateNote(16,note9, [note10,note11,note12])
GenerateNote(16,note13, [note14,note15,note16])

#Pop sound after first note; need to program ADSR later

export()

plot()
