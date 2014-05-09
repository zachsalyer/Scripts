# -*- coding: utf-8 -*-
"""
Created on Mon Mar 24 20:14:48 2014

@author: Sean
"""

import numpy as np

runtime = dict['Runtime']
rpm = dict['MotorVelocity']
rpm = rpm * -1
current = dict['MotorCurrentCommand']
current = current * np.max(rpm)
linespace = np.linspace(0, np.shape(rpm)[0], np.shape(rpm)[0])
array = [linespace,rpm,linespace,current]
plot_tritium(dict, array, headers, [1,1], 1, 1)