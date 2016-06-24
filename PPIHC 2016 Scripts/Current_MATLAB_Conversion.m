% date: 6/14/206
% author: David M

clear; close all; clc

filename = input('Input file to be reformatted: ', 's');

% Load input file
m			= matfile(filename);
temp		= whos(m);
variables	= {temp.name};

in			= load(filename);

voltages = timeseries();
temperatures = timeseries();

timestamp = 1;

for t = 1:1:length(in.VelocityMeas_105_MotorVelocit_00.signals.values)
    if in.VelocityMeas_105_MotorVelocit_00.signals.values(t,:) > 0
       min_time = in.VelocityMeas_105_MotorVelocit_00.time(t); 
       timestamp = t;
       break;
    end
end

for z = length(in.VelocityMeas_105_MotorVelocit_00.signals.values):-1:1
    if in.VelocityMeas_105_MotorVelocit_00.signals.values(z,:) > 0
       max_time = in.VelocityMeas_105_MotorVelocit_00.time(z); 
       break;
    end
end


race_start_time = min_time;
race_end_time = max_time;
powertrain_time_vector		= min_time:0.1:max_time;
rs							= @(ts) resample( ts, powertrain_time_vector );

%Batterypack
j = 1;
for i = 1:length(variables)
    if strfind(variables{i}, 'Cells')
        data_volt(j,:) = eval(['in.' variables{i}]);
        voltages(j,:) = timeseries(data_volt(j).signals.values, data_volt(j).time);
        j = j + 1;
        
    end
end

k = 1;
for i = 1:length(variables)
    if strfind(variables{i}, 'Temps')
        data_temp(k,:) = eval(['in.' variables{i}]);
        temperatures(k,:) = timeseries(data_temp(k).signals.values, data_temp(k).time);
        k = k + 1;
    end
end

BusC = timeseries(in.WS200BusMeas_107_BusCurrent_00.signals.values, in.WS200BusMeas_107_BusCurrent_00.time);
BusV = timeseries(in.WS200BusMeas_107_BusVoltage_01.signals.values, in.WS200BusMeas_107_BusVoltage_01.time);

%Motor
MotorTemp = timeseries(in.WS200MotorTe_111_MotorTemp_01.signals.values, in.WS200MotorTe_111_MotorTemp_01.time); 
MotorVelocity = timeseries(in.VelocityMeas_105_MotorVelocit_00.signals.values, in.VelocityMeas_105_MotorVelocit_00.time);
PhaseCurrentB = timeseries(in.PhaseCurrent_99_PhaseCurrent_00.signals.values, in.PhaseCurrent_99_PhaseCurrent_00.time);
PhaseCurrentC = timeseries(in.PhaseCurrent_99_PhaseCurrent_01.signals.values, in.PhaseCurrent_99_PhaseCurrent_01.time);
RawThrottle = timeseries(in.RawThrottleI_100_RawThrottleI_00.signals.values, in.RawThrottleI_100_RawThrottleI_00.time);

%Coolant 
Inlet = timeseries(in.MotorCoolant_95_MotorCoolant_00.signals.values, in.MotorCoolant_95_MotorCoolant_00.time);
Outlet = timeseries(in.MotorCoolant_95_MototCoolant_01.signals.values, in.MotorCoolant_95_MototCoolant_01.time);
IInlet = timeseries(in.ControllerCo_78_ControllerCo_00.signals.values, in.ControllerCo_78_ControllerCo_00.time);
OOutlet = timeseries(in.ControllerCo_78_ControllerCo_01.signals.values, in.ControllerCo_78_ControllerCo_01.time);
IFlow = timeseries(in.CoolantFlows_79_ControllerCo_00.signals.values, in.CoolantFlows_79_ControllerCo_00.time);
MFlow = timeseries(in.CoolantFlows_79_MotorCoolant_01.signals.values, in.CoolantFlows_79_MotorCoolant_01.time);
CellTempLimit = timeseries(in.DriveControl_81_CellTempLimi_04.signals.values, in.DriveControl_81_CellTempLimi_04.time);

