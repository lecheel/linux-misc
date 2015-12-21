#! /usr/bin/env python
import pyaudio
import struct
import math
import numpy
import pylab
import wave

INITIAL_TAP_THRESHOLD = 0.010
FORMAT = pyaudio.paInt16 
SHORT_NORMALIZE = (1.0/32768.0)
CHANNELS = 2
RATE = 44100  
INPUT_BLOCK_TIME = 0.05
INPUT_FRAMES_PER_BLOCK = int(RATE*INPUT_BLOCK_TIME)
# if we get this many noisy blocks in a row, increase the threshold
OVERSENSITIVE = 15.0/INPUT_BLOCK_TIME                    
# if we get this many quiet blocks in a row, decrease the threshold
UNDERSENSITIVE = 120.0/INPUT_BLOCK_TIME 
# if the noise was longer than this many blocks, it's not a 'tap'
MAX_TAP_BLOCKS = 0.15/INPUT_BLOCK_TIME
SAVE_WAV = "rec0.wav"


def get_rms( block ):
    # RMS amplitude is defined as the square root of the 
    # mean over time of the square of the amplitude.
    # so we need to convert this string of bytes into 
    # a string of 16-bit samples...

    # we will get one short out for each 
    # two chars in the string.
    count = len(block)/2
    format = "%dh"%(count)
    shorts = struct.unpack( format, block )

    # iterate over the block.
    sum_squares = 0.0
    for sample in shorts:
        # sample is a signed short in +/- 32768. 
        # normalize it to 1.0
        n = sample * SHORT_NORMALIZE
        sum_squares += n*n

    return math.sqrt( sum_squares / count )

class dBTester(object):
    def __init__(self):
        self.pa = pyaudio.PyAudio()
        self.stream = self.open_mic_stream()
        self.tap_threshold = INITIAL_TAP_THRESHOLD
        self.noisycount = MAX_TAP_BLOCKS+1 
        self.quietcount = 0 
        self.errorcount = 0
        self.pow_db = numpy.array([])
        self.frames = []

    def stop(self):
        self.stream.close()

    def find_input_device(self):
        device_index = None            
        for i in range( self.pa.get_device_count() ):     
            devinfo = self.pa.get_device_info_by_index(i)   
#            print( "Device %d: %s"%(i,devinfo["name"][:8]) )
            for keyword in ["CONEXANT","FV Audio"]:
                if keyword in devinfo["name"][:8]:
                    print( "Found an input:\033[092m device %d - \033[093m%s\033[0m"%(i,devinfo["name"]) )
                    device_index = i
                    return device_index

        if device_index == None:
            print( "No preferred input found; using default input device." )

        return device_index

    def open_mic_stream( self ):
        device_index = self.find_input_device()

        stream = self.pa.open(   format = FORMAT,
                                 channels = CHANNELS,
                                 rate = RATE,
                                 input = True,
                                 input_device_index = device_index,
                                 frames_per_buffer = INPUT_FRAMES_PER_BLOCK)

        return stream

    def showInfo(self):
        print "\033[92mmean=%6.2fdB \033[91mmax=%6.2fdB \033[93mmin=%6.2fdB\033[0m" % (numpy.mean(self.pow_db),numpy.max(self.pow_db), numpy.min(self.pow_db))
        self.saveWAV()
    
    def showdB(self):
        pylab.subplot(211)
        pylab.title("dB in last few seconds")
        pylab.grid(True)
        pylab.subplots_adjust(hspace=.5)
        pylab.plot(numpy.arange(len(self.pow_db)),self.pow_db,"r-",label="ref")
        pylab.ylabel("dB")
        pylab.ylim([20,90])
        pylab.show()

    def saveWAV(self):
        wf = wave.open(SAVE_WAV,"wb")
        wf.setnchannels(CHANNELS)
        wf.setsampwidth(self.pa.get_sample_size(FORMAT))
        wf.setframerate(RATE)
        wf.writeframes(b''.join(self.frames))
        wf.close()

    def listen(self):
        try:
            block = self.stream.read(INPUT_FRAMES_PER_BLOCK)
            self.frames.append(block)
        except IOError, e:
            # dammit. 
            self.errorcount += 1
            print( "(%d) Error recording: %s"%(self.errorcount,e) )
            self.noisycount = 1
            return

#        pow_db = numpy.array([])
        amplitude = get_rms( block )
        db = 20 * numpy.log10( (1e-20+(amplitude))/0.0000204) #/ float(max)
        if db>20:
#            print db
            self.pow_db = numpy.append(self.pow_db, db)
"""
tt = dBTester()
for i in range(200):
    tt.listen()

tt.showInfo()
tt.showdB()
"""
