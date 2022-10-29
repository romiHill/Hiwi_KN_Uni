# Converts an interval tier to a point tier based on user input
#
# User is asked for the name of tier they want to convert, and the 
# name of the output folder
#
# Input directory must contain TextGrid files (and maybe other files,
# which will be ignored, too)
# Created by Romi Hill 11.05.2022 for Benazir Mumtaz

form Convert interval tier to point tier
	comment Which interval tier do you want to convert?
	text tierName Tone
	comment What is the name of the otput folder?
	text saveDir output/
endform

# create output directory
createFolder: saveDir$

# choose directory with TextGrid files to process
dir$ = chooseDirectory$: "Choose a directory"

# get list of .TextGrid files
Create Strings as file list: "list", dir$ + "/" + "*.TextGrid"
select Strings list

# loop through all the files
nFiles = Get number of strings

for iFile from 1 to nFiles
	# open file
	select Strings list
	fName$ = Get string... iFile
	textGridFile = Read from file... 'dir$'/'fName$'
	select textGridFile
	
	# get index of tier to convert
	nTiers = Get number of tiers
	tierIndex = -1
	for tier to nTiers
		currentTier$ = Get tier name: tier
		if currentTier$ = tierName$
			tierIndex = tier
		endif
	endfor
	
	if tierIndex = -1
		exitScript: "Tier name" + tierName$ + " does not exist in " + filenameEntry$

	endif

	Remove tier... tierIndex
	
	Insert point tier: tierIndex, tierName$

	Write to text file... 'saveDir$''fName$'

	select textGridFile
	Remove

endfor

# remove list of filenames
select Strings list
Remove
