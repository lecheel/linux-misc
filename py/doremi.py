#! /usr/bin/env python
import numpy
import scipy.io.wavfile
import matplotlib.pyplot

doremi = [523.0, 587.0, 659.0, 698.0, 784.0] # C,D,E,F,G or Do,Re,Mi,Fa,So

amplitude = 65536.0/4.0
sampling_rate = 44100.0 # sampling rate
duration = 0.5 # 0.5 seconds
sample = sampling_rate * duration
t = numpy.arange(sample) 
t = t/sample # scale each element for normalization
song = numpy.array([])
for i in range(5):
    for freq in doremi:
        wav = numpy.sin(2*numpy.pi*freq*t)*amplitude
        song = numpy.concatenate([song, wav])
scipy.io.wavfile.write('doremi.wav', sampling_rate, song.astype(numpy.int16))
#matplotlib.pyplot.specgram(song) # generate spectogram
#matplotlib.pyplot.savefig('doremi.png')

