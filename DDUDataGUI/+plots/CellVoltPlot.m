function [ output_args ] = CellVoltPlot( CoreData )
%This function plots the valid individual cell output voltages on a single
%plot. CoreData is the input file containing the run data, fig is an


%% plot cell voltage max
f=figure('Color','w');
set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','BIM Max Voltages','numbertitle','off');
yyaxis left;
plot(CoreData.time, CoreData.BIM1MaxCellNumbernone, CoreData.time, CoreData.BIM2MaxCellNumbernone, CoreData.time, CoreData.BIM3MaxCellNumbernone, CoreData.time, CoreData.BIM4MaxCellNumbernone, CoreData.time, CoreData.BIM5MaxCellNumbernone, CoreData.time, CoreData.BIM6MaxCellNumbernone);
xlabel('Time [s]');
ylabel('Max Cell Number');
yyaxis right; 
plot(CoreData.time, CoreData.BIM1MaxCellVoltagenone, CoreData.time, CoreData.BIM2MaxCellVoltagenone, CoreData.time, CoreData.BIM3MaxCellVoltagenone, CoreData.time, CoreData.BIM4MaxCellVoltagenone, CoreData.time, CoreData.BIM5MaxCellVoltagenone, CoreData.time, CoreData.BIM6MaxCellVoltagenone);
ylabel('Max Cell Voltage');
title('Max Cells')

%% plot cell voltage min
f=figure('Color','w');
set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','BIM Min Voltages','numbertitle','off'); 
yyaxis left;
plot(CoreData.time, CoreData.BIM1MinCellNumbernone, CoreData.time, CoreData.BIM2MinCellNumbernone, CoreData.time, CoreData.BIM3MinCellNumbernone, CoreData.time, CoreData.BIM4MinCellNumbernone, CoreData.time, CoreData.BIM5MinCellNumbernone, CoreData.time, CoreData.BIM6MinCellNumbernone);
xlabel('Time [s]');
ylabel('Min Cell Number');
yyaxis right; 
plot(CoreData.time, CoreData.BIM1MinCellVoltagenone, CoreData.time, CoreData.BIM2MinCellVoltagenone, CoreData.time, CoreData.BIM3MinCellVoltagenone, CoreData.time, CoreData.BIM4MinCellVoltagenone, CoreData.time, CoreData.BIM5MinCellVoltagenone, CoreData.time, CoreData.BIM6MinCellVoltagenone);
ylabel('Min Cell Voltage');
title('Min Cells')

%% plot min and max cells
f=figure('Color','w');
set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','BIM Min/Max Voltages','numbertitle','off');
yyaxis left;
xlabel('Time [s]');
plot(CoreData.time, CoreData.BIM1MaxCellVoltagenone, CoreData.time, CoreData.BIM2MaxCellVoltagenone, CoreData.time, CoreData.BIM3MaxCellVoltagenone, CoreData.time, CoreData.BIM4MaxCellVoltagenone, CoreData.time, CoreData.BIM5MaxCellVoltagenone, CoreData.time, CoreData.BIM6MaxCellVoltagenone);
ylabel('Max Cell Voltage');
ylim([0,3600]);
yyaxis right; 
plot(CoreData.time, CoreData.BIM1MinCellVoltagenone, CoreData.time, CoreData.BIM2MinCellVoltagenone, CoreData.time, CoreData.BIM3MinCellVoltagenone, CoreData.time, CoreData.BIM4MinCellVoltagenone, CoreData.time, CoreData.BIM5MinCellVoltagenone, CoreData.time, CoreData.BIM6MinCellVoltagenone);
ylabel('Min Cell Voltage');
ylim([0,3600]);
title('Min/Max Cells')


end

