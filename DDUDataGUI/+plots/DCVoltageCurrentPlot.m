function [ output_args ] = DCVoltageCurrentPlot( CoreData, fig )
%This function plots the DC bus voltage and current on two subplots.
%CoreData is the input file containing the run data, fig is an optional
%parameter of a figure handle for the plot to be made on.

if ~exist('fig')
    f=figure;
else
    f=figure(fig);
end;

set(gcf,'color','w'); set(gca,'fontsize',16)
set(f,'name','DC Bus Voltage and Current','numbertitle','off')
title('Battery Pack Current and Voltage');
hold on;
ax1=subplot(2,1,1);
plot(CoreData.time, CoreData.D1_DC_Bus_VoltageV1,'LineWidth',2);
title('DC Bus Voltage');
xlabel('Time [s]');
ylabel('Bus Voltage [V]');
ax2=subplot(2,1,2);
plot(CoreData.time, CoreData.D4_DC_Bus_CurrentA1,'LineWidth',2);
title('DC Bus Current');
xlabel('Time [s]');
ylabel('Bus Current [A]');
linkaxes([ax1,ax2],'x');
end

