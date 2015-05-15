function updatedNames=processsignalname(ChannelList,removeDeviceNames,addCGTX)
% Process the signal names in the cell array CHANNELLIST ready for displaying in the list boxes
% by adding addtional information such as rates
%
% removeDeviceNames ==1 add then remove devoce names
%
% addCGTX ==1 add the channel group block text
% 
% Copyright 2006-2014 The MathWorks, Inc.

  if size(ChannelList,1)>0 % Check that there are some names to process
    updatedNames=ChannelList(:,1); % Copy names
    
    if removeDeviceNames % If the device names are to be removed
      updatedNames=removedevicenames(updatedNames);
    end
    
    if addCGTX   % If the channel group block text is to be added
      %updatedNames=strcat(updatedNames,' (', cellstr(num2str(cell2mat(ChannelList(:,4)))),')');
      updatedNames=strcat(updatedNames,' (', ChannelList(:,10),')');
    end
  else
    updatedNames=[]; % Return null cell
  end

end