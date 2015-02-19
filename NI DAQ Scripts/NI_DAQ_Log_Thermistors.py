# -*- coding: utf-8 -*-
"""
Created on Sun Dec 28 11:19:23 2014

@author: Sean
"""

from PyDAQmx import *
from PyDAQmx.DAQmxCallBack import *
import numpy as np

from ctypes import *
from threading import Thread
import struct
import msvcrt
import signal

import datetime

import csv

# Class of the data object
# one cannot create a weakref to a list directly
# but the following works well
class MyList(list):
    pass

# list where the data are stored
data = MyList()
id_data = create_callbackdata_id(data)
read = int32()

taskHandle = TaskHandle()
sampleRate = 1000 # Samples/sec (Hz)
inputChannels = 8 # Analog inputs used
timeout = 10.0
CANRate = 10 # Hz

rpm_offset = 0.4
torque_offset = 0.783


csvfile = open('dyno_daq_log.csv', 'w+b')
writer = csv.writer(csvfile, delimiter=',')
writer.writerow(['Time', 'RPM', 'Torque (Nm)'])

#data = np.zeros((sampleRate * inputChannels), dtype=numpy.float64)

def EveryNCallback_py(taskHandle, everyNsamplesEventType, nSamples, callbackData_ptr):
    global writer
    callbackdata = get_callbackdata_from_id(callbackData_ptr)
    read = int32()
    data = np.zeros((CANRate * inputChannels), dtype=numpy.float64)
    
    # DAQmx Read Code
    DAQmxReadAnalogF64(taskHandle,CANRate,timeout,DAQmx_Val_GroupByScanNumber,data,CANRate * inputChannels,byref(read),None)
    callbackdata.extend(data.tolist())    
    
    data[0] = (data[0] / (10.0/5000.0))# + rpm_offset
    # Send data over CAN..
    '''
    lowBytes = [ord(byte) for byte in struct.pack('!f', data[0])]
    msg[0] = lowBytes[3]
    msg[1] = lowBytes[2]
    msg[2] = lowBytes[1]
    msg[3] = lowBytes[0]
    '''
    data[1] = (data[1] / 10.0 * (625)/1.66 * 1.356)# + torque_offset
    
    '''
    highBytes = [ord(byte) for byte in struct.pack('!f', data[1])]
    msg[4] = highBytes[3]
    msg[5] = highBytes[2]
    msg[6] = highBytes[1]
    msg[7] = highBytes[0] 
    '''
    #canWrite(c_int(hnd1), 100, pointer(msg), c_int(8), c_int(0))
    time = datetime.datetime.now()
    time = time.isoformat()
    
    #print time[-7]
    if time[-7] != '.':
        time += '.000000'
    writer.writerow([time, data[0], data[1]])    
    
    return 0 # The function should return an integer





# -------------------------------------------------------------------------
# dll initialization
# -------------------------------------------------------------------------
# Load canlib32.dll
canlib32 = windll.canlib32

# Load the API functions we use from the dll
canInitializeLibrary = canlib32.canInitializeLibrary
canOpenChannel = canlib32.canOpenChannel
canBusOn = canlib32.canBusOn
canBusOff = canlib32.canBusOff
canClose = canlib32.canClose
canWrite = canlib32.canWrite
canRead = canlib32.canRead
canGetChannelData = canlib32.canGetChannelData

# A few constants from canlib.h
canCHANNELDATA_CARD_FIRMWARE_REV = 9
canCHANNELDATA_DEVDESCR_ASCII = 26

'''
# Define a type for the body of the CAN message. Eight bytes as usual.
MsgDataType = c_uint8 * 8

# Initialize the library...
canInitializeLibrary()

# ... and open channels 0 and 1. These are assumed to be on the same
# terminated CAN bus.
hnd1 = canOpenChannel(c_int(0), c_int(0))

# Go bus on
stat = canBusOn(c_int(hnd1))
if stat < 0: 
    print "canBusOn channel 1 failed: ", stat
    assert(0)

'''
# Setup a message
#msg = MsgDataType()


# Obtain the firmware revision for channel (not handle!) 0
fw_rev = c_uint64()
canGetChannelData(c_int(0), canCHANNELDATA_CARD_FIRMWARE_REV, pointer(fw_rev), 8)
print "Firmware revision channel 0 = ", (fw_rev.value >> 48), ".", (fw_rev.value >> 32) & 0xFFFF, ".", (fw_rev.value) & 0xFFFF

# Obtain device name for channel (not handle!) 0
s = create_string_buffer(100)
canGetChannelData(c_int(0), canCHANNELDATA_DEVDESCR_ASCII, pointer(s), 100)
print "Device name: ", s.value
       


try:
    # DAQmx Configure
    DAQmxCreateTask("",byref(taskHandle))
    
    # By default, DynLocV will output a 0V to +10V signal. Connect outputs to inputs AI0 and AI1 on the DAQ.
    DAQmxCreateAIVoltageChan(taskHandle,"Dev1/ai0","",DAQmx_Val_RSE,0.0,10.0,DAQmx_Val_Volts,None)
    DAQmxCreateAIVoltageChan(taskHandle,"Dev1/ai1","",DAQmx_Val_RSE,0.0,10.0,DAQmx_Val_Volts,None)   
    DAQmxCreateAIVoltageChan(taskHandle,"Dev1/ai2","",DAQmx_Val_RSE,0.0,10.0,DAQmx_Val_Volts,None)    
    DAQmxCreateAIVoltageChan(taskHandle,"Dev1/ai3","",DAQmx_Val_RSE,0.0,10.0,DAQmx_Val_Volts,None)    
    DAQmxCreateAIVoltageChan(taskHandle,"Dev1/ai4","",DAQmx_Val_RSE,0.0,10.0,DAQmx_Val_Volts,None)    
    DAQmxCreateAIVoltageChan(taskHandle,"Dev1/ai5","",DAQmx_Val_RSE,0.0,10.0,DAQmx_Val_Volts,None)    
    DAQmxCreateAIVoltageChan(taskHandle,"Dev1/ai6","",DAQmx_Val_RSE,0.0,10.0,DAQmx_Val_Volts,None)    
    DAQmxCreateAIVoltageChan(taskHandle,"Dev1/ai7","",DAQmx_Val_RSE,0.0,10.0,DAQmx_Val_Volts,None)    

    
    # Set Sampling Rate at 10000 samples/sec and sample continously until the task stops.
    DAQmxCfgSampClkTiming(taskHandle,"",1000.0,DAQmx_Val_Rising,DAQmx_Val_ContSamps,4000)

    # Convert the python function to a C function callback
    EveryNCallback = DAQmxEveryNSamplesEventCallbackPtr(EveryNCallback_py)
    # Samples to trigger event = CANRate * number of channels
    DAQmxRegisterEveryNSamplesEvent(taskHandle,DAQmx_Val_Acquired_Into_Buffer,CANRate,0,EveryNCallback,id_data)    
    
    # DAQmx Start
    DAQmxStartTask(taskHandle)
    
    #DAQmxReadAnalogF64(taskHandle,1000,10.0,DAQmx_Val_GroupByChannel,data,2000,byref(read),None)
    #print "Acquired %d points"%read.value
    #print data
    while 1:
        pass
    
except DAQError as err:
    print "DAQmx Error: %s" % err
    
finally:
    if taskHandle:
        # DAQmx Stop
        DAQmxStopTask(taskHandle)
        DAQmxClearTask(taskHandle)
        
    