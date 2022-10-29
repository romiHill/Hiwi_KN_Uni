# This script will calculate the mean intensity of the overall utterance in a wav file

# The script runs over all TextGrids and Wav files in a specified folder, and 
# produces as output a .txt file, containing the filename, the utterance,
# and the mean intensity of the utterance (in dB).
# The output file is saved in the same directory as the script by default. 

# Created by Romi Hill 11.05.2022 for Benazir Mumtaz

# choose directory to process
dir$ = chooseDirectory$: "Choose a directory"

# ask for user input, including selected phoneme, directory, tiers, and output path.
form Calculate F0 of tone segment with its syllable
	comment What is the name of the Utterance tier?
	text utteranceTierName Utterance
	comment Where do you want to save the results?
	text textfile mean_intensity.txt
endform

# header of output file
firstLine$ = "filename'tab$'utterance'tab$'intensity'newline$'"
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
	utteranceTier = -1
	for tier to nTiers
		tierName$ = Get tier name: tier
		if tierName$ = utteranceTierName$
			utteranceTier = tier
		endif
	endfor
	
	if utteranceTier = -1
		exitScript: "Tier name" + utteranceTierName$ + " does not exist in " + fName$
	endif

	# Open wav file
	select Strings wavList
	wavName$ = Get string... iFile
	wavFile = Read from file... 'dir$'/'wavName$'
	wavObject$ = selected$("Sound")

	select TextGrid 'textGridObject$'

	# get start and end point of utterance tier

	numberOfIntervals = Get number of intervals... utteranceTier

	# check all intervals in utterance tier
	for iInterval from 1 to numberOfIntervals
		select textGridFile

		# label of current interval
		label$ = Get label of interval... utteranceTier iInterval
		if label$ != ""
			# extract start and end of interval
			start = Get starting point... utteranceTier iInterval
			end = Get end point... utteranceTier iInterval

			# extract intensity
			select Sound 'wavObject$'
			To Intensity... 100 0
			select Intensity 'wavObject$'
			meanIntensity = Get mean... start end dB


			# append the filename, word, utterance, and its duration to the end of the text file 
			# separated with a tab:		
			resultline$ = "'fName$''tab$''label$''tab$''meanIntensity''newline$'"
			fileappend "'textfile$'" 'resultline$'

			select Intensity 'wavObject$'
			Remove
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
