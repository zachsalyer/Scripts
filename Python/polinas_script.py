# -*- coding: utf-8 -*-
"""
Created on Sat Apr 05 14:13:03 2014

@author: Sean
"""

motorTemp = dict['MotorTemp']
figure()
plot(motorTemp)
twinx()
plot(dict['BusCurrent'] * dict['BusVoltage'], 'r')
twinx()
plot(dict['MotorVelocity']*-1, 'g')
