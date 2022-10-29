# This script duplicates tiers with a new tier name
# The input is a folder of textgrid files

# The script asks the user which tier should be duplicated
# and the name of the new tier

# Created by Romi Hill 21.04.2022 for Benazir Mumtaz

form Duplicate Tier
	comment Which tier would you like to duplicate?
	text tierName ?
	comment What is the name of the new tier?
	text newTierName ?
	comment Where would you like to place the new tier?
	integer newTierIndex 0
	comment What is the name of output folder? The folder is in the same location as the script by default
	text saveDir output/
endform

# create output directory
createFolder: saveDir$

writeInfoLine: "Open folder containing textgrid files"
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
	
	Duplicate tier... tierIndex newTierIndex 'newTierName$'

	Write to text file... 'saveDir$''fName$'

	select textGridFile
	Remove
endfor
