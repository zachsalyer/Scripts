function [ output_args ] = RPMvsTorquePlot( CoreData, fig )
%This function plots the motor torque and RPM seen in the data as a
%scaterplot with the bounds of the set rider control limits.  CoreData is
%the input file containing the run data, fig is an optional parameter of a
%figure handle for the plot to be made on.

if ~exist('fig')
    f=figure;
else
    f=figure(fig)
end;

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','RPM vs Torque','numbertitle','off')
scatter(CoreData.Powertrain.Motor.MotorVelocity.data,CoreData.Powertrain.Motor.PhaseCurrentB.data.*1.4);
plot([0 2000], 1.4*[240 240],'r', [2000 2500], 1.4*[240 200], 'r', [2500 3000], 1.4*[200 100], 'r', [3000 3000], 1.4*[100 0], 'r', 'LineWidth', 2);
xlabel('Motor Velocity [RPM]');
ylabel('Motor Torque [Nm]');
title('Torque vs RPM');
xlim([0 max(CoreData.Powertrain.Motor.MotorVelocity.data)]);
end

