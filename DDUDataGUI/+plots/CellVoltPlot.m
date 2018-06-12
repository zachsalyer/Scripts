function [ output_args ] = CellVoltPlot( CoreData )
%This function plots the valid individual cell output voltages on a single
%plot. CoreData is the input file containing the run data, fig is an


%% plot cell voltage max
f=figure('Color','w');
set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','BIM Max Voltages','numbertitle','off');
yyaxis left;
plot(CoreData.Powertrain.BatteryPack.BIM1MaxCellNumber)
plot(CoreData.Powertrain.BatteryPack.BIM2MaxCellNumber)
plot(CoreData.Powertrain.BatteryPack.BIM3MaxCellNumber)
plot(CoreData.Powertrain.BatteryPack.BIM4MaxCellNumber)
plot(CoreData.Powertrain.BatteryPack.BIM5MaxCellNumber)
plot(CoreData.Powertrain.BatteryPack.BIM6MaxCellNumber)
xlabel('Time [s]');
ylabel('Max Cell Number');
yyaxis right; 
plot(CoreData.Powertrain.BatteryPack.BIM1MaxCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM2MaxCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM3MaxCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM4MaxCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM5MaxCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM6MaxCellVoltage)
ylabel('Max Cell Voltage');
title('Max Cells')

%% plot cell voltage min
f=figure('Color','w');
set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','BIM Min Voltages','numbertitle','off'); 
yyaxis left;
plot(CoreData.Powertrain.BatteryPack.BIM1MinCellNumber)
plot(CoreData.Powertrain.BatteryPack.BIM2MinCellNumber)
plot(CoreData.Powertrain.BatteryPack.BIM3MinCellNumber)
plot(CoreData.Powertrain.BatteryPack.BIM4MinCellNumber)
plot(CoreData.Powertrain.BatteryPack.BIM5MinCellNumber)
plot(CoreData.Powertrain.BatteryPack.BIM6MinCellNumber)
xlabel('Time [s]');
ylabel('Min Cell Number');
yyaxis right; 
plot(CoreData.Powertrain.BatteryPack.BIM1MinCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM2MinCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM3MinCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM4MinCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM5MinCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM6MinCellVoltage)
ylabel('Min Cell Voltage');
title('Min Cells')

%% plot min and max cells
f=figure('Color','w');
set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','BIM Min/Max Voltages','numbertitle','off');
yyaxis left;
xlabel('Time [s]');
plot(CoreData.Powertrain.BatteryPack.BIM1MaxCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM2MaxCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM3MaxCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM4MaxCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM5MaxCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM6MaxCellVoltage)
ylabel('Max Cell Voltage');
ylim([0,3600]);
yyaxis right; 
plot(CoreData.Powertrain.BatteryPack.BIM1MinCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM2MinCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM3MinCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM4MinCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM5MinCellVoltage)
plot(CoreData.Powertrain.BatteryPack.BIM6MinCellVoltage)
ylabel('Min Cell Voltage');
ylim([0,3600]);
title('Min/Max Cells')


end

