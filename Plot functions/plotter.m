%this script runs all of the available plotting functions
close all;
%GPS
GPSPlot(CoreData)
%limit flags vs time
LimitPlot(CoreData)
%cell temp limit vs time
CellLimPlot(CoreData)
%cell voltages
CellVoltPlot(CoreData)
%cell temperatures
CellTempPlot(CoreData)
%motor cooling loop temps
MotorCoolingPlot(CoreData)
%inverter cooling loop temps
ControllerCoolingPlot(CoreData)
%scatterplot of rpm vs torqe with lines for rider controls
RPMvsTorquePlot(CoreData)
%throttle vs actual current
ThrottleCurrentComparePlot(CoreData)
%vehicle speed calculator
VelocityPlot(CoreData)
%DC bus voltage and DC bus current
DCVoltageCurrentPlot(CoreData)
%DC bus power
DCBusPowerPlot(CoreData)
