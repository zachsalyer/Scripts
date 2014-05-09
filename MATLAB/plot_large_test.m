errors = char('error_DC_over_volt ','error_bad_position ');
limits = char('limit_temp ','limit_velocity ' );
ydata = char('VehicleVelocity','AmbientTemp', 'BusVoltage12V');
plot_large('log1.csv','Runtime',ydata,errors,limits);
