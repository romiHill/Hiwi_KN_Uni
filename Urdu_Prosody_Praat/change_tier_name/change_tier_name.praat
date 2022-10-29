# This script changes the name of a tier, as chosen by the user

# Input is a folder of a textgrid files
# The script asks the user which tier should be renamed

# Created by Romi Hill 14.09.2022 for Benazir Mumtaz

form 
	comment What is the name of the tier would you like to rename?
	text oldTierName ?
	comment What is the new name of the tier?
	text newTierName ?
endform

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
		if currentTier$ = oldTierName$
			tierIndex = tier
		endif
	endfor
	
	if tierIndex = -1
		exitScript: "Tier name " + tierName$ + " does not exist in " + filenameEntry$

	endif

	Set tier name... tierIndex 'newTierName$'

	Write to text file... 'dir$'/'fName$'

	select textGridFile
	Remove
endfor

select Strings list
Remove