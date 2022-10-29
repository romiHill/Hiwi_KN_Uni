# This script automatically fills the Utterance tier of a 
# textgrid file based on a tab separated input file.
#
# The input text file has the sentence ID in the first column, 
# and utterance in the second column, separated by tabs.
# The header line must be "Sentence ID" and "Sentence"
# 
# The same folder requires a textgrid file with same name in the
# input text file.
# 


# Created by Romi Hill 19.04.2022 for Benazir Mumtaz

form Add utterance to textgrid files
	comment What is the column name for sentence ID?
	text id Sentence ID
	comment What is the column name for sentence?
	text sentence Sentence
	comment Which tier do you want to label?
	text tier Utterance
endform

# Choose textfile to process
writeInfoLine: "Open tab delimited file"

fileName$ = chooseReadFile$: "Open a text file"
if fileName$ != ""
    table = Read Table from tab-separated file: fileName$
else
	exitScript: "Please choose a text file
endif

writeInfoLine: "Open folder containing textgrid files"
dir$ = chooseDirectory$: "Choose a directory"

select table

n = Get number of rows

for i from 1 to n
	select table
	filenameEntry$ = Get value: i, id$
	utteranceEntry$ = Get value: i, sentence$

	textGridFile = Read from file: dir$ + "/" + filenameEntry$
	
	select TextGrid textGridFile
	Set interval text... tier$ 1 'utteranceEntry$'

	Write to text file... 'filenameEntry$'.TextGrid

	select TextGrid textGridFile
	Remove
endfor

select table
Remove
