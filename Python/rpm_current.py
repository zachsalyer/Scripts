# -*- coding: utf-8 -*-
"""
Created on Mon Mar 24 20:14:48 2014

@author: Sean
"""

import numpy as np
import matplotlib.pyplot as plt


runtime = dict['Runtime']
rpm = dict['MotorVelocity']
rpm = rpm * -1
current = dict['MotorCurrentCommand']
phasecurrent = dict['PhaseBcurrent']
current = current * np.max(rpm)
linespace = np.linspace(0, np.shape(rpm)[0], np.shape(rpm)[0])
array = [linespace,rpm,linespace,current]
fig = plt.figure()
ax = fig.add_subplot(1,1,1)
ax.plot(linespace, phasecurrent, 'b', label="Phase current")
ax2= ax.twinx()
ax2.plot(linespace, rpm, 'r', label="RPM")

handles, labels = ax.get_legend_handles_labels()
handles2, labels2 = ax2.get_legend_handles_labels()
ax.legend(handles + handles2, labels + labels2)

ax.set_xlabel("Steps")
ax.set_ylabel(r"Arms")
ax2.set_ylabel(r"RPM")

plt.show()
#plot_tritium(dict, array, headers, [1,1], 1, 0)