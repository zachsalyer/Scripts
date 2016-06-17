% date: 6/14/206
% author: David M

clear; close all; clc

filename = input('Input file to be reformatted: ', 's');

% Load input file
m			= matfile(filename);
temp		= whos(m);
variables	= {temp.name};

in			= load(filename);

for t = 1:1:length(in.VelocityMeas_107_MotorVelocit_00.signals.values)
    if in.VelocityMeas_107_MotorVelocit_00.signals.values(t,:) > 0
       min_time = in.VelocityMeas_107_MotorVelocit_00.time(t); 
       break;
    end
end

for z = length(in.VelocityMeas_107_MotorVelocit_00.signals.values):-1:1
    if in.VelocityMeas_107_MotorVelocit_00.signals.values(z,:) > 0
       max_time = in.VelocityMeas_107_MotorVelocit_00.time(z); 
       break;
    end
end


race_start_time = min_time;
race_end_time = max_time;
powertrain_time_vector		= min_time:0.1:max_time;
rs							= @(ts) resample( ts, powertrain_time_vector );

%Batterypack
j = 1;
for i = 1:300
    if strfind(variables{i}, 'Cells')
        data_volt(j,:) = eval(['in.' variables{i}]);
        voltages(j,:) = timeseries(data_volt(j).signals.values, data_volt(j).time);
        j = j + 1;
        
    end
end

k = 1;
for i = 1:300
    if strfind(variables{i}, 'Temps')
        data_temp(k,:) = eval(['in.' variables{i}]);
        temperatures(k,:) = timeseries(data_temp(k).signals.values, data_temp(k).time);
        k = k + 1;
    end
end

BusC = timeseries(in.WS200BusMeas_109_BusCurrent_00.signals.values, in.WS200BusMeas_109_BusCurrent_00.time);
BusV = timeseries(in.WS200BusMeas_109_BusVoltage_01.signals.values, in.WS200BusMeas_109_BusVoltage_01.time);

%Motor
MotorTemp = timeseries(in.WS200MotorTe_113_MotorTemp_01.signals.values, in.WS200MotorTe_113_MotorTemp_01.time); 
MotorVelocity = timeseries(in.VelocityMeas_107_MotorVelocit_00.signals.values, in.VelocityMeas_107_MotorVelocit_00.time);
PhaseCurrentB = timeseries(in.PhaseCurrent_101_PhaseCurrent_00.signals.values, in.PhaseCurrent_101_PhaseCurrent_00.time);
PhaseCurrentC = timeseries(in.PhaseCurrent_101_PhaseCurrent_01.signals.values, in.PhaseCurrent_101_PhaseCurrent_01.time);

%Coolant 
Inlet = timeseries(in.MotorCoolant_97_MotorCoolant_00.signals.values, in.MotorCoolant_97_MotorCoolant_00.time);
Outlet = timeseries(in.MotorCoolant_97_MototCoolant_01.signals.values, in.MotorCoolant_97_MototCoolant_01.time);
IInlet = timeseries(in.ControllerCo_78_ControllerCo_00.signals.values, in.ControllerCo_78_ControllerCo_00.time);
OOutlet = timeseries(in.ControllerCo_78_ControllerCo_01.signals.values, in.ControllerCo_78_ControllerCo_01.time);
IFlow = timeseries(in.CoolantFlows_79_ControllerCo_00.signals.values, in.CoolantFlows_79_ControllerCo_00.time);
MFlow = timeseries(in.CoolantFlows_79_MotorCoolant_01.signals.values, in.CoolantFlows_79_MotorCoolant_01.time);
CellTempLimit = timeseries(in.DriveControl_81_CellTempLimi_04.signals.values, in.DriveControl_81_CellTempLimi_04.time);

