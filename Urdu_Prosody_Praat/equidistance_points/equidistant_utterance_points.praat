# This script will extract the F0 values of some number of equidistant points 
# in the utterance tier (defaults to twenty points)
# 
# The script runs over all TextGrids and Wav files in a specified folder, and 
# produces as output a .txt file, containing the filename, the utterance annotation,
# equidistant point number, and the F0 value of that point

# The output file is saved in the 
# same directory as the script by default. It assumes the tone tier is the only 
# point tier in the script
#
# Created by Romi Hill 15.07.2022 for Benazir Mumtaz

# choose directory to process
dir$ = chooseDirectory$: "Choose a directory"

# ask for user input, including selected phoneme, directory, tiers, and output path.
form Calculate F0 of tone segment with its syllable
	comment What is the name of the Utterance tier?
	text wordTierName Utterance
	comment How many points would you like to extract? (integer)
	integer numberOfPoints 20
	comment Where do you want to save the results?
	text textfile equidistance_utterance_f0_values.txt
endform

# header of output file
firstLine$ = "filename'tab$'utterance'tab$''point_index'tab$'f0_value'newline$'"
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
	wordTier = -1
	for tier to nTiers
		tierName$ = Get tier name: tier
		if tierName$ = wordTierName$
			wordTier = tier
		endif
	endfor
	
	if wordTier = -1
		exitScript: "Tier name" + wordTierName$ + " does not exist in " + fName$
	endif

	# Open wav file
	select Strings wavList
	wavName$ = Get string... iFile
	wavFile = Read from file... 'dir$'/'wavName$'
	wavObject$ = selected$("Sound")

	select TextGrid 'textGridObject$'
	numberOfIntervals = Get number of intervals... wordTier
	
	# keep track of word position in utterance
	counter = 0
	# check all intervals in segment tier
	for iInterval from 1 to numberOfIntervals
		select TextGrid 'textGridObject$'

		# calculate of interval duration
		start = Get starting point... wordTier iInterval
		end = Get end point... wordTier iInterval
		duration = end - start
		# distance = duration/(numberOfPoints + 1)

		# label of current point
		wordLabel$ = Get label of interval: wordTier, iInterval
		if wordLabel$ != "" and wordLabel$ != "PAU" and wordLabel$ != "SIL" and wordLabel$ != " "
			counter += 1
			for iDistance from 1 to numberOfPoints

				if numberOfPoints = 1
					time = duration / 2

				elsif numberOfPoints = 2
					firstValue = 1
					if firstValue
						time = duration / 2
						firstValue = 0
					else
						time = end
					endif
				
				else
					duration = end - start - (2 * bufferNum)
					time = (start + bufferNum) + ((iDistance - 1) * duration)/(numberOfPoints - 1)
				endif
	
				# F0 label
				select Sound 'wavObject$'
				To Pitch... 0.01 75 600
				select Pitch 'wavObject$'
				f_zero = Get value at time... 'time' Hertz Linear
				
				# append to output file
				resultline$ = "'fName$''tab$''wordLabel$''tab$''tab$''iDistance''tab$''f_zero''newline$'"
				fileappend "'textfile$'" 'resultline$'
				select Pitch 'wavObject$'
				Remove
			endfor
		endif

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
