# This script will calculate the durations of a selected utterance.
# The script runs over all TextGrids in a specified folder, and produces as output
# a .txt file, containing the filename, the utterance, and its duration. The output 
# file is saved in the same directory as the script by default.
#
# Assumes that tier name is either utterance or Utterance
# Created by Romi Hill 21.03.2022 for Benazir Mumtaz

# choose directory to process
dir$ = chooseDirectory$: "Choose a directory"

# ask for user input, including selected utterance, directory, tiers, and output path.
form Calculate durations of selected utterance
	comment Where do you want to save the results?
	text textfile durations_utterance.txt
endform

# get list of .TextGrid files
Create Strings as file list: "list", dir$ + "/" + "*.TextGrid"
select Strings list

# loop through all the files
nFiles = Get number of strings

# header of output file
firstLine$ = "filename'tab$'utterance'tab$'duration'tab$''newline$'"
filedelete 'textfile$'
fileappend 'textfile$' 'firstLine$'
for iFile from 1 to nFiles

    # open file
    select Strings list
    fName$ = Get string: iFile
    textGridFile = Read from file: dir$ + "/" + fName$
	
	# get numbers of tiers
	nTiers = Get number of tiers
	utteranceTier = -1
	for tier to nTiers
		tierName$ = Get tier name: tier
		if tierName$ = "Utterance" or tierName$ = "utterance"
			utteranceTier = tier
		endif

	endfor
	
	if utteranceTier = -1
		exitScript: "Tier name " + utteranceTierName$ + " does not exist in " + fName$
	endif

	# number of intervals in utterance tier
	numberOfIntervals = Get number of intervals... utteranceTier

	# check all intervals in utterance tier
	for iInterval from 1 to numberOfIntervals

		# label of current interval
		label$ = Get label of interval... utteranceTier iInterval
		if label$ != ""
			# calculate its duration
			start = Get starting point... utteranceTier iInterval
			end = Get end point... utteranceTier iInterval
			duration = end - start

			# append the filename, word, utterance, and its duration to the end of the text file 
			# separated with a tab:		
			resultline$ = "'fName$''tab$''label$''tab$''duration''newline$'"
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
