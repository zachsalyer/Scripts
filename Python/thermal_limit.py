# -*- coding: utf-8 -*-
"""
Created on Sun Mar 23 10:59:09 2014

@author: Sean

Used to determine if there was a thermal limit and at what motor speed and
temp. Uses samples instead of runtime since there is a slight offset when
using runtime as X.
"""
import numpy as np

runtime = dict['Runtime']
rpm = dict['MotorVelocity']
rpm = rpm * -1
motor_temp = dict['MotorTemp']
motor_temp = motor_temp
linespace = np.linspace(0, np.shape(rpm)[0], np.shape(rpm)[0])
array = [linespace,rpm,linespace,motor_temp]
plot_tritium(dict, array, headers, [1,1], 1, 1)