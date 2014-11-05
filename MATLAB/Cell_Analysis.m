%% import
cell = dlmread('Cur_Cap_Cell1_101714 - 001.csv',',',3);
Hicell = dlmread('Curr_HiC_Cap_Cell1_102014 - 001.csv',',',3);
temp = dlmread('Cell1_HiC_Temp.log','\t',1,1);

time_cell = cell(:,2);
amps_cell = cell(:,4);
volts_cell = cell(:,5);

time_Hcell = Hicell(:,2);
amps_Hcell = Hicell(:,4);
volts_Hcell = Hicell(:,5);

temp_Hcell = temp;
temp_time = [0:1:length(temp)-1]';


%% plot
close all
figure()
plotyy(time_cell,amps_cell,time_cell,volts_cell);

legend('amps','volts')

figure()
hold all 
plot(time_cell,amps_cell);
plot(time_cell,volts_cell);
plot(temp_time, temp_Hcell);

%% CAP
ele_disc = find(amps_cell < 0);
ele_ch = find(amps_cell > 0); 
sum_disc = sum(-amps_cell(ele_disc))
sum_ch = sum(amps_cell(ele_ch))
int_disc = sum_disc*0.1
int_ch = sum_ch*0.1
av_cap = int_disc/(3*60*60) 
av_cap_ch = int_ch/(4*60*60) 
diff_amph = av_cap-av_cap_ch

eff = diff_amph / av_cap

Hele_disc = find(amps_Hcell < 0);
Hsum_disc = sum(-amps_Hcell(Hele_disc))
Hint_disc = Hsum_disc*0.1
Hav_cap = Hint_disc/(3*60*60) %amp second
