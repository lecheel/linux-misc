import matplotlib
# matplotlib.use('MacOSX')
 
import pyaudio
import wave
import numpy as np
import os,sys
import time
import subprocess
import multiprocessing


ADEV = [ "sysdefault:CARD=Set", "sysdefault:CARD=USB" ]

class aplay:
    def aplay(self, command):
        command_result = ''
        command_text = 'aplay -D %s %s ' % (ADEV[0],command)
        pp = subprocess.Popen(command_text, shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT)
        return pp.communicate()
"""
	results = os.popen(command_text, "r")
        while 1:
            line = results.readline()
            if not line: break
            command_result += line
        return command_result
"""

chunk = 256
def find_output_device():
    device_index = None            
    for i in range( p.get_device_count() ):     
        devinfo = p.get_device_info_by_index(i)   
        print( "Device %d: %s"%(i,devinfo["name"][:8]) )
        for keyword in ["CONEXANT","FV Audio","Jabra SP"]:
            if keyword in devinfo["name"][:8]:
                print( "Found an output:\033[092m device %d - \033[093m%s\033[0m"%(i,devinfo["name"]) )
                device_index = i
                return device_index

    if device_index == None:
        print( "No preferred device." )
    return device_index


def audiostream(fname,chunk,hda):
    # open stream
    wf = wave.open(fname,"rb")
    p = pyaudio.PyAudio()

    stream=p.open(
        format = p.get_format_from_width(wf.getsampwidth()),
        channels = wf.getnchannels(),
        rate = wf.getframerate(),
        output = True)
 
    data = wf.readframes(chunk)

    while data != '':
        stream.write(data)
        data = wf.readframes(chunk)

    stream.close()
    p.terminate()
 
hda=0
aa=aplay()
o = multiprocessing.Process(target=audiostream, name="PLAY0", args=("l410.wav",chunk,hda))
aa.aplay("/opt/raw/eng_f1.wav")
o.start()
# Terminate foo
time.sleep(10)
o.terminate()
# Cleanup
p.join()
#audiostream("/opt/raw/eng_f1.wav",chunk)
