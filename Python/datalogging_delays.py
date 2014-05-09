# -*- coding: utf-8 -*-
"""
Created on Mon Mar 24 22:12:02 2014

@author: Sean
"""

runtime = dict['Runtime']
diff = np.diff(runtime)
plot(runtime[1:],diff)