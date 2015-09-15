% sample script for plotting PPIHC limits
% abk, 2015-09

% If the 'Race.mat' file is not already on the MATLAB path, make sure it is
% added here.


% load race data
clear; clc; close all
load 'Race.mat';

%% Race parameters.

% Race start and end time offsets, in seconds.
race_start_time		= 166.9;
race_end_time		= 847.1;	% note: this is not perfectly precise


% Re-index the timeseries so that 0 = race start
% Later, this should be done automatically
MotorVelocity.Time			= MotorVelocity.Time - race_start_time;
VehicleVelocity.Time		= VehicleVelocity.Time - race_start_time;
LimitFlags.Time				= LimitFlags.Time - race_start_time;
MaxCellTemp.Time			= MaxCellTemp.Time - race_start_time;
MotorCurrentSetpoint.Time	= MotorCurrentSetpoint.Time - race_start_time;
PhaseCurrentB.Time			= PhaseCurrentB.Time - race_start_time;
BusVoltage.Time				= BusVoltage.Time - race_start_time;
Odometer.Time				= Odometer.Time - race_start_time;

%% Construct limit timeseries

% Resample limit vectors to common time vector
% TODO: This should be done in an outside function
CommonTime.step		= 0.1;		% seconds
CommonTime.min		= max( min(LimitFlags.Time), min(BatteryLimit.Time) );

%CommonTime.max		= min( max(LimitFlags.Time), max(BatteryLimit.Time) );
CommonTime.max		= race_end_time+2;		% TEMPORARY HACK

CommonTime.vector	= CommonTime.min:CommonTime.step:CommonTime.max;

LimitFlagsOrig		= LimitFlags;
LimitFlags			= resample( LimitFlags, CommonTime.vector, 'zoh' );
BatteryLimit		= resample( BatteryLimit, CommonTime.vector, 'zoh' );
BusVoltage			= resample( BusVoltage, CommonTime.vector, 'zoh' );
MotorCurrentSetpoint = resample( MotorCurrentSetpoint, CommonTime.vector, 'zoh' );
PhaseCurrentB		= resample( PhaseCurrentB, CommonTime.vector, 'zoh' );


CurrentLimit.Temperature			= timeseries((LimitFlags.Data == 2^6), CommonTime.vector);
CurrentLimit.BusVoltageLower		= timeseries((LimitFlags.Data == 2^5), CommonTime.vector);
CurrentLimit.BusVoltageUpper		= timeseries((LimitFlags.Data == 2^4), CommonTime.vector);
CurrentLimit.BusCurrent				= timeseries((LimitFlags.Data == 2^3), CommonTime.vector);
CurrentLimit.Velocity				= timeseries((LimitFlags.Data == 2^2), CommonTime.vector);
CurrentLimit.MotorCurrent			= timeseries((LimitFlags.Data == 2^1), CommonTime.vector);
CurrentLimit.OutputPWM				= timeseries((LimitFlags.Data == 2^0), CommonTime.vector);

% The battery temperature limit only has an effect when the Tritium
% "MotorCurrent" limit is active.
CurrentLimit.BatteryTemperature			= BatteryLimit;
CurrentLimit.BatteryTemperature.Data	= CurrentLimit.BatteryTemperature.Data & CurrentLimit.MotorCurrent.Data;

% Similarly, the "ThrottlePosition" limit (i.e., motor current limited only
% by throttle position) is only effective when the battery temperature limit
% is not in effect.
CurrentLimit.ThrottlePosition		= timeseries((LimitFlags.Data == 2^1), CommonTime.vector);		% MotorCurrent
CurrentLimit.ThrottlePosition.Data	= CurrentLimit.ThrottlePosition.Data & ~CurrentLimit.BatteryTemperature.Data;

% Use a moving average to provide a better high-level view of the limit
% behavior.
span	= 10;					% moving average window length, sec
span	= span/CommonTime.step;

CurrentLimitAvg							= CurrentLimit;
CurrentLimitAvg.Temperature.Data		= smooth(double(CurrentLimit.Temperature.Data), span);
CurrentLimitAvg.BusVoltageLower.Data	= smooth(double(CurrentLimit.BusVoltageLower.Data), span);
CurrentLimitAvg.BusVoltageUpper.Data	= smooth(double(CurrentLimit.BusVoltageUpper.Data), span);
CurrentLimitAvg.BusCurrent.Data			= smooth(double(CurrentLimit.BusCurrent.Data), span);
CurrentLimitAvg.Velocity.Data			= smooth(double(CurrentLimit.Velocity.Data), span);
CurrentLimitAvg.ThrottlePosition.Data	= smooth(double(CurrentLimit.ThrottlePosition.Data), span);
CurrentLimitAvg.OutputPWM.Data			= smooth(double(CurrentLimit.OutputPWM.Data), span);
CurrentLimitAvg.BatteryTemperature.Data	= smooth(double(CurrentLimit.BatteryTemperature.Data), span);

