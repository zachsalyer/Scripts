# -*- coding: utf-8 -*-
"""
Created on Sat Apr 05 10:25:37 2014

@author: Sean
"""

motorScoop = dict['MotorScoop']
velocity = dict['MotorVelocity']*(-1)
figure()
plot(motorScoop, 'r')
twinx()
plot(velocity)