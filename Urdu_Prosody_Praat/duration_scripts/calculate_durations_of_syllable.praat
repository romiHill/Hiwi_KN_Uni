# This script will calculate the durations of a selected syllable.
# The script runs over all TextGrids in a specified folder, and produces as output
# a .txt file, containing the filename, the word associated with the syllable, the
# syllable, and its duration. The output file is saved in the same directory as the
# script by default.
#
# Created by Romi Hill 21.03.2022 for Benazir Mumtaz

# choose directory to process
dir$ = chooseDirectory$: "Choose a directory"

# ask for user input, including selected syllable, directory, tiers, and output path.
form Calculate durations of selected syllable
	comment What is the name of the syllable tier?
	text syllableTierName Syllable
	comment What is the name of the word tier?
	text wordTierName Word
	comment Where do you want to save the results?
	text textfile durations_syllable.txt
endform

# get list of .TextGrid files
Create Strings as file list: "list", dir$ + "/" + "*.TextGrid"
select Strings list

# loop through all the files
nFiles = Get number of strings

# header of output file
firstLine$ = "filename'tab$'word'tab$'syllable'tab$'duration'tab$''newline$'"
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
		if tierName$ = syllableTierName$
			syllableTier = tier
		endif

		if tierName$ = wordTierName$
			wordTier = tier
		endif
	endfor
	
	if syllableTier = -1
		exitScript: "Tier name" + syllableTierName$ + " does not exist in " + fName$
	endif
	if wordTier = -1
		exitScript: "Tier name" + wordTierName$ + " does not exist in " + fName$
	endif

	# number of intervals in syllable tier
	numberOfIntervals = Get number of intervals... syllableTier

	# check all intervals in syllable tier
	for iInterval from 1 to numberOfIntervals

		# label of current interval
		label$ = Get label of interval... syllableTier iInterval
		if label$ != "" and label$ != "PAU" and label$ != "SIL"
			# calculate its duration
			start = Get starting point... syllableTier iInterval
			end = Get end point... syllableTier iInterval
			duration = end - start	

			# get word by time
			wordInterval = Get interval at time... wordTier start
			word$ = Get label of interval... wordTier wordInterval

			# append the filename, word, syllable, and its duration to the end of the text file 
			# separated with a tab:		
			resultline$ = "'fName$''tab$''word$''tab$''label$''tab$''duration''newline$'"
			fileappend "'textfile$'" 'resultline$'

		endif
	endfor

	# remove file as object
	select textGridFile
	Remove

endfor

# remove list of filenames
select Strings list
Remove
