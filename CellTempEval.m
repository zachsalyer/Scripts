function [ averageSlope_inrun, TempRiseNormalizedtoCurrent, slope ] = CellTempEval( CoreData)
%Data Processing of Cell Temps
%Calculates the temp rise/second normalized to the average current

%--------------------------------------------------------------------------
%Determine 'packtemp' by finding highest cell temp at each time

packtemp = zeros(length(CoreData.Powertrain.BatteryPack.CellTemp1.data),1);

for j=[2 4 5 6 8 9 10 13 14 16 18 20 21 22 23 24 26 28 29 30 31 32 33 34 36 37 38 40 42 44 45 46] %Cells that correspond to real temps - via thermistors locations
    dataname = ['CoreData.Powertrain.BatteryPack.CellTemp' num2str(j)];
    data = eval(dataname);
    
    %Find maximum cell temps for each time - this is 'pack temp'
        for i=1:length(data.data)
            if data.data(i) > packtemp(i)
                packtemp(i) = data.data(i);
            end
        end
end


%--------------------------------------------------------------------------
%Filter temp spikes in data

filteredtemps = medfilt1(packtemp,30);

if max(filteredtemps > 1000)
    filteredtemps = filteredtemps/100;
    packtemp = packtemp/100;
end

%--------------------------------------------------------------------------
%Find slope of max cell temp at each time step

windowWidth = 20;
slope = zeros(length(filteredtemps)-windowWidth,1);

        for k=1:length(filteredtemps) - windowWidth
            windowedx = data.time(k:k+windowWidth -1);
            windowedy = filteredtemps(k:k+windowWidth -1);
    
            coefficients = polyfit(windowedx, windowedy, 1);
    
            slope(k,1) = coefficients(1);
        end
        
%---------------------------------------------------------------------------
%Make Various Plots and Calcs for Visualization/Analysis

%Plotting filtered pack temp versus actual
figure()
plot(data.time,filteredtemps); hold on;
plot(data.time,packtemp,'--');

%Plot filtered pack temp versus current

%%Calculate average slope during run based on throttle position?
index = find(CoreData.Vehicle.Sensors.ThrottleFiltered.data > 80);

%Calc average slope over throttle position
averageSlope_inrun = (filteredtemps(index(end))-filteredtemps(index(1)))/(data.time(index(end))-data.time(index(1)));

%Calc average current over throttle pos
averagecurrent_inrun = mean(CoreData.Powertrain.Inverter.DCBusCurrent.data(index(1):index(end)));

%Normalize
TempRiseNormalizedtoCurrent = averageSlope_inrun/averagecurrent_inrun;

end


