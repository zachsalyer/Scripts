function [ output_args ] = VelocityPlot( CoreData, fig )
%This function plots the calculated vehicle speed in mph vs time based on
%gearing and wheel circumference.  CoreData is the input file containing
%the run data, fig is an optional parameter of a figure handle for the plot
%to be made on.

if ~exist('fig')
    f=figure;
else
    f=figure(fig)
end;

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','Vehicle Speed','numbertitle','off');
gearing=51/23;
wheel_circ=2.082; %m
mps=CoreData.Powertrain.Motor.MotorVelocity.data/gearing*wheel_circ/60;
mph=mps*2.237;
plot(CoreData.Powertrain.Motor.MotorVelocity.time, mph,'LineWidth',2);
xlabel('Time [s]');
ylabel('Vehicle Speed [mph]');
title('Vehicle Speed vs Time');
end

