function handles=applyselectionfile(handles,requestedChannelList)
% Copyright 2006-2014 The MathWorks, Inc.

  % Find requested channels
  [selectedChannelList,unselectedChannelList]=findrequestedchannels(requestedChannelList,handles.channelList);

  % Update data strcuture when sure it is valid
  handles.selectedChannelList=selectedChannelList;
  handles.unselectedChannelList=unselectedChannelList;
  
  % Sort these channels
  [dummy,sortIndices]=sort(handles.selectedChannelList(:,1)); % Get sorted names
  handles.selectedChannelList=handles.selectedChannelList(sortIndices,:);
  
  % Update selected channels list box
  updatedNames=processsignalname(handles.selectedChannelList,handles.removeDeviceNames,1);
  set(handles.selectedchannellistbox,'String',updatedNames);
  
  % Update unselected channels list box
  updatedNames=processsignalname(handles.unselectedChannelList,handles.removeDeviceNames,1);
  set(handles.unselectedchannellistbox,'Value',[]); % Update unselected list
  set(handles.unselectedchannellistbox,'String',updatedNames);
  
  % Updates rate list box and edit box
  handles=updaterates(handles);
end