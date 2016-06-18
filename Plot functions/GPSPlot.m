function [  ] = GPSPlot(CoreData, fig)
%This function plots the GPS data Longitude, Latitude, and Altitude in a 3D
%plot. CoreData is the input file containing the run data, fig is an
%optional parameter of a figure handle for the plot to be made on. 

if ~exist('fig')
    f=figure;
else
    f=figure(fig)
end;

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','GPS','numbertitle','off')
plot3(CoreData.Vehicle.GPS.Longitude.Data, CoreData.Vehicle.GPS.Latitude.Data, CoreData.Vehicle.GPS.Altitude.Data,'LineWidth',2);
xlabel('Longitude');
ylabel('Latitude');
zlabel('Altitude');
title('GPS Data');

end

