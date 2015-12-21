#! /bin/bash
  au -p1
  au -cv MicIn.pcm min.wav
  au -cv MicOut.pcm mout.wav
  au -cv speakerIn.pcm sin.wav
  au -cv speakerOut.pcm sout.wav
  rm *.pcm
  au mout.wav min.wav
	      
