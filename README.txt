====================
Script Documentation
====================
This README contains information about what is contained in each script file, what
it does, and how to call/use the function.

Data Analysis Scripts
=====================
These scripts are meant to be used with log files created by the CANCorder.

***IMPORTANT NOTE***
Many of these scripts rely on the dictionary variable returned by file_to_variables
to be called "dict". See file_to_variables example on proper procedure for obtaining
this variable.

	Python Scripts
		- file_to_variables.py
			Contains a single function which takes in a log file in .csv format 
			(Specifically CANCorder CSV file which has an extra comma after the 
			last entry in a row) and outputs the data in the file in a dictionary
			along with a array of possible keys for the dictionary
			
			Example 
				keys, dict = file_to_variables("log1.csv")
				Look through the keys array to find the data to want to work with.
				In this case I'll choose "MotorTemp". 
				To view MotorTemp data in this case: dict['MotorTemp']
				
			This function will also output information involving the error in
			data for the log. This error is based off the times between rows. The
			higher the error, the higher the data loss or data not recorded/missed
		
		- plot_tritium.py
		
			Contains a single function which plots data over top of errors and
			limits found in the dictionary file passed in as an input. This
			function has a lot of flexibility. It has the capability of plotting
			multiple variables on the same x axis and multiple variables on the
			same y axis. Errors and limits can be toggled on and off if one or
			both don't want to be seen.
			
			plot_tritium(dictionary, headers_to_plot, headers, scales = [],
			toggleLimits = 1, toggleErrors = 1):
			Inputs:
				- dictionary -- Dictionary object returned from file_to_variables(f)
				- headers_to_plot -- Header names in dictionary to plot over limits and 
				  errors. Can also pass an array of data to plot instead if it's the same 
				  size as arrays in the dictionary
				- headers -- Python list returned from file_to_variables(f)
				- scales -- Values to scale each data header by. 1 scalar value per 2 
				  headers. If no scalars are passed, they default to 0
				- toggleLimits -- 1 to display limits in the plot, 0 to not
				- toggleErrors -- 1 to display errors, 0 to not
			
			Example function call where dict is a variable returned from
			file_to_variables and 'Runtime', 'MotorVelocity', and 'MotorTemp' are
			keys in the dictionary:
				plot_tritium(dict, ['Runtime','MotorVelocity','Runtime','MotorTemp'], keys, [-1,1])
			
			In this case, we are passing in 'dict' which is the dictionary returned by
			file_to_variables, an array of keys from the dictionary we want to plot in 
			[X1, Y1, X2, Y2] format, the list of keys returned from file_to_variables,
			and a scale you want to perform on each XY pair passed.
			We are plotting Runtime vs. MotorVelocity and MotorTemp and inverting the
			Runtime vs. MotorVelocity line that is plotted.
			
		- datalogging_delays.py
			Plots the difference in runtime values between each row in the log file.
			
		- gps_location.py
			3D plot of where the motorcycle travelled. VERY NEAT IF GPS DOESN'T DROP.
			
		- heartbeats.py
			Quick method of determining if any of the CAN nodes dropped off the bus.
			If all the heartbeats stop rising at once, that means the CANCorder dropped
			off the bus and did not put itself back on.
		
		- polinas_script.py
			Script made for the plot that Polina always wanted to see during testing.
			Plots MotorTemp as blue, Power as red, MotorVelocity as green.
			
		- rpm_current.py
			Plots runtime vs MotorVelocity and throttle input using tritium_plot. As a
			note, the legend may get in the way due to how the data is passed in. Requires
			the keys passed from file_to_variables to be named "headers"
			
		- runtime_heartbeat.py
			Better script to use to determine if the heartbeats stopped for any CAN nodes.
			Graphs times vs heartbeats so that the exact drop time can be seen.
			
		- scoop_pressure.py
			A script which plots the pressure in the motor scoop and the current motor
			velocity.
			
		- thermal_limit.py
			Used to determine if there was a thermal limit and at what motor speed and
			temp. Uses samples instead of runtime since there is a slight offset when
			using runtime as X.
		
		- Fit_to_model_demo.py
			Simply a demo showing how the curve_fit function works.
			
		- Aero_model.py
			Script that displays the aero model for a run.
			
		- thermal_model.py
			Displays the thermal model for a particular run or multiple runs.
	MATLAB Scripts
	These scripts currently may or may not work due to issues with MATLAB reading in large
	CSV files.
		- file_to_variables.m
			Identical to the Python script.
			
		- plot_tritium.m
			Identical to the Python script.
			