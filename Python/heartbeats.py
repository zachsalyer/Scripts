# -*- coding: utf-8 -*-
"""
Created on Sat Mar 22 11:40:21 2014

@author: Sean
"""

figure()
runtime = dict['Runtime']
heartbeat = dict['MagicCanNode1RHeartbeat']
plot(runtime, heartbeat)
heartbeat = dict['MagicCanNode2Heartbeat']
plot(runtime, heartbeat)
heartbeat = dict['MagicCanNode3Heartbeat']
plot(runtime, heartbeat)
heartbeat = dict['FrameFaultHeartbeat']
plot(runtime, heartbeat)
heartbeat = dict['DriveControlsHeartbeat']
plot(runtime, heartbeat)
heartbeat = dict['CANMirrorHeartbeat']
plot(runtime, heartbeat)
heartbeat = dict['RiderDisplayHeartbeat']
plot(runtime, heartbeat)
heartbeat = dict['BIM1Heartbeat']
plot(runtime, heartbeat)
heartbeat = dict['BIM2Heartbeat']
plot(runtime, heartbeat)
heartbeat = dict['BIM3Heartbeat']
plot(runtime, heartbeat)
heartbeat = dict['BIM4Heartbeat']
plot(runtime, heartbeat)
heartbeat = dict['StatusInformation']
plot(runtime, heartbeat)