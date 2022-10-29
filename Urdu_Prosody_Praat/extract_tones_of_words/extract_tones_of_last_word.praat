# This script will extract all tones of a word/syllable
# Input: .textgrid file with a tone tier (which is point tier) and word tier (specified by the user)
# Output: .txt file containing: filename, word, tone(s)
#		Multiple tones for one word is separated by a space


# Created by Romi Hill 14.08.2022 for Benazir Mumtaz

# choose directory to process
dir$ = chooseDirectory$: "Choose a directory"

# ask for user input, including selected phoneme, directory, tiers, and output path.
form Extract all tones from interval
	comment What is the name of the word/syllable tier?
	text segmentTierName Word
	comment Which tier is the tone tier (integer)
	integer toneTier 6
	comment Where do you want to save the results?
	text textfile word_tones.txt
endform

# header of output file
firstLine$ = "filename'tab$''segmentTierName$''tab$'tone'newline$'"
filedelete 'textfile$'
fileappend 'textfile$' 'firstLine$'

# read files
Create Strings as file list... gridList 'dir$'/*.TextGrid

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
	segmentTier = -1
	wordTier = -1
	for tier to nTiers
		tierName$ = Get tier name: tier
		if tierName$ = segmentTierName$
			segmentTier = tier
		endif
	endfor
	
	if segmentTier = -1
		exitScript: "Tier name" + segmentTierName$ + " does not exist in " + fName$
	endif

	select TextGrid 'textGridObject$'
	# number of points in point tier
	numberOfPoints = Get number of points: toneTier
	# number of intervals in segment tier
	numberOfIntervals = Get number of intervals... segmentTier
	
	# check all intervals in segment tier
	#for intervalIndex from 1 to numberOfIntervals
	#	appendInfoLine: intervalIndex
		
	#endfor 


	toneLabel$ = ""
	prevSegmentLabel$ = "None"
	for iPoint from 1 to numberOfPoints

		# time of current point
		time = Get time of point: toneTier, iPoint
				
		# label of word/syllable at time
		segmentInterval = Get interval at time... segmentTier time
		segmentLabel$ = Get label of interval... segmentTier segmentInterval

		# take previous segment if segment is SIL or PAU
		if segmentLabel$ = "SIL" or segmentLabel$ = "PAU"
			segmentLabel$ = Get label of interval... segmentTier segmentInterval - 1
		endif
			

		# initialise first loop (prevSegmentLabel$ needs to be first segmentLabel$)
		if prevSegmentLabel$ = "None"
			prevSegmentLabel$ = segmentLabel$
		endif


		# new word, append previous line to output
		if (prevSegmentLabel$ != segmentLabel$)
			# append to output file
			toneLabel$ = replace$ (toneLabel$, " ", "", 1)
		#	resultline$ = "'fName$''tab$''prevSegmentLabel$''tab$''toneLabel$''newline$'"
		#	fileappend "'textfile$'" 'resultline$'
			prevSegmentLabel$ = segmentLabel$
			toneLabel$ = ""
		endif

		# label of current point
		curToneLabel$ = Get label of point: toneTier, iPoint
		toneLabel$ += " " + curToneLabel$

		
	endfor

	# final line
	toneLabel$ = replace$ (toneLabel$, " ", "", 1)
	resultline$ = "'fName$''tab$''prevSegmentLabel$''tab$''toneLabel$''newline$'"
	fileappend "'textfile$'" 'resultline$'
	prevSegmentLabel$ = segmentLabel$
	toneLabel$ = ""

	# remove files as objects
	select textGridFile
	Remove

endfor

# remove list of filenames

select Strings gridList
Remove
