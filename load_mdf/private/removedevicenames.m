function varName=removedevicenames(signalName)
% Removes device names from the end of the signal name strings
% Outputs column vector
% Copyright 2006-2014 The MathWorks, Inc.

  % Logical saying is input is string as opposed to cell array
  stringinput=0;
  if ischar(signalName) % If just one string input
    signalName={signalName};
    stringinput=1;
  end
  
  % Find location of '\' characters
  for signal =1:length(signalName)
    indices{signal,1}=strfind(signalName{signal},'\');
  end
  %indices=strfind(signalName,'\'); % Find instances of '\' later version handles cell arrays
  
  for signal=1:length(signalName) % For each signal
    
    if isempty(indices{signal}); % If not '\' characters in name
      varName(signal,1)=signalName(signal); % ...just copy, its fine
    else % If there are '\' characters in name
      if signalName{signal}(1)=='\' % If first character is '\'
        error('Bad signal name, begins with ''\'''); % Error out
      end
      varName{signal,1}=signalName{signal}(1:indices{signal}(1)-1); % Extract up to first '\'
    end
  end
  
  if stringinput
    varName=varName{1}; % Remove scell and return a string
  end
end

% varName=signalName;
% varName = strrep(varName,'\ETKC:1','');
% varName = strrep(varName,'\device1','');
% varName = strrep(varName,'\ETK-Testdevice:1','');
% varName = strrep(varName,'\ETK-Testdevice:1/x','');
% varName = strrep(varName,'\ETK test device:1','');
% varName = strrep(varName,'\VADI-Testdevice:1','');
% varName = strrep(varName,'\CCP:1','');
% varName = strrep(varName,'\CCP:2','');
% %varName = strrep(varName,'\','');
% varName = strrep(varName,'\AD-Scan:1','');
% varName = strrep(varName,'\Thermo-Scan:1','');
% %varName = strrep(varName,'2ndPress','SecondPress');
