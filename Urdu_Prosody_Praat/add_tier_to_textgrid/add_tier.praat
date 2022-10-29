# This script adds a tier, as chosen by the user

# Input is a folder of a textgrid files
# New textgrids are saved in an output folder specified by the user
# The script asks the user which tier should be added, based on name,
# placement, and tier type (interval or point)

# Created by Romi Hill 11.05.2022 for Benazir Mumtaz

form Duplicate Tier
	comment What is the name of the tier would you like to add?
	text tierName ?
	comment Should this be an interval tier? (uncheck box if not)
	boolean isInterval 1
	comment Where would you like to place the tier? (must be an integer)
	integer tierIndex 1
	comment What is the name of output folder?
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

	if isInterval
		Insert interval tier: tierIndex, tierName$
		
	else
		Insert point tier: tierIndex, tierName$
	
	endif

	Write to text file... 'saveDir$''fName$'

	select textGridFile
	Remove
endfor
