# This script will extract all words that follow a pause
# Input: folder of .textgrid files
# Output: .txt file containing: filename, word, 

# Created by Romi Hill 16.09.2022 for Benazir Mumtaz

# choose directory to process
dir$ = chooseDirectory$: "Choose a directory"

# ask for user input, including selected phoneme, directory, tiers, and output path.
form Extract all tones from interval
	comment What is the name of the word/syllable tier?
	text segmentTierName Word
	comment Where do you want to save the results?
	text textfile word_before_pauses.txt
endform

# header of output file
firstLine$ = "filename'tab$''segmentTierName$''newline$'"
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

	# get word tier
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
	# number of intervals in segment tier
	numberOfIntervals = Get number of intervals... segmentTier

	for iInterval from 1 to numberOfIntervals
				
		# label of word/syllable at interval index 
		segmentLabel$ = Get label of interval... segmentTier iInterval

		if (segmentLabel$ = "PAU") and (iInterval != numberOfIntervals)
			prevSegmentLabel$ = Get label of interval... segmentTier iInterval - 1
			resultline$ = "'fName$''tab$''prevSegmentLabel$''newline$'"
			fileappend "'textfile$'" 'resultline$'
			
		endif

		
	endfor


	# remove files as objects
	select textGridFile
	Remove

endfor

# remove list of filenames

select Strings gridList
Remove