%% Compare original limit data to resampled
CurrentLimitOrig.Temperature			= timeseries((LimitFlagsOrig.Data == 2^6), LimitFlagsOrig.Time);
CurrentLimitOrig.BusVoltageLower		= timeseries((LimitFlagsOrig.Data == 2^5), LimitFlagsOrig.Time);
CurrentLimitOrig.BusVoltageUpper		= timeseries((LimitFlagsOrig.Data == 2^4), LimitFlagsOrig.Time);
CurrentLimitOrig.BusCurrent				= timeseries((LimitFlagsOrig.Data == 2^3), LimitFlagsOrig.Time);
CurrentLimitOrig.Velocity				= timeseries((LimitFlagsOrig.Data == 2^2), LimitFlagsOrig.Time);
CurrentLimitOrig.MotorCurrent			= timeseries((LimitFlagsOrig.Data == 2^1), LimitFlagsOrig.Time);
CurrentLimitOrig.OutputPWM				= timeseries((LimitFlagsOrig.Data == 2^0), LimitFlagsOrig.Time);

CurrentLimitOrig.OutputPWM		= CurrentLimitOrig.OutputPWM.setinterpmethod('zoh');
CurrentLimit.OutputPWM			= CurrentLimit.OutputPWM.setinterpmethod('zoh');

figure(5); clf; hold on;
ax1 = subplot(311);
plot( CurrentLimitOrig.OutputPWM, '-*' );
plot( CurrentLimit.OutputPWM, '-*' );

ax2 = subplot(312); hold on;
plot( BusVoltage );

ax3 = subplot(313); hold on;
plot( MotorCurrentSetpoint.*300, 'r' );
plot( PhaseCurrentB, 'b' );

linkaxes([ax1 ax2 ax3], 'x');
%xlim([race_start_time race_end_time]);
xlim([190 210]);

%% test plots
race_start_index	= find( CommonTime.vector > 0, 1);
race_end_index		= find( CommonTime.vector >= race_end_time, 1 );

figure(1); clf; hold on;
ax1 = subplot(312); hold on;
imagesc( ~[	CurrentLimit.Temperature.Data';			...
			CurrentLimit.BusVoltageLower.Data';		...
			CurrentLimit.BusVoltageUpper.Data';		...
			CurrentLimit.BusCurrent.Data';			...
			CurrentLimit.Velocity.Data';			...
			CurrentLimit.ThrottlePosition.Data';	...
			CurrentLimit.OutputPWM.Data';			...
			CurrentLimit.BatteryTemperature.Data' ]);
colormap('gray');

% Label each bar
ax = gca;
ax.YTick		= 1:8;
ax.YTickLabel	= {	'Motor/MC temperature',	...
					'Bus voltage min',		...
					'Bus voltage max',		...
					'Bus current max',		...
					'Velocity',				...
					'Throttle',				...
					'PWM',					...
					'Battery temperature'	};
				
ax.XTick		= [race_start_index race_end_index];
ax.XTickLabel	= {'Race start', 'Race end'};

ax2 = subplot(311); hold on;
plot( BusVoltage.Data );

ax3 = subplot(313); hold on;
plot( MotorCurrentSetpoint.Data.*300, 'r' );
plot( PhaseCurrentB.Data, 'b' );

linkaxes( [ax1 ax2 ax3], 'x' );
xlim([ race_start_index, race_end_index ]);

				
title( 'PPIHC - motor current limiting over time' );

figure(2); clf; hold on;
area( [		CurrentLimitAvg.Temperature.Data;			...
			CurrentLimitAvg.BusVoltageLower.Data;		...
			CurrentLimitAvg.BusVoltageUpper.Data;		...
			CurrentLimitAvg.BusCurrent.Data;			...
			CurrentLimitAvg.Velocity.Data;				...
			CurrentLimitAvg.ThrottlePosition.Data;		...
			CurrentLimitAvg.OutputPWM.Data;				...
			CurrentLimitAvg.BatteryTemperature.Data ]);

xlim([ race_start_index, race_end_index ]);

%% Compare the original and resampled data


%% temp
figure(3); clf; hold on;
plot(CurrentLimitAvg.Temperature);
plot(CurrentLimitAvg.ThrottlePosition);

figure(4); clf; hold on;
ax1 = subplot(211); plot(Odometer);
ax2 = subplot(212); plot(VehicleVelocity);

linkaxes([ax1 ax2],'x');
xlim([race_start_time race_end_time+10]);