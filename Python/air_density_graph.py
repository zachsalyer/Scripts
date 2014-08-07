# -*- coding: utf-8 -*-
"""
Created on Wed Jul 30 09:02:31 2014

@author: seaharri
"""
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d import proj3d
from matplotlib.colors import LinearSegmentedColormap
from scipy.interpolate import griddata,interp1d

def update_position(e):
    print "In update"
    x2, y2, _ = proj3d.proj_transform(x,y,z, ax.get_proj())
    for i in range(1,np.size(z)):
        if i%500 == 0:
            labels[(i/500)-1].xy = x2[i],y2[i]            
            labels[(i/500)-1].update_positions(fig.canvas.renderer)

    fig.canvas.draw()


file = "C:\Users\Sean\Desktop\Buckeye Current\Test Data\gps_zach.csv"

gps_info = np.loadtxt(file, dtype=float, delimiter=',', skiprows = 1)
x = gps_info[:,0]
y = gps_info[:,1]
z = gps_info[:,2]
dist = gps_info[:,3]

distancetoaltitude_lookup = interp1d(dist,z)

steps = np.size(z)
tests = 1
sea_level_temp = 15
sea_level_pressure = 101325
temp_lapse_rate = 6.5
gravity = 9.8
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


air_density_2 = air_density_2[:-1]


cdict1 = {'red':   ((0.0, 0.0, 0.0),
                   (1.0, 1.0, 1.0)),

         'green': ((0.0, 1.0, 1.0),
                    (1.0, 0.0, 0.0)),

         'blue':  ((0.0, 0.0, 0.0),
                   (1.0, 0.0, 0.0))
        }
green_red = LinearSegmentedColormap('GreenRed1', cdict1)
#cmap = matplotlib.colors.ListedColormap(["red","green"], name='from_list', N=None)
sm = plt.cm.ScalarMappable(cmap=green_red, norm=plt.Normalize(np.min(air_density_2), np.max(air_density_2)))
sm.set_array(air_density_2)


t = air_density_2[:-1]
t = (t - np.min(t)) / (np.max(t) - np.min(t))

print t

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
#ax.set_zlabel('Altitude (m)')
ax.set_xticks([])
ax.set_yticks([])
ax._axis3don = False



box = ax.get_position()
# create color bar
axColor = plt.axes([box.x0*1.00 + box.width * 1.00, box.y0, 0.01, box.height])

cb = plt.colorbar(sm, cax = axColor)
cb.set_label("Air density (kg/m^3)")
cb.ax.invert_yaxis()
labels = []
ax.set_xlim(25,50)
ax.set_ylim(np.min(y),np.max(y))
ax.set_zlim(np.min(z),np.max(z))
x2, y2, _ = proj3d.proj_transform(x,y,z, ax.get_proj())

print x2

ax.scatter(x,y,z,t,cmap=green_red, lw = 0, s = 1)
for i in range(1,np.size(z),500):
    name = "Altitude: " + np.str(z[i]) + " m\n" + "Distance: " + np.str(dist[i]) + " m"
    label = ax.annotate(name, xy=(x2[i], y2[i]),
                xytext=(-150.0, -10.0), textcoords='offset points',
                fontsize=10,                
                arrowprops=dict(arrowstyle="->",
                                connectionstyle="arc3,rad=0")
                )
    labels.append(label)
'''
for i in range(1,np.size(z)):
    #ax.scatter(x[i-1:i+1],y[i-1:i+1],z[i-1:i+1],c=(t[i-1],1-t[i-1],0), lw = 0, s = 1)
    if i%500 == 0:
        
      
'''
fig.canvas.mpl_connect('button_release_event', update_position)
          
plt.show()

