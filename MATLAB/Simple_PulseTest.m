%% Load Data and put step count in
clear all
clc

file = 'Res.csv'
data=importdata(file);

fprintf('%s \n',file)

step =  data.data(:,1);  
V = data.data(:,end);
A = data.data(:,end-1);


    
    
     %% SOC builder
%     
%     % [T,A]=strtok(file(12:end),'_');
%     % [B,A]=strtok(A,'d');
%     % [T,A]=strtok(B,'_');
%     % T=str2num(T);
%     
%     
% %     T=input('What is the test temperature: ');
%     
%     
% %     
% %     C=input('What is the capacity for the cell at this temeprature (Ah): ');
% %     iter=input('Which iteration of the test is this: ');
%     for i=1:length(data.data(1,:));
%         if max(data.data(:,i)) < 22 && min(data.data(:,1)) >= startsteps
%             step=data.data(:,i);
%             break
%         end
%     end
%     
%     V=data.data(:,end);
%     A=data.data(:,end-1);
%     
%     data.data(:,6)=0;
%     for i=1:length(data.data);
%         if step(i) == startsteps
%             break
%         end
%     end
%     
% %     data.data(i,6)=1;
% %     
% %     for j=i:length(data.data)-1;
% %         data.data(j+1,6)=data.data(j,6)+A(j)/(10*C*3600);
% %     end
% %     
    
    %% Finding Resistances
    start_res = 7;
    end_res = 21;
    calc_step = 4;
    
    %find all point corresponding chaing current conditions using steps
    I = find((diff(step) > 0) & (ismember(step(2:end),[start_res:2:end_res])));
    %do resitance calculation on all
    resistance =(V(I+calc_step)-V(I-calc_step))./(A(I+calc_step)-A(I-calc_step));
    
    plot(resistance)
    
    %%
    
    for k=1:length(data.data)-1;
        %front edge, 1 Cnom charge
        if step(k) == 8 && step(k-1) == 7
            %resistance(a,1)=a;
            resistance(a)=(V(k+2)-V(k-2))/(A(k+2)-A(k-2));
            a=a+1;
            %data.resistance(a,10)=data.data(k,6);
            %sprintf('Voltage is %.3f and %.3f and Current is %.3f and %.3f at %i\n',data.data(k+3,4),data.data(k-2,4),data.data(k+3,3),data.data(k-2,3),k)
            %back edge, 1 Cnom charge
        elseif step(k) == 9 && step(k-1) == 8
            resistance(a)=(V(k+2)-V(k-2))/(A(k+2)-A(k-2));
            a=a+1;
            %front edge, 1 Cnom discharge
        elseif step(k) == 10 && step(k-1) == 9
            resistance(a)=(V(k+2)-V(k-2))/(A(k+2)-A(k-2));
            a=a+1;
            %back edge, 1 Cnom discharge
        elseif step(k) == 11 && step(k-1) == 10
            resistance(a)=(V(k+2)-V(k-2))/(A(k+2)-A(k-2));
            a=a+1;
            %front edge, 2 Cnom charge
        elseif step(k) == 12 && step(k-1) ==11
            resistance(a)=(V(k+2)-V(k-2))/(A(k+2)-A(k-2));
            a=a+1;
            %back edge, 2 Cnom charge
        elseif step(k) == 13 && step(k-1) == 12
            resistance(a)=(V(k+2)-V(k-2))/(A(k+2)-A(k-2));
            a=a+1;
            %front edge, 2 Cnom discharge
        elseif step(k) == 14 && step(k-1) == 13
            resistance(a)=(V(k+2)-V(k-2))/(A(k+2)-A(k-2));
            a=a+1;
            %back edge, 2 Cnom discharge
        elseif (step(k) == 6 || step(k) == 15)  && step(k-1) == 14
            resistance(a)=(V(k+2)-V(k-1))/(A(k+2)-A(k-1));
            a=a+1;
        end
    end
    
    fprintf('Average Resistance is %.6f \n',mean(resistance));
    fprintf('Standard Deviation of the measurement is %.6f \n',std(resistance));
%     date=strtok(datestr(now));
%     cd(path)
%     filename=sprintf('save PulseTest_%i_degC_%i_%s data',T,iter,date);
%     eval(filename)
%     
%     if T>=0
%         varname=sprintf('res_%i_%i=data.resistance',T,iter);
%     else
%         varname=sprintf('res_%im_%i=data.resistance',T*-1,iter);
%     end
%     eval(varname)
    %% Plotting
%     figure(1)
%     plot(1:8,data.resistance(1,2:9),'*r',1:8,data.resistance(2,2:9),'*g',1:8,data.resistance(3,2:9),'*k',1:8,data.resistance(4,2:9),'*b',1:8,data.resistance(5,2:9),'*m',1:8,data.resistance(6,2:9),'+r',1:7,data.resistance(7,2:8),'+g')
%     xlabel('Sample')
%     ylabel('Resistance (ohm)')
%     grid
%     legend('90% SOC','80% SOC','70% SOC','60% SOC','50% SOC','40% SOC','30% SOC')
%     
%     figure (2)
%     plot(data.data(:,3))
%     xlabel('Step (.1seconds)')
%     ylabel('Current (amps)')
%     grid
%     
%     
    %loop=input('load another file (1 for yes)');

%end