# Kvaser_Mat.m #

Takes in the Kvaser given mat file and creates a more useful mat file

### user must: ###

- Change both "file" and "matname" variables to the input file and the mat file the script outputs respectively
- Put the input file in the same directory of the script

### output:
- map: a Map.Container. This is like a dictionary with the keys being the signal names.
	-  Each value is a structure with the following fields
		-  ts: signal timeseries 
		-  name: signal name (string)
		-  time: signal time (array)
		-  value: signal value (array) 
	- example:
		- `map('BEMFd').ts `
		- outputs the BEMFd signal time series
- headers: cell array of strings with all the keys of map