%Inverter
BEMFd = timeseries(in.MotorBackEMF_94_BEMFd_00.signals.values, in.MotorBackEMF_94_BEMFd_00.time); 
BEMFq = timeseries(in.MotorBackEMF_94_BEMFq_01.signals.values, in.MotorBackEMF_94_BEMFq_01.time);
DC = timeseries(in.WS200BusAmpH_106_DCBusAmpHour_00.signals.values, in.WS200BusAmpH_106_DCBusAmpHour_00.time);
Setpoint = timeseries(in.MotorDriveCo_97_MotorCurrent_00.signals.values,in.MotorDriveCo_97_MotorCurrent_00.time);
Id = timeseries(in.MotorCurrent_96_Id_00.signals.values, in.MotorCurrent_96_Id_00.time);
Iq = timeseries(in.MotorCurrent_96_Iq_01.signals.values, in.MotorCurrent_96_Iq_01.time);
Vd  = timeseries(in.MotorVoltage_98_Vd_00.signals.values, in.MotorVoltage_98_Vd_00.time);
Vq = timeseries(in.MotorVoltage_98_Vq_01.signals.values, in.MotorVoltage_98_Vq_01.time);
PA = timeseries(in.WS200MotorTe_111_IPMPhaseATem_00.signals.values, in.WS200MotorTe_111_IPMPhaseATem_00.time);
PB = timeseries(in.WS200DSPBoar_108_IPMPhaseBTem_01.signals.values, in.WS200DSPBoar_108_IPMPhaseBTem_01.time); 
PC = timeseries(in.WS200PhaseCT_112_IMPPhaseCTem_00.signals.values, in.WS200PhaseCT_112_IMPPhaseCTem_00.time);
Btemp = timeseries(in.WS200DSPBoar_108_DSPBoardTemp_00.signals.values, in.WS200DSPBoar_108_DSPBoardTemp_00.time);
errorvector = de2bi(in.WS200Status_114_ErrorFlags_01.signals.values);
EFlag = timeseries(errorvector, in.WS200Status_114_ErrorFlags_01.time); 
limitvector = de2bi(in.WS200Status_114_LimitFlags_02.signals.values,7);
LFlag1 = timeseries(limitvector(:,1), in.WS200Status_114_LimitFlags_02.time);
LFlag2 = timeseries(limitvector(:,2), in.WS200Status_114_LimitFlags_02.time);
LFlag3 = timeseries(limitvector(:,3), in.WS200Status_114_LimitFlags_02.time);
LFlag4 = timeseries(limitvector(:,4), in.WS200Status_114_LimitFlags_02.time);
LFlag5 = timeseries(limitvector(:,5), in.WS200Status_114_LimitFlags_02.time);
LFlag6 = timeseries(limitvector(:,6), in.WS200Status_114_LimitFlags_02.time);

%GPS
latitude = timeseries(in.GPS_Latitude_86_Latitude_01.signals.values, in.GPS_Latitude_86_Latitude_01.time);
longitude = timeseries(in.GPS_Longitud_87_Longitude_01.signals.values, in.GPS_Longitud_87_Longitude_01.time);
GPSVelocity = timeseries(in.GPS_Speed_89_Speed_00.signals.values, in.GPS_Speed_89_Speed_00.time);
GPSTimeStart = sprintf('Time: %02d:%02d:%02d', in.GPS_Time_90_Hours_00.signals.values(timestamp), in.GPS_Time_90_Minutes_02.signals.values(timestamp), in.GPS_Time_90_Seconds_03.signals.values(timestamp));
Altitude = timeseries(in.GPS_Altitude_84_Altitude_00.signals.values, in.GPS_Altitude_84_Altitude_00.time);
Ambient = timeseries(in.AmbientMeasu_00_AmbientTemp_01.signals.values, in.AmbientMeasu_00_AmbientTemp_01.time); 
HDOP = timeseries(in.GPS_Precisio_88_HDOP_00.signals.values, in.GPS_Precisio_88_HDOP_00.time);
Temp_Front = timeseries(in.TireTemperat_104_FrontTireTem_00.signals.values, in.TireTemperat_104_FrontTireTem_00.time);
Temp_Rear = timeseries(in.TireTemperat_104_RearTireTemp_01.signals.values, in.TireTemperat_104_RearTireTemp_01.time);

