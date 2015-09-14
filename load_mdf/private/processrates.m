function [rateStrings, possibleRates,possibleRateIndices]=processrates(ChannelList)
% Returns a cell array of strings displaying information about the unique
% rates of the signals in ChannelList
% Copyright 2006-2014 The MathWorks, Inc.

  if size(ChannelList,1)>0
    
    formatString='%6.5f';
    
    % Get rates
    selectedDataBlocks=cell2mat(ChannelList(:,4));
    
    [possibleBlocks,lastIndices,possibleRateIndices]=unique(selectedDataBlocks); % Find all the possible data blocks
    possibleRates=cell2mat(ChannelList(lastIndices,5));
    
    % Prepend with space ' '
    rateStrings=cellstr([repmat(' ',size(possibleRates,1),1) num2str(possibleRates,formatString)]);
    timeVectorStrings=cellstr(int2str(possibleBlocks));
    
    % Append with rate strings
    rateStrings= strcat(timeVectorStrings,') ',ChannelList(lastIndices,10),' | ',rateStrings);
    
  else
    rateStrings=[]; % If no channels entered return null
    possibleRates=[];
    possibleRateIndices=[];
  end

end