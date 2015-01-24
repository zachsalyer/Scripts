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
[result, fit] = sync_logfiles( can_ts, dyno_ts )

%TODO: check that the union is a significant proportion of the total data
% size
%% display results
 
% update timeseries
can_ts.Time = can_ts.Time + result;

%% try to sync with xcorr
[v1 v2] = synchronize( can_ts, dyno_ts, 'Uniform', 'Interval', 0.01 );

[xc, lags] = xcorr(v1.Data, v2.Data);
[m,i] = max(xc);
offset = lags(i)*0.01;

% new synchronized timeseries
v1_sync = v1;
v1_sync.Time = v1_sync.Time - offset;


figure(2);
clf

% plot signals before
subplot(311)
hold on
plot(v1, 'r');
plot(v2);

subplot(312)
hold on;
plot(lags,xc(1:end))

subplot(313)
hold on;
plot(v1_sync, 'r');
plot(v2)

%% display actually
figure(1);
clf

ax1 = subplot(211);
hold on;
plot(can_ts, 'r');
plot(dyno_ts);
legend('Tritium', 'Dyno');

ax2 = subplot(212);
[t1 t2] = synchronize(can_ts, dyno_ts, 'Union', 'KeepOriginalTimes', false);
plot( t2.Data-t1.Data);

hold off;

%linkaxes([ax1,ax2],'x');