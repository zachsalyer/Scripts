# -*- coding: utf-8 -*-
"""
Created on Mon Mar 24 21:13:46 2014

@author: Sean
"""

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
longitude = dict['GPSLongitude']
latitude = dict['GPSLatitude']
altitude = dict['GPSAltitude']
'''np.where()'''
longitude = np.trim_zeros(longitude)
latitude = np.trim_zeros(latitude)

start = np.shape(altitude)[0] - np.shape(longitude)[0]
altitude = altitude[start:np.shape(altitude)[0]]
ax.plot(longitude,latitude, altitude)