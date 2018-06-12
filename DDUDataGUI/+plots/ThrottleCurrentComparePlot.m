function [ output_args ] = ThrottleCurrentComparePlot( CoreData, fig )
%This function plots the motor throttle command and motor output torque on
%the same figure.  CoreData is the input file containing the run data, fig
%is an optional parameter of a figure handle for the plot to be made on.

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
%set(f,'name','Throttle vs Current Compare','numbertitle','off')
[hAx,hLine1,hLine2]=plotyy(CoreData.Powertrain.Inverter.TorqueFeedback.time, abs(CoreData.Powertrain.Inverter.TorqueFeedback.data), CoreData.Vehicle.Sensors.CalculatedTorqueRequest.time, CoreData.Vehicle.Sensors.CalculatedTorqueRequest.data);
xlabel('Time [s]');
ylabel(hAx(1),'Throttle Command [Nm]');
set(gca,'fontsize',16); hold on;
ylabel(hAx(2),'Torque Feedback [Nm]');
title('Torque Output vs Throttle Command');
end

