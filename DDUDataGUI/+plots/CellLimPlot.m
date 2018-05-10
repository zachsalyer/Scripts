function [ output_args ] = CellLimPlot( CoreData, fig )
%This function plots the cell temperature limit rider control, in which the
%value '1' signifies that cell temperature was limiting vehicle output
%power. CoreData is the input file containing the run data, fig is an
%optional parameter of a figure handle for the plot to be made on.

if ~exist('fig')
    f=figure;
else
    f=figure(fig)
end;

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','Cell Temp Limits','numbertitle','off')
plot(CoreData.Powertrain.Cooling.CellTemperatureLimit,'LineWidth',2);
xlabel('Time [s]');
ylabel('Cell Temp Limit Flag');
title('Cell Temp Limit Flag vs Time');
end