%Inverter
BEMFd = timeseries(in.MotorBackEMF_96_BEMFd_00.signals.values, in.MotorBackEMF_96_BEMFd_00.time); 
BEMFq = timeseries(in.MotorBackEMF_96_BEMFq_01.signals.values, in.MotorBackEMF_96_BEMFq_01.time);
DC = timeseries(in.WS200BusAmpH_108_DCBusAmpHour_00.signals.values, in.WS200BusAmpH_108_DCBusAmpHour_00.time);
Setpoint = timeseries(in.MotorDriveCo_99_MotorCurrent_00.signals.values,in.MotorDriveCo_99_MotorCurrent_00.time);
Id = timeseries(in.MotorCurrent_98_Id_00.signals.values, in.MotorCurrent_98_Id_00.time);
Iq = timeseries(in.MotorCurrent_98_Iq_01.signals.values, in.MotorCurrent_98_Iq_01.time);
Vd  = timeseries(in.MotorVoltage_100_Vd_00.signals.values, in.MotorVoltage_100_Vd_00.time);
Vq = timeseries(in.MotorVoltage_100_Vq_01.signals.values, in.MotorVoltage_100_Vq_01.time);
PA = timeseries(in.WS200MotorTe_113_IPMPhaseATem_00.signals.values, in.WS200MotorTe_113_IPMPhaseATem_00.time);
PB = timeseries(in.WS200DSPBoar_110_IPMPhaseBTem_01.signals.values, in.WS200DSPBoar_110_IPMPhaseBTem_01.time); 
PC = timeseries(in.WS200PhaseCT_114_IMPPhaseCTem_00.signals.values, in.WS200PhaseCT_114_IMPPhaseCTem_00.time);
Btemp = timeseries(in.WS200DSPBoar_110_DSPBoardTemp_00.signals.values, in.WS200DSPBoar_110_DSPBoardTemp_00.time);
errorvector = de2bi(in.WS200Status_116_ErrorFlags_01.signals.values);
Eflag = timeseries(errorvector, in.WS200Status_116_ErrorFlags_01.time); 
limitvector = de2bi(in.WS200Status_116_LimitFlags_02.signals.values);
LFlag = timeseries(limitvector, in.WS200Status_116_LimitFlags_02.time);


%GPS
latitude = timeseries(in.GPS_Latitude_86_Latitude_01.signals.values, in.GPS_Latitude_86_Latitude_01.time);
longitude = timeseries(in.GPS_Longitud_87_Longitude_01.signals.values, in.GPS_Longitud_87_Longitude_01.time);
GPSVelocity = timeseries(in.GPS_Speed_89_Speed_00.signals.values, in.GPS_Speed_89_Speed_00.time);
Altitude = timeseries(in.GPS_Altitude_84_Altitude_00.signals.values, in.GPS_Altitude_84_Altitude_00.time);
Ambient = timeseries(in.AmbientMeasu_00_AmbientTemp_01.signals.values, in.AmbientMeasu_00_AmbientTemp_01.time); 
HDOP = timeseries(in.GPS_Precisio_88_HDOP_00.signals.values, in.GPS_Precisio_88_HDOP_00.time);

for x = 1:136
    voltages(x) = rs(voltages(x));
    BattVoltData(x,:) = voltages(x).Data';
end

for x = 1:48
    temperatures(x) = rs(temperatures(x));
    BattTempData(x,:) = temperatures(x).Data';
end

BIMVolt = timeseries(BattVoltData, powertrain_time_vector);
BIMTemp = timeseries(BattTempData, powertrain_time_vector);

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
                    'ErrorFlags', Eflag, ...
                    'LimitFlags', LFlag)), ...
           'Vehicle', ...
                struct('GPS', ...
                    struct('Longitude', rs(longitude), ...
                    'Latitude', rs(latitude), ...
                    'HDOP', rs(HDOP), ...
                    'GPSVelocity', rs(GPSVelocity), ...
                    'Altitude', rs(Altitude)), ...
                'WheelSpeedFront', [], ...
                'WheelSpeedRear', [], ...
                'AmbientTemperature', rs(Ambient)));
            
            
RawData = in;

save_file = input('Save file name as: ', 's');
save(save_file, 'CoreData', 'RawData', '-v7.3');


