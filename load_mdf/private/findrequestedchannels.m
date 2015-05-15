function [selectedChannelList,unselectedChannelList]=findrequestedchannels(requestedChannelList,oldUnselectedChannelList)
% Searches the cell array unselectedChannelList to find all the signals
% listed in requestedChannelList. The results are put in
% selectedChannelList and teh onces left are placed in
% unselectedChannelList
% Copyright 2006-2014 The MathWorks, Inc.

  notFoundSignals=[]; % Initialize
  selectedChannelList=[]; % Initialize
  unselectedChannelList=oldUnselectedChannelList; % Initialize to starting list
  
  numRequestedChannels=length(requestedChannelList); % Calculate number of requested channels
  
  for channel=1:numRequestedChannels % For each requested channel
    % Get cell array of strings of names to check
    unselectedChannelListNoDeviceNames=removedevicenames(unselectedChannelList(:,1)); % Remove device names
    
    % Find selected channel(s) in list
    found=zeros(size(unselectedChannelList,1),1)~=0; % Preallocate
    for checkChannel=1:size(unselectedChannelList,1)
      found(checkChannel,1)=strcmp(... % Find each request channel in unselected list
        unselectedChannelListNoDeviceNames{checkChannel,1},requestedChannelList{channel});
    end
    
    % Move found channel(s) from unselected to selected (should be just
    % one. Could be expanded in future to allow selecting of multiple channels)
    selectedChannelList=[selectedChannelList;unselectedChannelList(found,:)];
    unselectedChannelList(found,:)=[]; % Clear unselected channel(s)
    unselectedChannelListNoDeviceNames(found)=[]; % Clear unselected channel(s) from name list too
    
    
    if sum(found)>1 % Warn if more than one signal found matching requested signal name
      disp('More than one signal found matching requested signal name');
    end
    if sum(found)==0 % Keep tally of the names of the signals that were not found
      notFoundSignals=[notFoundSignals;requestedChannelList(channel)];
    end
    
  end
  
  if  length(notFoundSignals)>0 % If some were not found, display message
    disp(['The following ' int2str(length(notFoundSignals)) ' signal(s) were not found in MDF file']);
    disp(notFoundSignals);
  end
end