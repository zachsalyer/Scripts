%this script runs all of the available plotting functions
close all;


%motor cooling loop temps
MotorCoolingPlot(data)
%inverter cooling loop temps
ControllerCoolingPlot(data)
%scatterplot of rpm vs torqe with lines for rider controls
RPMvsTorquePlot(data)
%vehicle speed calculator
VelocityPlot(data)
%DC bus voltage and DC bus current
DCVoltageCurrentPlot(data)
%DC bus power
DCBusPowerPlot(data)
%Cell temperature
CellTempPlot(data)