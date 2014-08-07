# -*- coding: utf-8 -*-
"""
Created on Fri Jul 25 19:07:59 2014

@author: Sean
"""
from scipy.interpolate import griddata,interp1d
import numpy as np
import math 
import matplotlib.pyplot as plt


# ACTUAL DENSITY BASED OFF TABLE: http://www.skyrunner.com/img/g_o2_fig4.gif

pressures = np.array([76350.0, 73710.0, 70000.0, 66170.0, 64000.0, 61010.0],dtype=float)
altitudes = np.array([2438.4, 2743.2, 3184.0, 3657.6, 3921.3, 4267.2],dtype=float)
temperatures = np.array([23.5, 20.4, 16.0, 11.2, 8.6, 5.4],dtype=float)
dewPoints = np.array([-1.7, -2.3, -3.0, -3.9, -4.4, -6.0],dtype=float)
sat_vp = np.array([5.3935, 5.15965, 4.89824, 4.57945, 4.41043, 3.90621],dtype=float)

altitudes_to_pressures = interp1d(altitudes, pressures)
altitudes_to_temps = interp1d(altitudes, temperatures)
altitudes_to_dews = interp1d(altitudes, dewPoints)
altitudes_to_svp = interp1d(altitudes, sat_vp)

altitudes_0 = np.linspace(np.min(altitudes_to_pressures.x),np.max(altitudes_to_pressures.x),num=np.max(altitudes_to_pressures.x)*2)

air_density_0 = np.zeros((np.max(altitudes_to_pressures.x)*2+1, 1),dtype=float)

n=0
for altitude in altitudes_0:
    pressure_vapor = altitudes_to_svp(altitude)
    pressure = altitudes_to_pressures(altitude)
    temp = altitudes_to_temps(altitude)
    
    air_density = (pressure/(287.05*(temp+273.15)) * (1 - ((0.378*pressure_vapor)/pressure)))
    air_density_0[n] = air_density
    n += 1

print "Air density (light blue row in table): " + str(air_density_0[-2][0])

# INPUTS

temp_lapse_rate = 6.5
sea_level_pressure = 101325
coolant_temp = 10
sea_level_temp = 15
gravity = 9.81
tests = 1
step =  0.5
total_time = 3600.0

steps = int(math.ceil(total_time/step))

dist_to_alt_lookup = 'disttoalt_pp.csv'
try:
    n = np.loadtxt(dist_to_alt_lookup,dtype = 'string',delimiter = ',', skiprows = 1)
except IOError:
    print "ERROR"

x = n[:,0].astype(np.float)
y = n[:,1].astype(np.float)

distancetoaltitude_lookup = interp1d(x,y)



# SEANS

air_density_1 = np.zeros((steps+1,tests),dtype=float)
ambient_temp_1 = np.zeros((steps+1,tests),dtype=float)
pressure_1 = np.zeros((steps+1, tests),dtype=float)
altitude_1 = np.zeros((steps+1, tests),dtype=float)
distance_1 = np.zeros((steps+1, tests),dtype=float)

distance_1[0] = 0.1
altitude_1[0] = distancetoaltitude_lookup(1)
ambient_temp_1[0] = ((sea_level_temp+273.15) - temp_lapse_rate * (altitude_1[0]/1000)) - 273.15
pressure_1[0] = sea_level_pressure * (1 - (temp_lapse_rate*(altitude_1[0]/1000)/(sea_level_temp+273.15))) ** ((gravity*28.9644)/(8.31432*temp_lapse_rate))
air_density_1[0] = (pressure_1[0] * 28.9644) / (8.31432 * (ambient_temp_1[0]+273.15) * 1000)  

for n in range(steps):
    distance_1[n+1] = distance_1[n] + np.max(distancetoaltitude_lookup.x) / steps
    if distance_1[n+1] > np.max(distancetoaltitude_lookup.x):
        distance_1[n+1] = np.max(distancetoaltitude_lookup.x)
    altitude_1[n+1] = distancetoaltitude_lookup(distance_1[n+1])
    ambient_temp_1[n+1] = ((sea_level_temp+273.15) - temp_lapse_rate * (altitude_1[n+1]/1000)) - 273.15
    pressure_1[n+1] = sea_level_pressure * (1 - (temp_lapse_rate*(altitude_1[n+1]/1000)/(sea_level_temp+273.15))) ** ((gravity*28.9644)/(8.31432*temp_lapse_rate))
    air_density_1[n+1] = (pressure_1[n+1] * 28.9644) / (8.31432 * (ambient_temp_1[n+1]+273.15) * 1000)

print air_density_1[0][0]
print 'Air density (Sean): ' + str(air_density_1[n+1][0])

# JOHNS METHOD

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

firstPercentDiff = (abs(air_density_1[n] - air_density_2[n])/(air_density_1[n] + air_density_2[n])) * 100
percentDiff = (abs(air_density_1[n+1] - air_density_2[n+1])/(air_density_1[n+1] + air_density_2[n+1])) * 100
print 'Percent difference: ' + str(percentDiff[0]) + '%\n\n'

print "Percent difference from table: " + str((abs(air_density_0[-2][0] - air_density_2[-1][0])/(air_density_0[-2][0])) * 100) + "%"
    

    
    
# FULL ALTITUDE (0-11km) GENERNATION TEST (Not used but works)
'''
air_density_3 = np.zeros((30000,tests),dtype=float)
ambient_temp_3 = np.zeros((30000,tests),dtype=float)
pressure_3 = np.zeros((300000, tests),dtype=float)
altitude_3 = np.zeros((30000, tests),dtype=float)
distance_3 = np.zeros((30000, tests),dtype=float)    
    

altitudes = np.linspace(1,11005,num=30000)


ambient_temp_3[0] = 15.0
pressure_3[0] = 101325.0
air_density_3[0] = 1.2250
temp_lapse_rate = -6.5/1000.0
gravity = 9.81
for n in range(np.size(altitudes)-1):
    ambient_temp_3[n+1] = ambient_temp_3[n] + ((temp_lapse_rate)*(((altitudes[n+1]))-(altitudes[n])))
    pressure_3[n+1] = pressure_3[n] * (((ambient_temp_3[n+1]+273.15)/(ambient_temp_3[n]+273.15))**(-1*(gravity)/(temp_lapse_rate*287.05)))
    air_density_3[n+1] = air_density_3[n] * (((ambient_temp_3[n+1]+273.15)/(ambient_temp_3[n]+273.15))**(-1*((gravity/(temp_lapse_rate*287.05))+1)))
'''


# PLOTS
    
fig = plt.figure()
ax = fig.add_subplot(1,1,1)   
ax.plot(altitude_2, air_density_1, color='k', label = 'Air Density Model #1')
ax.plot(altitude_2, air_density_2, label = 'Air Density Model #2')
ax.plot(altitudes_0, air_density_0[0:-1], label = 'Air Density Table')

handles, labels = ax.get_legend_handles_labels()
ax.legend(handles[::-1], labels[::-1])
