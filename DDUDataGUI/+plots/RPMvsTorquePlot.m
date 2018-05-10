function [ output_args ] = RPMvsTorquePlot( CoreData, fig )
%This function plots the motor torque and RPM seen in the data as a
%scaterplot with the bounds of the set rider control limits.  CoreData is
%the input file containing the run data, fig is an optional parameter of a
%figure handle for the plot to be made on.

if ~exist('fig')
    f=figure;
else
    f=figure(fig);
end;

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
set(f,'name','RPM vs Torque','numbertitle','off')
scatter(-CoreData.D2_Motor_Speedrpm,-CoreData.D2_Torque_FeedbackNm1);
xlabel('Motor Velocity [RPM]');
ylabel('Motor Torque [Nm]');
title('Torque vs RPM');
xlim([0 4200]);
ylim([0 600]);
end

