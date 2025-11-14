#!/bin/bash

# ref: https://askubuntu.com/questions/1258842/how-to-save-the-audio-from-webm-to-ogg-without-transcoding-using-ffmpeg#1258910

#.webm files indeed can contain vorbis audio, but it can also contain opus audio.
#Also an ogg file can contain both audio formats. One can transfer the audio without conversion to an .ogg file:

set -e #stop script when a command returns a none zero exit code

INPUTDIR=/home/chris/Videos/youtube_downloads/
#INPUTFILE=/home/chris/Videos/youtube_downloads/test/'William Gibson Reads Neuromancer [1 ⧸ 8] [5DFSvbkQaD0].webm'

OUTPUTDIR="$INPUTDIR"encoded/

#if the OUTPUTDIR does not exist then create it
if [[ ! -d "$OUTPUTDIR" ]]
then
	mkdir "$OUTPUTDIR"
	echo "created outputdir $OUTPUTDIR"
else
	echo "outputdir exists: $OUTPUTDIR"
fi

#loop to encode all *.webm files to .mp3 files
for FILE in $INPUTDIR*.webm; do
    echo -e "Processing video '\e[32m$FILE\e[0m'"
    ffmpeg -i "$FILE" -vn -ac 2 -b:a 64k -y $OUTPUTDIR"$(basename "$FILE" .webm)".mp3;
done

exit 0

#more info: https://trac.ffmpeg.org/wiki/Encode/MP3

#ffmpeg -i "$INPUTFILE" -vn -ar 44100 -ac 2 -b:a 128k -y "$(basename "$INPUTFILE" .webm)"_2.mp3;
#ffmpeg -i "$INPUTFILE" -vn -ar 44100 -ac 2 -q:a 5 -y "$(basename "$INPUTFILE" .webm)"_3.mp3;
ffmpeg -i "$INPUTFILE" -vn -ac 2 -b:a 64k -y "$(basename "$INPUTFILE" .webm)"_5.mp3;
#ffmpeg -i "$INPUTFILE" -vn -ab 128k -ar 44100 -y "$(basename "$INPUTFILE" .webm)".mp3;

#copy the .ogg part without re-encoding
#ffmpeg -i "$INPUTFILE" -vn -c:a copy "$(basename "$INPUTFILE" .webm)".ogg

exit 0


