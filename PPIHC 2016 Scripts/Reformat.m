% Load the PPIHC race data. Format it better.

clear; close all; clc

filename = input('Input file to be reformated: ', 's');

%% Parameters

% Race start and end time offsets, in seconds.
start_time		= 0;
end_time		= 60;

% Gearing correction factor
% [correct geared wheel diameter] = [wheel diameter programmed during race] * [gearing correction factor]
gear_correction		= 21/38;


%% Load input file and offset all time vectors
m			= matfile(filename);
temp		= whos(m);
variables	= {temp.name};

in			= load(filename);

% I am sorry for using a loop
for i = 1:numel(variables)
	% Skip this one if it's not a timeseries
	if ~isa( in.(variables{i}), 'timeseries' )
		continue;
	end
	
end


%% Group data channels into timeseries collections with common time vectors

powertrain_time_vector		= start_time:0.1:end_time;
rs							= @(ts) resample( ts, powertrain_time_vector );

% Powertrain
Powertrain.BatteryPack.BusCurrent				= rs(in.BusCurrent);
Powertrain.BatteryPack.BusVoltage				= rs(in.BusVoltage);
Powertrain.BatteryPack.MaxCellTemp				= rs(in.MaxCellTemp);

Powertrain.Inverter.BEMFd                       = rs(in.BEMFd);
Powertrain.Inverter.BEMFq                       = rs(in.BEMFq);
Powertrain.Inverter.DCBusAmpHours               = rs(in.DCBusAmpHours);
Powertrain.Inverter.MotorCurrentSetpoint        = rs(in.MotorCurrentSetpoint);
Powertrain.Inverter.Id                      	= rs(in.Id);
Powertrain.Inverter.Iq                          = rs(in.Iq);
Powertrain.Inverter.Vd                      	= rs(in.Vd);
Powertrain.Inverter.Vq                      	= rs(in.Vq);
Powertrain.Inverter.IPMPhaseATemp               = rs(in.IPMPhaseATemp);
Powertrain.Inverter.IPMPhaseBTemp               = rs(in.IPMPhaseBTemp);
Powertrain.Inverter.IPMPhaseCTemp           	= rs(in.IMPPhaseCTemp);		% sic (corrects typo)
Powertrain.Inverter.DSPBoardTemp                = rs(in.DSPBoardTemp);
    

% The "LimitFlags" variables need to be resampled with the 'zoh' method
% because they are basically Booleans.
Powertrain.Inverter.ErrorFlags          = resample(in.ErrorFlags, powertrain_time_vector, 'zoh');
Powertrain.Inverter.LimitFlags          = resample(in.LimitFlags, powertrain_time_vector, 'zoh');

Powertrain.Cooling.MotorInletTemp		= rs(in.MotorInletTemp);
Powertrain.Cooling.MotorOutletTemp		= rs(in.MotorOutletTemp);
Powertrain.Cooling.InverterInletTemp	= rs(in.InverterInletTemp);
Powertrain.Cooling.InverterOutletTemp	= rs(in.InverterOutletTemp);
Powertrain.Cooling.MotorCoolantFlow     = rs(in.MotorCoolantFlow);
Powertrain.Cooling.InverterCoolantFlow  = rs(in.InverterCoolantFlow);

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
Vehicle.WheelSpeedFront             = rs(in.WheelSpeedFront);
Vehicle.WheelSpeedRear              = rs(in.WheelSpeedRear);

