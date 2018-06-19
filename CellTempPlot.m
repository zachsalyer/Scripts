function [ output_args ] = CellTempPlot( CoreData, fig )
%This function plots all of the valid cell temperatures (above 0C average).
%CoreData is the input file containing the run data, fig is an optional
%parameter of a figure handle for the plot to be made on.

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
% set(f,'name','Cell Temperatures','numbertitle','off')

for j=[2 4 5 6 8 9 10 13 14 16 18 20 21 22 23 24 26 28 29 30 31 32 33 34 36 37 38 40 42 44 45 46] %Cells that correspond to real temps - via thermistors locations
    dataname = ['CoreData.Powertrain.BatteryPack.CellTemp' num2str(j)];
    if min(eval(dataname)) > 0
        data = eval(dataname)/100;
        plot(data);
    end
end

xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
title('Individual Cell Temperatures');
end

