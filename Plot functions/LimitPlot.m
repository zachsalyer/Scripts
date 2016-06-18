function [ output_args ] = LimitPlot( CoreData, fig )
%This function plots the Tritium Limit flags in subplots identifying which
%limit was triggered. CoreData is the input file containing the run data, 
%fig is an optional parameter of a figure handle for the plot to be made on. 

if ~exist('fig')
    f=figure;
else
    f=figure(fig)
end;

set(gcf,'color','w'); set(gca,'fontsize',14);title('Motor Controller Limit Flags'); hold on;
set(f,'name','Limit Flags','numbertitle','off')
for i=1:6
    subplot(6,1,i);
    plot(CoreData.Powertrain.Inverter.LimitFlags.Data(:,i),'LineWidth',2);
    ylim([0 1]);
    set(get(gca,'YLabel'),'Rotation',0);
end
xlabel('Time [s]');
subplot(6,1,1);
title('Motor Current Limit');
subplot(6,1,2);
title('Velocity Limit');
subplot(6,1,3);
title('Bus Current Limit');
subplot(6,1,4);
title('Bus Voltage Upper Limit');
subplot(6,1,5);
title('Bus Voltage Lower Limit');
subplot(6,1,6);
title('IPM Temperature or Motor Temperature Limit');

end

