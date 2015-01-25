% Find the time offset between two datasets by matching a common timeseries
% between them - demo

%% Choose files and import
[dyno_filename, dyno_pathname] = uigetfile('*.csv', 'Choose file from dyno datalogging...')
[can_filename, can_pathname] = uigetfile('', 'Choose file from CAN bus datalogging...')

%FIXME: this breaks if the last line of the CSV does not have all the
%variables
dyno = readtable( fullfile(dyno_pathname, dyno_filename) );

% Create dyno CAN timeseries
dyno_time = datenum( dyno.Time , 'yyyy-mm-dd HH:MM:SS.FFF' );
dyno_time = 24*3600*(dyno_time - dyno_time(1));
dyno_ts = timeseries(dyno.RPM, dyno_time);
dyno_ts.TimeInfo.StartDate = dyno.Time(1);

% Create Kvaser CAN timeseries
load( fullfile( can_pathname, can_filename ), 'map');

% TEMPORARY UGLY HACKS
can_ts = map('MotorVelocit');
can_ts = can_ts.ts;
can_ts.Data = can_ts.Data*(-1);


%% processing

% do it
result = sync_timeseries( can_ts, dyno_ts );

%% display results
 
% update timeseries
dyno_sync = dyno_ts;
dyno_sync.Time = dyno_sync.Time + result;

figure(1);
clf

ax1 = subplot(211);
hold on;
plot(can_ts, 'r');
plot(dyno_ts);
title('Before sync')
xlabel('Time (sec)');
legend('Tritium', 'Dyno');

ax2 = subplot(212);
hold on;
plot(can_ts, 'r');
plot(dyno_sync);
title('After sync')
xlabel('Time (sec)');
legend('Tritium', 'Dyno');

text(max( max(can_ts.Time), max(dyno_sync.Time))/3, max(can_ts.Data)/2, ['Offset: ' num2str(result) ' sec'])

hold off;

linkaxes([ax1,ax2],'x');