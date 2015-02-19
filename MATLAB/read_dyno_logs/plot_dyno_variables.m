% Plot some interesting variables after datalogging
% Run read_dyno_logs.m before you use this script

%% Test with a fun plot
% NOTHING GOOD HAPPENS AFTER THIS.

figure(1)
clf

% motor speed
ax1 = subplot(221);
hold on;
plot( dynoRPM , 'r');
plot( kvaserMap('MotorVelocit').ts );
legend( 'Dyno', 'Tritium' );
title( 'Shaft speed' );
ylabel( 'Shaft speed (RPM)' );
hold off;

ax3 = subplot(223);

% Calculate powers
DynoPower = dynoTorque .* (dynoRPM/60*2*pi);

% The timeseries data vectors will be different lengths if the log was
% truncated when one was received but not the other. Synchronize 

[Id Iq] = synchronize(kvaserMap('Id').ts, kvaserMap('Iq').ts, 'Uniform', 'Interval', 0.2);
[Id Vq] = synchronize(kvaserMap('Id').ts, kvaserMap('Vq').ts, 'Uniform', 'Interval', 0.2);
[Id Vd] = synchronize(kvaserMap('Id').ts, kvaserMap('Vd').ts, 'Uniform', 'Interval', 0.2);

%MotorPower = Id;
%MotorCurrent = sqrt(Id.Data.^2 + Iq.Data.^2);
%MotorVoltage = sqrt(Vd.Data.^2 + Vq.Data.^2);
%MotorPower.Data = MotorCurrent .* MotorVoltage;

MotorPower = (3/2)*(Vd*Id + Vq*Iq);

BusPower = kvaserMap('BusCurrent').ts .* kvaserMap('BusVoltage').ts;
hold on;
plot(BusPower/1000);
plot(MotorPower/1000, 'g');
plot(DynoPower/1000, 'r');
ylabel('Power (kW)');

legend('Bus power', 'Motor power', 'Dyno power');
hold off;

ax4 = subplot(224);
hold on;
[mpower bpower] = synchronize(MotorPower, BusPower, 'Uniform', 'Interval', 0.01);
plot(mpower / bpower, 'r');

[dpower mpower] = synchronize(DynoPower, MotorPower, 'Union', 'KeepOriginalTimes', false);
dpower = resample( dpower, 0:0.01:dpower.Time(end) );
mpower = resample( mpower, 0:0.01:mpower.Time(end) );
plot(dpower / mpower, 'g');

[dpower bpower] = synchronize(DynoPower, BusPower, 'Uniform', 'Interval', 0.01);
plot(dpower / bpower, 'b');

legend('WS200 efficiency', 'Motor efficiency', 'Powertrain efficiency', 'Location', 'NorthWest');

axis( [0 1 -0.1 1.1] );

linkaxes([ax1 ax2 ax3 ax4], 'x');

%FIXME: Timeseries plotted while the plot is held do not automatically
%scale axes to StartDate
ax2 = subplot(222);
hold on;
plot(BusPower, 'r');
plot(kvaserMap('Rail3V').ts);
xlabel('Time');
ylabel('Dynamometer torque measurement (N m)');
hold off;


%% Motor voltage and current

figure(2);
ax1 = subplot(211)
[Vd Vq] = synchronize(kvaserMap('Vd').ts, kvaserMap('Vq').ts, 'Uniform', 'Interval', 0.2);
hold on;
plot(Vd, 'r');
plot(Vq);

MotorVoltage = Vd;
MotorVoltage.Data = sqrt(Vd.Data.^2 + Vq.Data.^2);
plot(MotorVoltage, 'g');

ax2 = subplot(212)
[Id Iq] = synchronize(kvaserMap('Id').ts, kvaserMap('Iq').ts, 'Uniform', 'Interval', 0.2);
hold on;
plot(Id, 'r');
plot(Iq);

linkaxes([ax1, ax2], 'x');