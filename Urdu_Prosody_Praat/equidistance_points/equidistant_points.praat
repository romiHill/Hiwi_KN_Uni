# This script will extract the F0 values of some number of equidistant points 
# in the word tier (defaults to four points)
# 
# The script runs over all TextGrids and Wav files in a specified folder, and 
# produces as output a .txt file, containing the filename, the word annotation,
# the position of word in the utterance, equidistant point number, and the F0 value 
# of that point

# The output file is saved in the 
# same directory as the script by default. It assumes the tone tier is the only 
# point tier in the script
#
# Created by Romi Hill 15.07.2022 for Benazir Mumtaz
# Updated 27.10.2022 to allow buffer

# choose directory to process
dir$ = chooseDirectory$: "Choose a directory"

# ask for user input, including selected phoneme, directory, tiers, and output path.
form Calculate F0 of tone segment with its syllable
	comment What is the name of the word tier?
	text wordTierName Word
	comment How many points would you like to extract? (integer)
	integer numberOfPoints 4
	comment How much buffer in seconds do you want? 
	positive bufferNum 0.01
	comment Where do you want to save the results?
	text textfile equidistance_f0_values.txt
endform

# header of output file
firstLine$ = "filename'tab$'word'tab$'word_index'tab$'point_index'tab$'f0_value'newline$'"
filedelete 'textfile$'
fileappend 'textfile$' 'firstLine$'

# vector to print out ordinal numbers
ordinal$# = { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth", "thirteenth", "fourteenth", "fifteenth" }

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

		# label of current point
		wordLabel$ = Get label of interval: wordTier, iInterval
		if wordLabel$ != "" and wordLabel$ != "PAU" and wordLabel$ != "SIL"
			# counter for printing out correct ordinal number
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
				# word position output
				word_position$ = ordinal$# [counter]
				
				# append to output file
				resultline$ = "'fName$''tab$''wordLabel$''tab$''word_position$''tab$''tab$''iDistance''tab$''f_zero''newline$'"
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
