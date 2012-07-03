#!/bin/sh

##
# File: flactools.sh
# Author: Giovane Boaviagem Ribeiro
# Creation Date: 11/03/2012
# 
# Dependency: cuetools, shntool, flac, wavpack, mac, mp3info, vorbis-tools, lame
##

##
# Splits a .flac file based in a .cue file
# $1 = .flac file name
# $2 = .cue file name
# $3 = output file type. Possible values: FLAC, WAV
# 
# Returns a group of files with name: split-track*.<output_file_chosen>    
##
splitFlacBasedCue(){
	# splits the file 
	cuebreakpoints $2 | shnsplit -o flac $1
	
	# transfer the metatags for the files. 
	cuetag.sh file.cue split-track*.flac		
}