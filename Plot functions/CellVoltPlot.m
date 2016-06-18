function [ output_args ] = CellVoltPlot( CoreData, fig )
%This function plots the valid individual cell output voltages on a single
%plot. CoreData is the input file containing the run data, fig is an
%optional parameter of a figure handle for the plot to be made on.

if ~exist('fig')
    f=figure;
else
    f=figure(fig)
end;

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','Cell Voltages','numbertitle','off')
count =1;
for i=1:134
    B = any(CoreData.Powertrain.BatteryPack.CellVoltages.Data(i,:));
    if B==1
        CellNum(count) = i;
        count=count+1;
        plot(CoreData.Powertrain.BatteryPack.CellVoltages.time, CoreData.Powertrain.BatteryPack.CellVoltages.Data(i,:)/1000,'LineWidth',2);
    end
    
end
legendCell = cellstr(num2str(CellNum', 'Cell%-d'));
h=legend(legendCell);
set(h,'FontSize',6);
xlabel('Time [s]');
ylabel('Voltage [V]');
title('Individual Cell Voltages');
end

