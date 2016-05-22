#! /bin/bash
if ! [ $1 == "" ]; then
  youtube-dl --extract-audio --audio-format mp3 $@
fi
