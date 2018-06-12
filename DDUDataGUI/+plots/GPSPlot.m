function [  ] = GPSPlot(CoreData, fig)
%This function plots the GPS data Longitude, Latitude, and Altitude in a 3D
%plot. CoreData is the input file containing the run data, fig is an
%optional parameter of a figure handle for the plot to be made on. 

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
%set(f,'name','GPS','numbertitle','off')
plot3(CoreData.Vehicle.GPS.Longitude, CoreData.Vehicle.GPS.Latitude, CoreData.Vehicle.GPS.Altitude,'LineWidth',2);
xlabel('Longitude');
ylabel('Latitude');
zlabel('Altitude');
title('GPS Data');

end

