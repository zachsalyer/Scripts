function [ output_args ] = CellTempPlot( CoreData, fig )
%This function plots all of the valid cell temperatures (above 0C average).
%CoreData is the input file containing the run data, fig is an optional
%parameter of a figure handle for the plot to be made on.

if ~exist('fig')
    f=figure;
else
    f=figure(fig);
end;

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','Cell Temperatures','numbertitle','off')
plot(CoreData.time, CoreData.CellTemp1C/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp2C/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp3none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp4none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp5none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp6none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp8none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp9none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp10none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp11none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp12none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp13none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp14none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp15none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp16none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp17none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp18none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp19none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp20none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp21none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp22none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp23none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp24none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp25none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp26none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp27none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp28none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp29none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp30none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp31none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp32none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp33none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp34none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp35none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp36none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp37none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp38none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp39none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp40none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp41none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp42none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp43none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp44none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp45none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp46none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp47none/100,'LineWidth',2);
plot(CoreData.time, CoreData.CellTemp48none/100,'LineWidth',2);
xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
title('Individual Cell Temperatures');
end

