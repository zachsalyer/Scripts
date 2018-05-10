function [ output_args ] = ControllerCoolingPlot( CoreData, fig )
%This function plots the temperatures in the controller cooling loop
%including the controller phase temperatures and coolant and inlet and
%outlet temperatures vs time.  CoreData is the input file containing the
%run data, fig is an optional parameter of a figure handle for the plot to
%be made on.

if ~exist('fig')
    f=figure;
else
    f=figure(fig);
end;

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','Controller Cooling Temperatures','numbertitle','off')
plot(CoreData.time,CoreData.Controller_Inlet_Temperature_fiC,'LineWidth',2);
plot(CoreData.time,CoreData.Controller_Outlet_Temperature_fiC,'LineWidth',2);
plot(CoreData.time,CoreData.D1_Control_Board_TemperatureC,'LineWidth',2);
plot(CoreData.time,CoreData.D1_Module_AC,'LineWidth',2);
plot(CoreData.time,CoreData.D2_Module_BC,'LineWidth',2);
plot(CoreData.time,CoreData.D3_Module_CC,'LineWidth',2);
plot(CoreData.time,CoreData.D4_Gate_Driver_BoardC,'LineWidth',2);
h=legend('Controller Inlet Temp', 'Controller Outlet Temp', 'Control Board Temp', 'Controller Module A Temp', 'Controller Module B Temp','Controller Module C Temp','Gate Driver Board Temp');
set(h,'FontSize',10);
xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
title('Controller Cooling Loop Temperatures');
end

