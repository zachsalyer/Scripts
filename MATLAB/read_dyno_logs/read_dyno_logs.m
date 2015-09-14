% Read in the various data files associated with testing, then assemble
% them into one, better data file

% This script expects that the MATLAB functions read_ni_DAQ_Log() and
% sync_timeseries() are on the MATLAB path.

%% Paths for input and output files
input_kvaser	= '1-23-Test002.mat';
input_daq		= '1-23_dyno_daq_log2.csv';

%% Read input files
[ dynoRPM, dynoTorque ] = read_NI_DAQ_Log( input_daq );
[ kvaserMap, kvaserHeader ] = Kvaser_Mat( input_kvaser );

%% Synchronize the times
kvaserRPM = kvaserMap('MotorVelocit');

% Tritium speed is backwards (Australian RPM)
kvaserRPM.ts.Data = kvaserRPM.ts.Data*(-1);
% Save it back to the map for convenience
kvaserMap('MotorVelocit') = kvaserRPM;
kvaserRPM = kvaserRPM.ts;

% The Kvaser MATfiles seem to set their start times at the time the script
% was run, NOT the absolute time. We will assume that the absolute time in
% the DAQ timeseries is correct.
offset = sync_timeseries( dynoRPM, kvaserRPM );

for x = kvaserHeader
	index = x{1};
	item = kvaserMap(index);
	
	% Setting the TimeInfo.StartDate parameter would be a sensible way to
	% do this (and faster), but it appears not to be widely implemented in 
	% other MATLAB functions.
	item.ts.Time = item.ts.Time + offset;
	
	%new_start = datenum(item.ts.TimeInfo.StartDate) + offset/3600/24;
	%itemts.TimeInfo.StartDate = datestr( new_start );
	
	kvaserMap(index) = item;
end

clear index x offset new_start ts kvaserRPM;