function timeChannel=findtimechannel(CNBlock)
% Finds the locations of time channels in the channel block
% Take channel blcok array of structures
% Copyright 2006-2014 The MathWorks, Inc.


  channelsFound=0; % Initialize to number of channels found to 0
  
  % For each channel
  for channel = 1: length(CNBlock)
    if CNBlock(channel).channelType==1; % Check to see if is time
      channelsFound=channelsFound+1; % Increment couner of found time channels
      timeChannel(channelsFound)=channel; % Store time channel location
    end
  end

end