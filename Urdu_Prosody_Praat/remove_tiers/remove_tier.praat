# This script removes tiers, as chosen by the user

# Input is a folder of a textgrid files
# New textgrids are saved in an output folder specified by the user
# The script asks the user which tier should be removed

# Created by Romi Hill 21.04.2022 for Benazir Mumtaz

form Duplicate Tier
	comment Which tier would you like to remove?
	text tierName ?
	comment What is the name of output folder? The folder is in the same location as the script by default
	text saveDir output/
endform

# create output directory
createFolder: saveDir$

dir$ = chooseDirectory$: "Choose a directory"

Create Strings as file list: "list", dir$ + "/" + "*.TextGrid"
select Strings list

nFiles = Get number of strings

for iFile from 1 to nFiles

    # open file
    select Strings list
    fName$ = Get string: iFile
    textGridFile = Read from file: dir$ + "/" + fName$
	select textGridFile

	# get index of tier
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

	Write to text file... 'saveDir$''fName$'

	select textGridFile
	Remove
endfor
