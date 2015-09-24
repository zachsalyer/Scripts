% Load the PPIHC race data. Format it better.

clear all; close all; clc

% If the 'Race.mat' file is not already on the MATLAB path, make sure it is
% added here.
addpath('/Users/abk/Dropbox/Documents/OSU/Buckeye Current/Testing/2015-06-xx Pikes Peak race');

%% Parameters

% Race start and end time offsets, in seconds.
race_start_time		= 166.9;
race_end_time		= 847.1;	% note: this is not perfectly precise

% Gearing correction factor
% [correct geared wheel diameter] = [wheel diameter programmed during race] * [gearing correction factor]
gear_correction		= 21/38;


%% Load input file and offset all time vectors
m			= matfile('Race.mat');
temp		= whos(m);
variables	= {temp.name};

in			= load('Race.mat');

% I am sorry for using a loop
for i = 1:numel(variables)
	% Skip this one if it's not a timeseries
	if ~isa( in.(variables{i}), 'timeseries' )
		continue;
	end
	
	% Set time zero to race start time
	in.(variables{i}).Time = in.(variables{i}).Time - race_start_time;
	
	% Discard points after race end + 30 sec
	race_end_index = find( in.(variables{i}).Time > race_end_time + 30, 1);
	
	if( ~isempty(race_end_index) )
		in.(variables{i}) = delsample( in.(variables{i}), 'Index', race_end_index:length(in.(variables{i}).Time) );
	end
end

%% Apply gear ratio corrections to variables that need them

in.VehicleVelocity	= in.VehicleVelocity * gear_correction;
in.Odometer			= in.Odometer * gear_correction;

%% Group data channels into timeseries collections with common time vectors

powertrain_time_vector		= -race_start_time+10:0.1:race_end_time+15;
rs							= @(ts) resample( ts, powertrain_time_vector );

% Powertrain
Powertrain.BMS.BIM1AvgCellVoltage		= rs(in.BIM1AvgCellVoltage);
Powertrain.BMS.BIM2AvgCellVoltage		= rs(in.BIM2AvgCellVoltage);
Powertrain.BMS.BIM3AvgCellVoltage		= rs(in.BIM3AvgCellVoltage);
Powertrain.BMS.BIM4AvgCellVoltage		= rs(in.BIM4AvgCellVoltage);
Powertrain.BMS.BIM5AvgCellVoltage		= rs(in.BIM5AvgCellVoltage);

Powertrain.BMS.BIM1MaxCellVoltage		= rs(in.BIM1MaxCellVoltage);
Powertrain.BMS.BIM2MaxCellVoltage		= rs(in.BIM2MaxCellVoltage);
Powertrain.BMS.BIM3MaxCellVoltage		= rs(in.BIM3MaxCellVoltage);
Powertrain.BMS.BIM4MaxCellVoltage		= rs(in.BIM4MaxCellVoltage);
Powertrain.BMS.BIM5MaxCellVoltage		= rs(in.BIM5MaxCellVoltage);

Powertrain.BMS.BIM1MaxCellNumber		= rs(in.BIM1MaxCellNumber);
Powertrain.BMS.BIM2MaxCellNumber		= rs(in.BIM2MaxCellNumber);
Powertrain.BMS.BIM3MaxCellNumber		= rs(in.BIM3MaxCellNumber);
Powertrain.BMS.BIM4MaxCellNumber		= rs(in.BIM4MaxCellNumber);
Powertrain.BMS.BIM5MaxCellNumber		= rs(in.BIM5MaxCellNumber);

Powertrain.BMS.BIM1MinCellVoltage		= rs(in.BIM1MinCellVoltage);
Powertrain.BMS.BIM2MinCellVoltage		= rs(in.BIM2MinCellVoltage);
Powertrain.BMS.BIM3MinCellVoltage		= rs(in.BIM3MinCellVoltage);
Powertrain.BMS.BIM4MinCellVoltage		= rs(in.BIM4MinCellVoltage);
Powertrain.BMS.BIM5MinCellVoltage		= rs(in.BIM5MinCellVoltage);

Powertrain.BMS.BIM1MinCellNumber		= rs(in.BIM1MinCellNumber);
Powertrain.BMS.BIM2MinCellNumber		= rs(in.BIM2MinCellNumber);
Powertrain.BMS.BIM3MinCellNumber		= rs(in.BIM3MinCellNumber);
Powertrain.BMS.BIM4MinCellNumber		= rs(in.BIM4MinCellNumber);
Powertrain.BMS.BIM5MinCellNumber		= rs(in.BIM5MinCellNumber);

