# This script generates TextGrid files based on a folder of wav files
# TextGrid files will have the same name wav files, and contain the 
# tiers Syllable, Word, Tone, and Utterance. Syllable, Word, and Utterance
# tiers are interval tiers, and Tone is a point tier.
#
# Created by Romi Hill 11.05.2022 for Benazir Mumtaz

# choose directory to process
dir$ = chooseDirectory$: "Choose a directory"

# get list of .wav files
Create Strings as file list: "list", dir$ + "/" + "*.wav"
select Strings list

# loop through all the files
nFiles = Get number of strings

for iFile from 1 to nFiles
	select Strings list
	wavName$ = Get string... iFile
	wavFile = Read from file... 'dir$'/'wavName$'
	wavObject$ = selected$("Sound")

	To TextGrid... "Syllable Word Tone Utterance", Tone
	Write to text file... 'dir$'/'wavObject$'.TextGrid

	Rename... textGridFile

	select wavFile
	Remove
	select TextGrid textGridFile
	Remove

endfor

# remove list of filenames
select Strings list
Remove
