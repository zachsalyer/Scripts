function [summary, channelList]=mdfchannelgroupinfo(MDFStructure)
% Returns summary information of an MDF file (summary) taken from the
% MDFstrusture data structure and a cell array containing many
% important fields of informtation for each channel in the file
% (channelList)
% Copyright 2006-2014 The MathWorks, Inc.

  numberOfDataGroups=double(MDFStructure.HDBlock.numberOfDataGroups);
  channelGroup=1;
  fieldNames=fieldnames(MDFStructure.DGBlock(1).CGBlock(channelGroup).CNBlock);
  startChannel=1;
  
  for dataBlock = 1: numberOfDataGroups
    
    numberOfChannels=double(MDFStructure.DGBlock(dataBlock).CGBlock(channelGroup).numberOfChannels);
    numberOfRecords=double(MDFStructure.DGBlock(dataBlock).CGBlock(channelGroup).numberOfRecords);
    endChannel=startChannel+numberOfChannels-1;
    
    % Make summary
    summary(dataBlock,1).numberOfChannels=numberOfChannels;
    summary(dataBlock,1).numberOfRecords=numberOfRecords;
    summary(dataBlock,1).rateVariableSampled=MDFStructure.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(1).rateVariableSampled;
    channelCells=[fieldNames struct2cell(MDFStructure.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock)];
    
    % Signal Name and descriptions
    signalNames=channelCells(4,:)'; % Signal names
    longSignalNames=channelCells(14,:)'; % Long names
    useNames=cell(size(signalNames)); % Pre allocate
    
    for signal=1:length(signalNames)
      if isempty(longSignalNames{signal}) % If no long name, use signal name
        useNames(signal)=signalNames(signal);
      else
        useNames(signal)=longSignalNames(signal); % Use Long name
      end
    end
    summary(dataBlock,1).signalNamesandDescriptions(:,1)=useNames;
    summary(dataBlock,1).signalNamesandDescriptions(:,2)=channelCells(5,:)';
    
    % Other
    summary(dataBlock,1).channelCells=channelCells;
    
    % Make channel List
    channelCells2=struct2cell(MDFStructure.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock);
    
    % Signal Names
    signalNames=channelCells2(4,:)'; % Signal names
    longSignalNames=channelCells2(14,:)'; % Long names
    useNames=cell(size(signalNames)); % Pre allocate
    
    for signal=1:length(signalNames)
      if length(signalNames{signal})>length(longSignalNames{signal}) % If signal name longer use it
        useNames(signal)=signalNames(signal);
      else
        useNames(signal)=longSignalNames(signal); % Use Long name
      end
    end
    
    channelList(startChannel:endChannel,1)= useNames; % Names
    
    channelList(startChannel:endChannel,2)= channelCells2(5,:)'; % Descriptons
    channelList(startChannel:endChannel,3)= num2cell((1:numberOfChannels)');
    channelList(startChannel:endChannel,4)={dataBlock};
    channelList(startChannel:endChannel,5)={MDFStructure.DGBlock(dataBlock).CGBlock.CNBlock(1).rateVariableSampled};
    channelList(startChannel:endChannel,6)={numberOfRecords};
    channelList(startChannel:endChannel,7)=channelCells2(7,:)';
    channelList(startChannel:endChannel,8)=channelCells2(8,:)';
    channelList(startChannel:endChannel,9)=channelCells2(3,:)';
    channelList(startChannel:endChannel,10)={MDFStructure.DGBlock(dataBlock).CGBlock.TXBlock.comment};
    
    startChannel=endChannel+1;
    
  end
end