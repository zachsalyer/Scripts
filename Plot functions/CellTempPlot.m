function [ output_args ] = CellTempPlot( CoreData, fig )
%This function plots all of the valid cell temperatures (above 0C average).
%CoreData is the input file containing the run data, fig is an optional
%parameter of a figure handle for the plot to be made on.

if ~exist('fig')
    f=figure;
else
    f=figure(fig)
end;

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','Cell Temperatures','numbertitle','off')
count =1;
for i=1:48
    B = all(CoreData.Powertrain.BatteryPack.Temperatures.Data(i,:));
    if B==1 && mean(CoreData.Powertrain.BatteryPack.Temperatures.Data(i,:))>0
        CellTemp(count) = count;
        count=count+1;
        plot(CoreData.Powertrain.BatteryPack.Temperatures.time, smooth(CoreData.Powertrain.BatteryPack.Temperatures.Data(i,:)),'LineWidth',2);
    end
    
end
legendCellTemp = cellstr(num2str(CellTemp', 'CellTemp%-d'));
h=legend(legendCellTemp);
set(h,'FontSize',6);
xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
title('Individual Cell Temperatures');
end

