% sample script for plotting PPIHC limits
% abk, 2015-09

% If the 'Race.mat' file is not already on the MATLAB path, make sure it is
% added here.
addpath('/Users/abk/Dropbox/Documents/OSU/Buckeye Current/Testing/2015-06-xx Pikes Peak race');

% load race data
clear; clc; close all
%load 'Race.mat';
load 'PPIHC_15';			% re-structured race data

%% Construct limit timeseries
CurrentLimit.Temperature			= timeseries((Powertrain.Controller.LimitFlags.Data == 2^6), Powertrain.Controller.LimitFlags.Time);
CurrentLimit.BusVoltageLower		= timeseries((Powertrain.Controller.LimitFlags.Data == 2^5), Powertrain.Controller.LimitFlags.Time);
CurrentLimit.BusVoltageUpper		= timeseries((Powertrain.Controller.LimitFlags.Data == 2^4), Powertrain.Controller.LimitFlags.Time);
CurrentLimit.BusCurrent				= timeseries((Powertrain.Controller.LimitFlags.Data == 2^3), Powertrain.Controller.LimitFlags.Time);
CurrentLimit.Velocity				= timeseries((Powertrain.Controller.LimitFlags.Data == 2^2), Powertrain.Controller.LimitFlags.Time);
CurrentLimit.MotorCurrent			= timeseries((Powertrain.Controller.LimitFlags.Data == 2^1), Powertrain.Controller.LimitFlags.Time);
CurrentLimit.OutputPWM				= timeseries((Powertrain.Controller.LimitFlags.Data == 2^0), Powertrain.Controller.LimitFlags.Time);

% The battery temperature limit only has an effect when the Tritium
% "MotorCurrent" limit is active.
CurrentLimit.BatteryTemperature			= Powertrain.Controller.BatteryLimit;
CurrentLimit.BatteryTemperature.Data	= CurrentLimit.BatteryTemperature.Data & CurrentLimit.MotorCurrent.Data;

% Similarly, the "ThrottlePosition" limit (i.e., motor current limited only
% by throttle position) is only effective when the battery temperature limit
% is not in effect.
CurrentLimit.ThrottlePosition		= timeseries((Powertrain.Controller.LimitFlags.Data == 2^1), Powertrain.Controller.LimitFlags.Time);		% MotorCurrent
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