# -*- coding: utf-8 -*-
"""
Created on Sat Mar 08 20:18:43 2014

@author: Sean
"""
import numpy as np
import scipy.misc
import matplotlib.pyplot as plt
import itertools
import string


def plot_tritium(dictionary, headers_to_plot, headers, scales = [], toggleLimits = 1, toggleErrors = 1):
    '''
    Function used to plot data against limit and errors from the Tritium.
    
    Inputs:
        dictionary -- Dictionary object returned from file_to_variables(f)
        
        headers_to_plot -- Header names in dictionary to plot over limits and errors. Can also pass an array of data to plot instead if it's
        the same size of arrays in the dictionary
        
        headers -- Python list returned from file_to_variables(f)
        
        scales -- Values to scale each data header by. 1 scalar value per 2 headers. If no scalars are passed, they default to 0
        
        toggleLimits -- 1 to display limits in the plot, 0 to not
        
        toggleErrors -- 1 to display errors, 0 to not
        
    Example function call:
        plot_tritium(dict, ['Runtime','MotorVelocity'], headers, [-1])
        
        In this case, we are plotting Runtime on the X, MotorVelocity on the Y. We also scale
        MotorVelocity by -1 to make the values positive. Since we don't specify limits or errors, they default to 1.
        Dict and headers are output variables from file_to_variables(f)
        
    Plot_tritium also offers the ability to plot data not in the dictionary. To do so, build you're own array and
    pass it in the "headers_to_plot" input. There should be an x array and y array inside of an array for the feature
    to work.
    '''
    
    limits = []
    errors = []
    limit_arrays = []    
    arrays_to_plot = []
    
    for header in headers_to_plot:
        if type(header).__module__ == np.__name__:
            arrays_to_plot.append(header)
        else:
            arrays_to_plot.append(dictionary[header])    

    i = 0        
    for scale in scales:
        arrays_to_plot[i+1] = arrays_to_plot[i+1] * scale
        i += 2
    
    for label in headers:
        if string.find(label,'limit') >= 0:
            limits.append(label)
        elif string.find(label,'error') >= 0:
            errors.append(label)
    
    errors.remove('error_watchdog')
    if toggleLimits == 1:
        for limit in limits:
            limit_arrays.append(dictionary[limit])
            
    if toggleErrors == 1:
        for error in errors:
            limit_arrays.append(dictionary[error])

    fig = plt.figure()
    ax = fig.add_subplot(1,1,1)    
    '''ax2 = ax.twiny()'''
    
    maxX, minX, maxY, minY = 0, 100000000, 0, 100000000
    totalArrays = np.shape(arrays_to_plot)[0]
    for i in xrange(0,totalArrays,2):
        if maxX < np.amax(arrays_to_plot[i]):
            maxX = max(arrays_to_plot[i]);
        if minX > np.amin(arrays_to_plot[i]):
            minX = min(arrays_to_plot[i]);
        if maxY < np.amax(arrays_to_plot[i+1]):
            maxY = max(arrays_to_plot[i+1]);
        if minY > np.amin(arrays_to_plot[i+1]):
            minY = min(arrays_to_plot[i+1]);

    lastErrorState = 0
    red,blue,green = 0,0,0

    w,h = 100, 50000
    
    data = np.zeros( (w,h,3), dtype=np.uint8)
    startOfColor, x = 0, 0

    customArtist = []
    '''If this isn't enough colors for future proofing, good luck'''
    colors = ['#00FF00','#0000FF','#FF0000','#01FFFE','#FFA6FE','#006401',
                  '#010067','#95003A','#007DB5','#FF00F6','#FFEEE8','#774D00',
                  '#90FB92','#0076FF','#D5FF00','#FF937E','#6A826C','#FF029D',
                  '#FE8900','#7A4782','#7E2DD2','#85A900','#FF0056','#A42400',
                  '#00AE7E','#683D3B','#BDC6FF','#263400','#BDD393','#00B917',
                  '#9E008E','#001544','#C28C9F','#FF74A3','#01D0FF','#004754',
                  '#E56FFE','#788231','#0E4CA1','#91D0CB','#BE9970','#968AE8',
                  '#BB8800','#43002C','#DEFF74','#00FFC6','#FFE502','#620E00',
                  '#008F9C','#98FF52','#7544B1','#B500FF','#00FF78','#FF6E41',
                  '#005F39','#6B6882','#5FAD4E','#A75740','#A5FFD2','#FFB167',
                  '#009BFF','#E85EBE']
    
    currentErrorState = 0
    redTone,blueTone,greenTone = 0,0,0
    data[:,:]= 255,255,255
    for i in xrange(0,np.shape(limit_arrays)[0],1):
        if currentErrorState == 1:
            data[:,startOfColor:x] = [redTone,greenTone,blueTone]
        
        redTone = int(colors[i][1:3], 16)
        greenTone = int(colors[i][3:5], 16)
        blueTone = int(colors[i][5:7], 16)
        startOfColor = 0
        x, counter = 0, 0
        lastErrorState = 0
        while counter < limit_arrays[i].size-1:
            currentErrorState = limit_arrays[i][counter]
            if currentErrorState == 1 and lastErrorState == 0:
                startOfColor = x

            if lastErrorState == 1 and currentErrorState == 0:
                data[:,startOfColor:x-1] = [redTone,greenTone,blueTone]

            lastErrorState = currentErrorState

            x += 50000.0/limit_arrays[i].size
            counter += 1
            
        customArtist.append(plt.Line2D((0,1),(0,0), color=colors[i], marker='None', alpha=1, linewidth=6))
    
    if currentErrorState == 1:
        data[:,startOfColor:x+2] = [redTone,greenTone,blueTone]


    scipy.misc.imsave('outfile.jpg', data)
    img = scipy.misc.imread('outfile.jpg')


    markers = itertools.cycle((',', '+', '.', 'o', '*'))
    colors = itertools.cycle(('b','g','r','c','m','y','k'))
    for i in xrange(0, totalArrays-1, 2):
        ax.plot(arrays_to_plot[i],arrays_to_plot[i+1], color=colors.next(), marker=markers.next(), label = headers_to_plot[i+1])
    
    plt.ylim([minY,maxY])
    plt.xlim([minX,maxX])
    '''
    ax2.set_xticks(dictionary['Runtime'])
    ax2.set_xlabel("Runtime")
    '''
    plt.imshow(img, aspect='auto', zorder=0, extent=[minX, maxX, minY, maxY], alpha=1)

    handles, labels = ax.get_legend_handles_labels()
    display = (0,1,2)

    if toggleLimits == 0:
        ax.legend([handle for i,handle in enumerate(handles) if i in display]+
          [artist for artist, artist in enumerate(customArtist)],
          [label for i,label in enumerate(labels) if i in display]+
          [error for error, error in enumerate(errors)],numpoints=1)     
    elif toggleErrors == 0:
        ax.legend([handle for i,handle in enumerate(handles) if i in display]+
          [artist for artist, artist in enumerate(customArtist)],
          [label for i,label in enumerate(labels) if i in display]+
          [limit for limit, limit in enumerate(limits)],numpoints=1) 
    elif toggleLimits == 0 and toggleErrors == 0:
        ax.legend([handle for i,handle in enumerate(handles) if i in display]+
          [artist for artist, artist in enumerate(customArtist)],
          [label for i,label in enumerate(labels) if i in display],numpoints=1) 
    else:
        ax.legend([handle for i,handle in enumerate(handles) if i in display]+
          [artist for artist, artist in enumerate(customArtist)],
          [label for i,label in enumerate(labels) if i in display]+
          [limit for limit, limit in enumerate(limits)]+
          [error for error, error in enumerate(errors)],numpoints=1)    
    
    plt.show()
    
    