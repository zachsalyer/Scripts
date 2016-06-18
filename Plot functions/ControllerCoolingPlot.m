function [ output_args ] = ControllerCoolingPlot( CoreData, fig )
%This function plots the temperatures in the controller cooling loop
%including the controller phase temperatures and coolant and inlet and
%outlet temperatures vs time.  CoreData is the input file containing the
%run data, fig is an optional parameter of a figure handle for the plot to
%be made on.

if ~exist('fig')
    f=figure;
else
    f=figure(fig)
end;

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','Controller Cooling Temperatures','numbertitle','off')
plot(CoreData.Powertrain.Cooling.InverterInletTemp,'LineWidth',2);
plot(CoreData.Powertrain.Cooling.InverterOutletTemp,'LineWidth',2);
plot(CoreData.Powertrain.Inverter.DSPBoardTemp,'LineWidth',2);
plot(CoreData.Powertrain.Inverter.IPMPhaseATemp,'LineWidth',2);
plot(CoreData.Powertrain.Inverter.IPMPhaseBTemp,'LineWidth',2);
plot(CoreData.Powertrain.Inverter.IPMPhaseCTemp,'LineWidth',2);
h=legend('Controller Inlet Temp', 'Controller Outlet Temp', 'Controller DSP Board Temp', 'Controller Phase A Temp', 'Controller Phase B Temp','Controller Phase C Temp');
set(h,'FontSize',10);
xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
title('Controller Cooling Loop Temperatures');
end