if (length(voltages(1).Data))
for x = 1:length(voltages)
    voltages(x) = rs(voltages(x));
    BattVoltData(x,:) = voltages(x).Data';
end
end

if (length(temperatures(1).Data))
for x = 1:length(temperatures)
    temperatures(x) = rs(temperatures(x));
    BattTempData(x,:) = temperatures(x).Data';
end
end

if (length(voltages(1).Data))
    BIMVolt = timeseries(BattVoltData, powertrain_time_vector);
else 
    BIMVolt = [];
end
if (length(temperatures(1).Data))
    BIMTemp = timeseries(BattTempData, powertrain_time_vector);
else 
    BIMTemp = [];
end

CoreData = struct('Powertrain', ...
                struct('BatteryPack', ...
                    struct('CellVoltages', BIMVolt, ...
                    'Temperatures', BIMTemp, ...
                    'BusVoltage', rs(BusV), ...
                    'BusCurrent', rs(BusC)), ...
                'Motor', struct(...
                    'MotorTemp', rs(MotorTemp), ...
                    'MotorVelocity', rs(MotorVelocity), ...
                    'PhaseCurrentB', rs(PhaseCurrentB), ...
                    'RawThrottle', rs(RawThrottle), ...
                    'PhaseCurrentC', rs(PhaseCurrentC)), ...
                'Cooling', struct(...
                    'MotorInletTemp', rs(Inlet), ...
                    'MotorOutletTemp', rs(Outlet), ...
                    'InverterInletTemp', rs(IInlet), ...
                    'InverterOutletTemp', rs(OOutlet), ...
                    'CellTemperatureLimit', rs(CellTempLimit), ...
                    'InverterCoolantFlow', rs(IFlow), ...
                    'MotorCoolantFlow', rs(MFlow)), ...
                'Inverter', struct(...
                    'BEMFd', rs(BEMFd), ...
                    'BEMFq', rs(BEMFq), ...
                    'DCBusAmpHours', rs(DC), ...
                    'MotorCurrentSetpoint', rs(Setpoint), ...
                    'Id', rs(Id), ...
                    'Iq', rs(Iq), ...
                    'Vd', rs(Vd), ...
                    'Vq', rs(Vq), ...
                    'IPMPhaseATemp', rs(PA), ...
                    'IPMPhaseBTemp', rs(PB), ...
                    'IPMPhaseCTemp', rs(PC), ...
                    'DSPBoardTemp', rs(Btemp), ...
                    'ErrorFlags', rs(EFlag), ...
                    'Limit_OutputVoltagePWM', rs(LFlag1), ...
                    'Limit_MotorCurrent', rs(LFlag2), ...
                    'Limit_Velocity', rs(LFlag3), ...
                    'Limit_BusCurrent', rs(LFlag4), ... %rs(LFlag4) in stead of [] when LFlag4 exists
                    'Limit_BusVoltageUpperLimit', rs(LFlag5), ... %rs(LFlag5) in stead of [] when LFlag5 exists
                    'Limit_BusVoltageLowerLimit', rs(LFlag6))), ... %rs(LFlag6) in stead of [] when LFlag6 exists
           'Vehicle', ...
                struct('GPS', ...
                    struct('Longitude', rs(longitude), ...
                    'Latitude', rs(latitude), ...
                    'HDOP', rs(HDOP), ...
                    'GPSVelocity', rs(GPSVelocity), ...
                    'GPSTimeStart', GPSTimeStart, ...
                    'Altitude', rs(Altitude)), ...
                'WheelSpeedFront', [], ...
                'WheelSpeedRear', [], ...
                'WheelTemperatureFront', rs(Temp_Front), ...
                'WheelTemperatureRear', rs(Temp_Rear), ...
                'AmbientTemperature', rs(Ambient)));
            
            
RawData = in;

save_file = input('Save CoreData file name as: ', 's');
save(save_file, 'CoreData', '-v7.3');
save_file = input('Save RawData file name as: ', 's');
save(save_file, 'RawData', '-v7.3');