# This script will calculate the durations of a selected phoneme that is word final,
# and is not followed by a SIL or PAU label.
# The script runs over all TextGrids in a specified folder, and produces as output
# a .txt file, containing the filename, the word associated with the phoneme, the
# phoneme, and its duration. The output file is saved in the same directory as the
# script by default.
#
# Created by Romi Hill 21.03.2022 for Benazir Mumtaz

# choose directory to process
dir$ = chooseDirectory$: "Choose a directory"

# ask for user input, including selected phoneme, directory, tiers, and output path.
form Calculate durations of selected phoneme
	comment What sound do you want to extract?
	text selectedPhoneme  
	comment Which tier of the TextGrid object is the segment tier?
	text segmentTierName Segment
	comment Which tier of the TextGrid object is the word tier?
	text wordTierName Word
	comment Where do you want to save the results?
	text textfile durations_phoneme.txt
endform

# tell the user to choose a phoneme if they didn't
if selectedPhoneme$ = ""
    exitScript: "Please choose a phoneme."
endif

# get list of .TextGrid files
Create Strings as file list: "list", dir$ + "/" + "*.TextGrid"
select Strings list

# loop through all the files
nFiles = Get number of strings

# header of output file
firstLine$ = "filename'tab$'word'tab$'phoneme'tab$'duration'tab$''newline$'"
filedelete 'textfile$'
fileappend 'textfile$' 'firstLine$'

for iFile from 1 to nFiles

    # open file
    select Strings list
    fName$ = Get string: iFile
    textGridFile = Read from file: dir$ + "/" + fName$

	# get numbers of tiers
	nTiers = Get number of tiers
	syllableTier = -1
	wordTier = -1
	for tier to nTiers
		tierName$ = Get tier name: tier
		if tierName$ = segmentTierName$
			segmentTier = tier
		endif

		if tierName$ = wordTierName$
			wordTier = tier
		endif
	endfor
	
	if segmentTier = -1
		exitScript: "Tier name" + segmentTierName$ + " does not exist in " + fName$

	endif
	if wordTier = -1
		exitScript: "Tier name" + wordTierName$ + " does not exist in " + fName$
	endif


	# number of intervals in segment tier
	numberOfIntervals = Get number of intervals... segmentTier

	# check all intervals in segment tier
	for iInterval from 1 to numberOfIntervals

		# label of current interval
		label$ = Get label of interval... segmentTier iInterval

		# label of following interval
		if iInterval < numberOfIntervals
			followingLabel$ = Get label of interval... segmentTier iInterval + 1
		# if last interval, assume following label is SIL since it's the end of the word
		else	
			followingLabel$ = "SIL"
		endif

		# the interval is selected phoneme as a label, and following label is not SIL or PAU
		if label$ = selectedPhoneme$ and followingLabel$ != "PAU" and followingLabel$ != "SIL"
			# calculate its duration
			start = Get starting point... segmentTier iInterval
			end = Get end point... segmentTier iInterval
			duration = end - start

			# get word by time
			wordInterval = Get interval at time... wordTier start
			word$ = Get label of interval... wordTier wordInterval

			# segment label is end of word, add it to the output file
			endWord = Get end point... wordTier wordInterval
			if end = endWord
				# append the filename, word, phoneme, and its duration to the end of the text file 
				# separated with a tab:		
				resultline$ = "'fName$''tab$''word$''tab$''label$''tab$''duration''newline$'"
				fileappend "'textfile$'" 'resultline$'
			endif
		endif
	endfor

	# remove file as object
	select textGridFile
	Remove

endfor

# remove list of filenames
select Strings list
Remove