Powertrain.BMS.BIM1AvgCellVoltage		= rs(in.BIM1AvgCellVoltage);
Powertrain.BMS.BIM2AvgCellVoltage		= rs(in.BIM2AvgCellVoltage);
Powertrain.BMS.BIM3AvgCellVoltage		= rs(in.BIM3AvgCellVoltage);
Powertrain.BMS.BIM4AvgCellVoltage		= rs(in.BIM4AvgCellVoltage);
Powertrain.BMS.BIM5AvgCellVoltage		= rs(in.BIM5AvgCellVoltage);

Powertrain.BMS.BIM1StdDevVoltage	= rs(in.BIM1StdDevVoltage);
Powertrain.BMS.BIM2StdDevVoltage	= rs(in.BIM2StdDevVoltage);
Powertrain.BMS.BIM3StdDevVoltage	= rs(in.BIM3StdDevVoltage);
Powertrain.BMS.BIM4StdDevVoltage	= rs(in.BIM4StdDevVoltage);
Powertrain.BMS.BIM5StdDevVoltage	= rs(in.BIM5StdDevVoltage);

Powertrain.Pack.BusCurrent				= rs(in.BusCurrent);
Powertrain.Pack.BusVoltage				= rs(in.BusVoltage);
Powertrain.Pack.MaxCellTemp				= rs(in.MaxCellTemp);

% ugly save-typing hack
for i = 1:36;
	eval( ['Powertrain.Pack.CellTemp' num2str(i) '	= rs(in.CellTemp' num2str(i) ')'] );
end

Powertrain.Controller.BEMFd					= rs(in.BEMFd);
Powertrain.Controller.BEMFq					= rs(in.BEMFq);
Powertrain.Controller.DCBusAmpHours			= rs(in.DCBusAmpHours);
Powertrain.Controller.MotorCurrentSetpoint	= rs(in.MotorCurrentSetpoint);
Powertrain.Controller.Id					= rs(in.Id);
Powertrain.Controller.Iq					= rs(in.Iq);
Powertrain.Controller.Vd					= rs(in.Vd);
Powertrain.Controller.Vq					= rs(in.Vq);
Powertrain.Controller.RawThrottle			= rs(in.RawThrottle);
Powertrain.Controller.ThrottleLock			= rs(in.ThrottleLock);
Powertrain.Controller.IPMPhaseATemp			= rs(in.IPMPhaseATemp);
Powertrain.Controller.IPMPhaseBTemp			= rs(in.IPMPhaseBTemp);
Powertrain.Controller.IPMPhaseCTemp			= rs(in.IMPPhaseCTemp);		% sic (corrects typo)
Powertrain.Controller.DSPBoardTemp			= rs(in.DSPBoardTemp);

% The "LimitFlags" variables need to be resampled with the 'zoh' method
% because they are basically Booleans.
Powertrain.Controller.BatteryLimit		= resample(in.BatteryLimit, powertrain_time_vector, 'zoh');
Powertrain.Controller.ErrorFlags		= resample(in.ErrorFlags, powertrain_time_vector, 'zoh');
Powertrain.Controller.LimitFlags		= resample(in.LimitFlags, powertrain_time_vector, 'zoh');

Powertrain.Cooling.RadiatorCoolantTemp		= rs(in.RadiatorCoolantTemp);
Powertrain.Cooling.ControllerCoolantTemp	= rs(in.ControllerCoolantTemp);
Powertrain.Cooling.MotorCoolantTemp			= rs(in.MotorCoolantTemp);
Powertrain.Cooling.CoolantFlow				= rs(in.CoolantFlow);

Powertrain.Motor.MotorTemp				= rs(in.MotorTemp);
Powertrain.Motor.MotorVelocity			= rs(in.MotorVelocity);
Powertrain.Motor.PhaseCurrentB			= rs(in.PhaseCurrentB);
Powertrain.Motor.PhaseCurrentC			= rs(in.PhaseCurrentC);

% Vehicle channels
Vehicle.GPS.Longitude				= rs(in.Longitude);
Vehicle.GPS.Latitude				= rs(in.Latitude);
Vehicle.GPS.GPSValid				= rs(in.GPSvalid);
Vehicle.GPS.PDOP					= rs(in.PDOP);
Vehicle.GPS.GPSVelocity				= rs(in.Speed);
Vehicle.GPS.Altitude				= rs(in.Altitude);
Vehicle.Velocity					= rs(in.VehicleVelocity);
Vehicle.Odometer					= rs(in.Odometer);
Vehicle.AmbientTemperature			= rs(in.AmbientTemp);

%% Export the modified data
save( 'PPIHC_15', 'Powertrain', 'Vehicle' );