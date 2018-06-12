function [ output_args ] = CellTempPlot( CoreData, fig )
%This function plots all of the valid cell temperatures (above 0C average).
%CoreData is the input file containing the run data, fig is an optional
%parameter of a figure handle for the plot to be made on.

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
% set(f,'name','Cell Temperatures','numbertitle','off')
plot(CoreData.Powertrain.BatteryPack.CellTemp1,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp2,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp3,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp4,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp5,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp6,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp8,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp9,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp10,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp13,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp14,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp15,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp16,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp17,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp18,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp20,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp21,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp22,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp23,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp24,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp25,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp26,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp27,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp28,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp29,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp30,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp31,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp32,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp33,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp34,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp36,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp37,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp38,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp39,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp40,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp41,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp42,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp44,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp45,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp46,'LineWidth',2);
plot(CoreData.Powertrain.BatteryPack.CellTemp48,'LineWidth',2);
xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
title('Individual Cell Temperatures');
end

