def note(note="C4"):
	print "Generating note frequencies..."
	if note in ("C0", "1"):
		freq = 16.3516
	elif note in ("C#0", "Db0", "2"):
		freq = 17.3239
	elif note in ("D0", "3"):
		freq = 18.3540
	elif note in ("D#0", "Eb0", "4"):
		freq = 19.4454
	elif note in ("E0", "5"):
		freq = 20.6017
	elif note in ("F0", "6"):
		freq = 21.8268
	elif note in ("F#0", "Gb0", "7"):
		freq = 23.1247
	elif note in ("G0", "8"):
		freq = 24.4997
	elif note in ("G#0", "Ab0", "9"):
		freq = 25.9565
	elif note in ("A0", "10"):
		freq = 27.5000
	elif note in ("A#0", "Bb0", "11"):
		freq = 29.1352
	elif note in ("B0", "12"):
		freq = 30.8677
	elif note in ("C1", "13"):
		freq = 32.7032
	elif note in ("C#1", "Db1", "14"):
		freq = 34.6478
	elif note in ("D1", "15"):
		freq = 36.7081
	elif note in ("D#1", "Eb1", "16"):
		freq = 38.8909
	elif note in ("E1", "17"):
		freq = 41.2034
	elif note in ("F1", "18"):
		freq = 43.6535
	elif note in ("F#1", "Gb1", "19"):
		freq = 46.2493
	elif note in ("G1", "20"):
		freq = 48.9994
	elif note in ("G#1", "Ab1", "21"):
		freq = 51.9131
	elif note in ("A1", "22"):
		freq = 55.0000
	elif note in ("A#1", "Bb1", "23"):
		freq = 58.2705
	elif note in ("B1", "24"):
		freq = 61.7354
	elif note in ("C2", "25"):
		freq = 65.4064
	elif note in ("C#2", "Db2", "26"):
		freq = 69.2957
	elif note in ("D2", "27"):
		freq = 73.4162
	elif note in ("D#2", "Eb2", "28"):
		freq = 77.7817
	elif note in ("E2", "29"):
		freq = 82.4069
	elif note in ("F2", "30"):
		freq = 87.3071
	elif note in ("F#2", "Gb2", "31"):
		freq = 92.4986
	elif note in ("G2", "32"):
		freq = 97.9989
	elif note in ("G#2", "Ab2", "33"):
		freq = 103.826
	elif note in ("A2", "34"):
		freq = 110.000
	elif note in ("A#2", "Bb2", "35"):
		freq = 116.541
	elif note in ("B2", "36"):
		freq = 123.471
	elif note in ("C3", "37"):
		freq = 130.813
	elif note in ("C#3", "Db3", "38"):
		freq = 138.591
	elif note in ("D3", "39"):
		freq = 146.832
	elif note in ("D#3", "Eb3", "40"):
		freq = 155.563
	elif note in ("E3", "41"):
		freq = 164.814
	elif note in ("F3", "42"):
		freq = 174.614
	elif note in ("F#3", "Gb3", "43"):
		freq = 184.997	
	elif note in ("G3", "44"):
		freq = 195.998
	elif note in ("G#3", "Ab3", "45"):
		freq = 207.652
	elif note in ("A3", "46"):
		freq = 220.000	
	elif note in ("A#3", "Bb3", "47"):
		freq = 233.082
	elif note in ("B3", "48"):
		freq = 246.942
	elif note in ("C4", "49"):
		freq = 261.626
	elif note in ("C#4", "Db4", "50"):
		freq = 277.183
	elif note in ("D4", "51"):
		freq = 293.665	
	elif note in ("D#4", "Eb4", "52"):
		freq = 311.127
	elif note in ("E4", "53"):
		freq = 329.628
	elif note in ("F4", "54"):
		freq = 349.228	
	elif note in ("F#4", "Gb4", "55"):
		freq = 369.994
	elif note in ("G4", "56"):
		freq = 391.995
	elif note in ("G#4", "Ab4", "57"):
		freq = 415.305
	elif note in ("A4", "58"):
		freq = 440.000
	elif note in ("A#4", "Bb4", "59"):
		freq = 466.164
	elif note in ("B4", "60"):
		freq = 493.883
	elif note in ("C5", "61"):
		freq = 523.251
	elif note in ("C#5", "Db5", "62"):
		freq = 554.365
	elif note in ("D5", "63"):
		freq = 587.330
	elif note in ("D#5", "Eb5", "64"):
		freq = 622.254
	elif note in ("E5", "65"):
		freq = 659.255
	elif note in ("F5", "66"):
		freq = 698.456	
	elif note in ("F#5", "Gb5", "67"):
		freq = 739.989
	elif note in ("G5", "68"):
		freq = 783.991	
	elif note in ("G#5", "Ab5", "69"):
		freq = 830.609
	elif note in ("A5", "70"):
		freq = 880.000
	elif note in ("A#5", "Bb5", "71"):
		freq = 932.328
	elif note in ("B5", "72"):
		freq = 987.767
	elif note in ("C6", "73"):
		freq = 1046.50
	elif note in ("C#6", "Db6", "74"):
		freq = 1108.73
	elif note in ("D6", "75"):
		freq = 1174.66
	elif note in ("D#6", "Eb6", "76"):
		freq = 1244.51
	elif note in ("E6", "77"):
		freq = 1318.51
	elif note in ("F6", "78"):
		freq = 1396.91
	elif note in ("F#6", "Gb6", "79"):
		freq = 1479.98
	elif note in ("G6", "80"):
		freq = 1567.98
	elif note in ("G#6", "Ab6", "81"):
		freq = 1661.22
	elif note in ("A6", "82"):
		freq = 1760.00
	elif note in ("A#6", "Bb6", "83"):
		freq = 1864.66
	elif note in ("B6", "84"):
		freq = 1975.53
	elif note in ("C7", "85"):
		freq = 2093.00
	elif note in ("C#7", "Db7", "86"):
		freq = 2217.46
	elif note in ("D7", "87"):
		freq = 2349.32
	elif note in ("D#7", "Eb7", "88"):
		freq = 2489.02
	elif note in ("E7", "89"):
		freq = 2637.02
	elif note in ("F7", "90"):
		freq = 2793.83
	elif note in ("F#7", "Gb7", "91"):
		freq = 2959.96
	elif note in ("G7", "92"):
		freq = 3135.96
	elif note in ("G#7", "Ab7", "93"):
		freq = 3322.44
	elif note in ("A7", "94"):
		freq = 3520.00
	elif note in ("A#7", "Bb7", "95"):
		freq = 3729.31
	elif note in ("B7", "96"):
		freq = 3951.07
	elif note in ("C8", "97"):
		freq = 4186.01
	elif note in ("C#8", "Db8", "98"):
		freq = 4434.92	
	elif note in ("D8", "99"):
		freq = 4698.64
	elif note in ("D#8", "Eb8", "100"):
		freq = 4978.03
	elif note in ("E8", "101"):
		freq = 5274.04
	elif note in ("F8", "102"):
		freq = 5587.65
	elif note in ("F#8", "Gb8", "103"):
		freq = 5919.92
	elif note in ("G8", "104"):
		freq = 6271.92
	elif note in ("G#8", "Ab8", "105"):
		freq = 6644.88
	elif note in ("A8", "106"):
		freq = 7040.00
	elif note in ("A#8", "Bb8", "107"):
		freq = 7458.62
	elif note in ("B8", "108"):
		freq = 7902.14
	else:
		print "Specified Frequency Error: Does not exist"
		print "Specified note is: " + note
		quit()

	return freq