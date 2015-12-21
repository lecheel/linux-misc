#! /usr/bin/env python
import time
import math
import wave
import struct
from struct import pack
from ctypes import *
from array import array
import os,sys
import glob


for files in glob.glob("*.wav"):
        pngfile = files[:-3]+"png"
        if os.path.exists(pngfile):
                print "Skip %s" % files
        else:
                print files
                os.system("au0 -aa %s"%files)