# This script will extract all tones before pause annotation
# Input: .textgrid file with a tone tier (which is point tier) and word tier (specified by the user)
# Output: .txt file containing: filename, word, tone(s)
#		Multiple tones for one word is separated by a space


# Created by Romi Hill 14.08.2022 for Benazir Mumtaz

# choose directory to process
dir$ = chooseDirectory$: "Choose a directory"

# ask for user input, including selected phoneme, directory, tiers, and output path.
form Calculate F0 of tone segment with its syllable
	comment What is the name of the syllable tier?
	text syllableTierName Syllable
	comment Which tier is the tone tier (integer)
	integer toneTier 6
	comment Where do you want to save the results?
	text textfile f0_frequencies.txt
endform

# header of output file
firstLine$ = "filename'tab$'tone'tab$'syllable'tab$'f0'tab$''newline$'"
filedelete 'textfile$'
fileappend 'textfile$' 'firstLine$'

# read files
Create Strings as file list... gridList 'dir$'/*.TextGrid
Create Strings as file list... wavList 'dir$'/*.wav

# loop through all the files
nFiles = Get number of strings

for iFile from 1 to nFiles
	
    # open textgrid file
    select Strings gridList
    fName$ = Get string... iFile
    textGridFile = Read from file... 'dir$'/'fName$'
	textGridObject$ = selected$("TextGrid")

	# get syllable tier
	nTiers = Get number of tiers
	syllableTier = -1
	wordTier = -1
	for tier to nTiers
		tierName$ = Get tier name: tier
		if tierName$ = syllableTierName$
			syllableTier = tier
		endif
	endfor
	
	if syllableTier = -1
		exitScript: "Tier name" + syllableTierName$ + " does not exist in " + fName$
	endif

	# Open wav file
	select Strings wavList
	wavName$ = Get string... iFile
	wavFile = Read from file... 'dir$'/'wavName$'
	wavObject$ = selected$("Sound")

	select TextGrid 'textGridObject$'
	# number of points in point tier
	numberOfPoints = Get number of points: toneTier

	# check all intervals in segment tier
	writeInfoLine: ""
	for iPoint from 1 to numberOfPoints
		select TextGrid 'textGridObject$'

		# time of current point
		time = Get time of point: toneTier, iPoint
		# label of current point
		toneLabel$ = Get label of point: toneTier, iPoint
		appendInfoLine: toneLabel$
		
		# label of syllable at time
		syllableInterval = Get interval at time... syllableTier time
		syllableLabel$ = Get label of interval... syllableTier syllableInterval

		# F0 label
		select Sound 'wavObject$'
		To Pitch... 0.01 75 600
		select Pitch 'wavObject$'
		f_zero = Get value at time... 'time' Hertz Linear
		# append to output file
		resultline$ = "'fName$''tab$''toneLabel$''tab$''syllableLabel$''tab$''f_zero''newline$'"
		fileappend "'textfile$'" 'resultline$'
		select Pitch 'wavObject$'
		Remove

	endfor

	# remove files as objects
	select textGridFile
	Remove
	select wavFile
	Remove

endfor

# remove list of filenames
select Strings wavList
Remove
select Strings gridList
Remove
