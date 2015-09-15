% sample script for plotting PPIHC limits
% abk, 2015-09

% If the 'Race.mat' file is not already on the MATLAB path, make sure it is
% added here.
addpath('/Users/abk/Dropbox/Documents/OSU/Buckeye Current/Testing/2015-06-xx Pikes Peak race');

% load race data
clear; clc; close all
%load 'Race.mat';
load 'PPIHC_15';			% re-structured race data

% Race start and end time offsets, in seconds.
race_start_time		= 0;
race_end_time		= 680.6;	% note: this is not perfectly precise

%% Construct limit timeseries
TimeVector = Powertrain.Controller.LimitFlags.Time;

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
%CurrentLimit.ThrottlePosition.Data	= CurrentLimit.ThrottlePosition.Data & ~CurrentLimit.BatteryTemperature.Data;

%% test plots
race_start_index	= find( TimeVector > 0, 1);
race_end_index		= find( TimeVector >= race_end_time, 1 );

figure(1); clf; hold on;

ax2 = subplot(311); hold on;
plot( Powertrain.Controller.LimitFlags.Data);

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

ax3 = subplot(313); hold on;
plot( Powertrain.Controller.MotorCurrentSetpoint.Data.*300, 'r' );
plot( Powertrain.Motor.PhaseCurrentB.Data, 'b' );

linkaxes( [ax1 ax2 ax3], 'x' );
xlim([ race_start_index, race_end_index ]);

				
title( 'PPIHC - motor current limiting over time' );

%% Stacked-area plot

% Use a moving average to provide a better high-level view of the limit
% behavior.
span	= 20;					% moving average window length, sec
span	= span/(TimeVector(2) - TimeVector(1));

CurrentLimitAvg							= CurrentLimit;
CurrentLimitAvg.Temperature.Data		= smooth(double(CurrentLimit.Temperature.Data), span);
CurrentLimitAvg.BusVoltageLower.Data	= smooth(double(CurrentLimit.BusVoltageLower.Data), span);
CurrentLimitAvg.BusVoltageUpper.Data	= smooth(double(CurrentLimit.BusVoltageUpper.Data), span);
CurrentLimitAvg.BusCurrent.Data			= smooth(double(CurrentLimit.BusCurrent.Data), span);
CurrentLimitAvg.Velocity.Data			= smooth(double(CurrentLimit.Velocity.Data), span);
CurrentLimitAvg.ThrottlePosition.Data	= smooth(double(CurrentLimit.ThrottlePosition.Data), span);
CurrentLimitAvg.OutputPWM.Data			= smooth(double(CurrentLimit.OutputPWM.Data), span);
CurrentLimitAvg.BatteryTemperature.Data	= smooth(double(CurrentLimit.BatteryTemperature.Data), span);


rows =  [	CurrentLimitAvg.ThrottlePosition.Data,		...
			CurrentLimitAvg.Temperature.Data,			...
			CurrentLimitAvg.BatteryTemperature.Data		...
			CurrentLimitAvg.OutputPWM.Data,				...
			CurrentLimitAvg.BusVoltageLower.Data,		...
			CurrentLimitAvg.BusVoltageUpper.Data,		...
			CurrentLimitAvg.BusCurrent.Data,			...
			CurrentLimitAvg.Velocity.Data,				...
			];
		
times = [	CurrentLimitAvg.ThrottlePosition.Time,		...
			CurrentLimitAvg.Temperature.Time,			...
			CurrentLimitAvg.BatteryTemperature.Time		...
			CurrentLimitAvg.OutputPWM.Time,				...
			CurrentLimitAvg.BusVoltageLower.Time,		...
			CurrentLimitAvg.BusVoltageUpper.Time,		...
			CurrentLimitAvg.BusCurrent.Time,			...
			CurrentLimitAvg.Velocity.Time,				...
			];
		
% Normalize so that each row sums up to 1
normalized = bsxfun(@rdivide,rows,sum(rows,2));

figure(2); clf; hold on;
h = area(times, normalized, 'LineStyle', 'none');
ylim([0 1]);
xlim([ race_start_time, race_end_time ]);

set(gca, 'ytick', []);		% Hide y-axis
xlabel('Race time (sec)');

title('Powertrain limits during PPIHC competition 2015');

% Pretty colors
h(1).FaceColor		= [110 235 131]/255;	% throttle = light green
h(1).DisplayName	= 'Throttle position';

h(2).FaceColor		= [254 95  85 ]/255;	% motor/controller temp = red
h(2).DisplayName	= 'Motor/MC temperature';

h(3).FaceColor		= [255 210 63]/255;		% battery temp = orange
h(3).DisplayName	= 'Battery temperature';

h(4).FaceColor		= [008 061 119]/255;	% PWM = dk blue
h(4).DisplayName	= 'DC bus voltage (PWM)';

h(5).FaceColor		= [27  231 255]/255;	% lower bus voltage = blue
h(5).DisplayName	= 'Lower bus voltage limit';

h(6).FaceColor		= [228 255 026]/255;	% upper bus voltage = yellow
h(6).DisplayName	= 'Upper bus voltage limit';

h(7).DisplayName	= 'Bus current';
h(8).DisplayName	= 'Vehicle velocity';

legend('show', 'Location', 'bestoutside');

%% Plot component temperatures with derating limits

% Battery derating 
pack_derating_ramp		= 55;	% "ramp" setpoint temperature for battery temp controller
pack_derating_cutoff		= 75;	% "cutoff" setpoint temp for ""

% Motor derating
motor_derating_ramp			= 105;	% "ramp" temperature, motor (??)
motor_derating_cutoff		= 120;

% Controller derating
mc_derating_ramp			= 75;	% totally made up right now
mc_derating_cutoff			= 85;	% totally made up right now

figure(3); clf;

% Motor temp
ax1 = subplot(311); hold on;
grid on;
title('Motor temperature');
plot(Powertrain.Motor.MotorTemp);
plot([race_start_time race_end_time], [motor_derating_ramp motor_derating_ramp], 'r');

ax1.YTick = motor_derating_ramp + (0:0.2:1).*(motor_derating_cutoff - motor_derating_ramp);
ax1.YTickLabel = {'100%', '80%', '60%', '40%', '20%', '0%'};

% Battery temp
ax2 = subplot(312); hold on;
grid on;
title('Battery pack temperature');
plot(Powertrain.Pack.MaxCellTemp);
plot([race_start_time race_end_time], [pack_derating_ramp pack_derating_ramp], 'r');

ax2.YTick = pack_derating_ramp + (0:0.2:1).*(pack_derating_cutoff - pack_derating_ramp);
ax2.YTickLabel = {'100%', '80%', '60%', '40%', '20%', '0%'};

% Controller temp
ax3 = subplot(313); hold on;
grid on;
title('Motor controller temperature');
plot(Powertrain.Controller.IPMPhaseATemp);
ylabel('

linkaxes([ax1 ax2 ax3], 'x');
xlim([race_start_time race_end_time]);



