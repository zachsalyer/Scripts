%% Load Data and put step count in
clear all
clc

file = 'Res.csv'
data=importdata(file);

fprintf('%s \n',file)

step =  data.data(:,1);  
V = data.data(:,end);
A = data.data(:,end-1);

    
    %% Finding Resistances
    start_res = 7;
    end_res = 21;
    calc_step = 4;
    
    %find all point corresponding chaing current conditions using steps
    I = find((diff(step) > 0) & (ismember(step(2:end),[start_res:2:end_res])));
    %do resitance calculation on all
    resistance =(V(I+calc_step)-V(I-calc_step))./(A(I+calc_step)-A(I-calc_step));
    
    plot(resistance)
    
