# -*- coding: utf-8 -*-
"""
Created on Wed Mar 12 19:40:52 2014

@author: Sean
"""

import numpy as np
import collections

def file_to_variables(f):
    '''
    Takes in a log file with comma seperated values and converts to a
    easy to use dictionary.
    
    Inputs:
        f -- File name of log file to read
        
    Returns:
        dict_keys -- Python list of keys for the dictionary
        dictionary -- Dictionary sturcture holding data parsed from file
    '''
    
    headersParsed = 0;
    filename = f;
    elementsPerRow = 0;
    print "Opening and reading from ", filename
    
    dictionary = collections.OrderedDict()
    with open(f) as infile:
        for line in infile:
            # if CANCorder log, there is an exact ','. Remove that entry
            dataList = line.split(",")
            if dataList[-1] == '\n':
                del dataList[-1]
                
            if headersParsed == 0:
                elementsPerRow = np.shape(dataList)[0]
                for header in dataList[:]:
                    # Add header to dictionary with empty list
                    key = header.split()[0]
                    dictionary.setdefault(key, []);
                dict_keys = dictionary.keys()
                headersParsed = 1
            else:
                # Check to make sure the current line isn't missing a value
                if (np.shape(dataList)[0] == elementsPerRow):    
                    currentKey = 0;
                    for data in dataList[:]:
                        try:
                            value = data.rstrip();
                            dictionary[dict_keys[currentKey]].append(value)
                        except:
                            dictionary[dict_keys[currentKey]].append(data.strip())
                            
                        currentKey += 1;
                                    
    currentKey = 0
    for value in dictionary.itervalues():
        dictionary[dict_keys[currentKey]] = np.array(value, np.str, copy=False)
        try:
            dictionary[dict_keys[currentKey]] = dictionary[dict_keys[currentKey]].astype(np.float32)
        except:
            pass

        currentKey += 1
    
    # Print log statistics if CANCorder log.
    if 'Runtime' in dictionary:
        runtime = dictionary['Runtime']
        diff = np.diff(runtime)
        average = np.average(diff)
        print "Average datalog interval: " + np.str(average)
        print "Datalogging error: " + np.str(np.round((average/(1.0/3.0)) * 100.0, 3)) + "%"
    
    return (dict_keys, dictionary)