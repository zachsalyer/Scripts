# -*- coding: utf-8 -*-
"""
Created on Sat Mar 22 11:39:08 2014

@author: Sean
"""

fig = figure()
ax = fig.add_subplot(111)
runtime = dict['Runtime']
heartbeat = dict['MagicCanNode1RHeartbeat']
plot(runtime,heartbeat, label = 'MagicCAN1', color = 'b')
heartbeat = dict['MagicCanNode2Heartbeat']
plot(runtime,heartbeat, label = 'MagicCAN2', color = '#01FFFE')
heartbeat = dict['MagicCanNode3Heartbeat']
plot(runtime,heartbeat, label = 'MagicCanNode3Heartbeat', color = 'r')
heartbeat = dict['FrameFaultHeartbeat']
plot(runtime,heartbeat, label = 'FrameFaultHeartbeat', color = 'c')
heartbeat = dict['DriveControlsHeartbeat']
plot(runtime,heartbeat, label = 'DriveControlsHeartbeat', color = 'm')

heartbeat = dict['CANMirrorHeartbeat']
plot(runtime,heartbeat, label = 'CANMirrorHeartbeat', color = '#C28C9F')

heartbeat = dict['RiderDisplayHeartbeat']
plot(runtime,heartbeat, label = 'RiderDisplayHeartbeat', color = 'y')
heartbeat = dict['BIM1Heartbeat']
plot(runtime,heartbeat, label = 'BIM1Heartbeat', color = 'k')
heartbeat = dict['BIM2Heartbeat']
plot(runtime,heartbeat, label = 'BIM2Heartbeat', color = '#006401')
heartbeat = dict['BIM3Heartbeat']
plot(runtime,heartbeat, label = 'BIM3Heartbeat', color = '#FFDB66')
heartbeat = dict['BIM4Heartbeat']
plot(runtime,heartbeat, label = 'BIM4Heartbeat', color = '#FFA6FE')
heartbeat = dict['StatusInformation']
plot(runtime,heartbeat)

handles, labels = ax.get_legend_handles_labels()
ax.legend(handles,labels)

#00FF00','#0000FF','#FF0000','#01FFFE','#FFA6FE','#FFDB66','#006401'