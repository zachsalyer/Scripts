function requestedChannelList=readtextfile(fileName)
% Reads (signal selection) text file one line at a time
% and returns eac hline in a cell array
% Copyright 2006-2014 The MathWorks, Inc.

  fid=fopen(fileName,'rt'); % Open text file for reading
  
  signalName=1; % Initialize counter
  requestedChannelList{signalName}=''; % Initialize cells
  
  while ~feof(fid)
    requestedChannelList{signalName,1}=fgetl(fid); % Read one line
    signalName=signalName+1; % Increment counter
  end
  fclose(fid); % Close file
end