# -*- coding: utf-8 -*-
"""
Created on Mon Mar 24 21:13:46 2014

@author: Sean
"""

from scipy.interpolate import griddata,interp1d

import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from mayavi import mlab
from mpl_toolkits.mplot3d import Axes3D

gps = "C:\Users\Sean\Desktop\Buckeye Current\Test Data\gps_zach.csv"

n = np.loadtxt(gps, dtype = 'string', delimiter = ',', skiprows = 1)
x = n[:,0].astype(np.float)
y = n[:,1].astype(np.float)
z = n[:,2].astype(np.float)
dist = n[:,3].astype(np.float)
distancetoaltitude_lookup = interp1d(dist,z)

'''
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
'''
fig = plt.figure()
ax = Axes3D(fig)
longitude = x
latitude = y
altitude = z

steps = np.size(altitude)
tests = 1

temp_lapse_rate = 6.5
sea_level_pressure = 101325
sea_level_temp = 15
gravity = 9.81

air_density_2 = np.zeros((steps+1,tests),dtype=float)
ambient_temp_2 = np.zeros((steps+1,tests),dtype=float)
pressure_2 = np.zeros((steps+1, tests),dtype=float)
altitude_2 = np.zeros((steps+1, tests),dtype=float)
distance_2 = np.zeros((steps+1, tests),dtype=float)

altitude_2[0] = distancetoaltitude_lookup(1)
ambient_temp_2[0] = ((sea_level_temp+273.15) - temp_lapse_rate * (altitude_2[0]/1000)) - 273.15
pressure_2[0] = sea_level_pressure * (1 - (temp_lapse_rate*(altitude_2[0]/1000)/(sea_level_temp+273.15))) ** ((gravity*28.9644)/(8.31432*temp_lapse_rate))
air_density_2[0] = (pressure_2[0] * 28.9644) / (8.31432 * (ambient_temp_2[0]+273.15) * 1000)
temp_lapse_rate = -6.5/1000.0



for n in range(steps):
    distance_2[n+1] = distance_2[n] + np.max(distancetoaltitude_lookup.x) / steps
    if distance_2[n+1] > np.max(distancetoaltitude_lookup.x):
        distance_2[n+1] = np.max(distancetoaltitude_lookup.x)
    altitude_2[n+1] = distancetoaltitude_lookup(distance_2[n+1])
    ambient_temp_2[n+1] = ambient_temp_2[n] + ((temp_lapse_rate)*((altitude_2[n+1])-(altitude_2[n])))
    pressure_2[n+1] = pressure_2[n] * (((ambient_temp_2[n+1]+273.15)/(ambient_temp_2[n]+273.15))**((-1*gravity)/(temp_lapse_rate*287.05)))
    air_density_2[n+1] = air_density_2[n] * (((ambient_temp_2[n+1]+273.15)/(ambient_temp_2[n]+273.15))**(-1*((gravity/(temp_lapse_rate*287.05))+1)))
    
print 'Air density (John): ' + str(air_density_2[n+1][0])

cs = air_density_2
cs = np.square(cs)
cs = cs/max(cs)
'''np.where()'''
#longitude = np.trim_zeros(longitude)
#latitude = np.trim_zeros(latitude)

#start = np.shape(altitude)[0] - np.shape(longitude)[0]
#altitude = altitude[start:np.shape(altitude)[0]]
#result1 = ax.plot(longitude, latitude, altitude, c = cs)
#mymap = matplotlib.colors.LinearSegmentedColormap.from_list('mycolors',['blue','red'])
m = cm.ScalarMappable(cmap=cm.jet)
m.set_array(cs)
plt.colorbar(m)


for i in range(1, np.size(altitude)):
    result = ax.plot(x[i-1:i+1], y[i-1:i+1], z[i-1:i+1], c=(cs[i-1], 1-cs[i-1], 0))



#plt.show()
