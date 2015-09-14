function options=parseparameters(parameters)
% 1) filename: 'sdfdsf.dat' required
% 2) import to: ['workspace'], 'sdfds.mat'(test valid),  empty,
% 3) selecton file: ['all'], 'xxx.txt' (test valid), cell array of stings, empty
% 4) time vector times:  ['actual'], 'uniform', empty
% 5) rate desination: ['ratenumber'], 'ratestring', empty
%
% help funtion to parse parameters when being called from command line
% Copyright 2006-2014 The MathWorks, Inc.

  % Process 1st parameter: File name
  % Check file name of MDF file
  if ~exist(parameters{1},'file') %TO Do put back
    error(['Can''t find MDF file ' parameters{1}]);
  end
  options.fileName=parameters{1}; % 1) File name
  
  
  % Get MDF info
  [MDFsummary, options.MDFInfo, counts, channelList]=mdfinfo(options.fileName);
  
  timeChannels=cell2mat(channelList(:,9))==1;
  channelList(timeChannels,:)=[]; % Delete time channels to create 'all' selection list
  
  timeChannels=cell2mat(channelList(:,8))==7; % To DO
  channelList(timeChannels,:)=[]; % Delete string channels to create 'all' selection list
  
  
  % Process 2nd parameter: import location
  if length(parameters)>=2 % If 2nd paramter provided...
    % Is it empty or equal to 'workspace'
    if isempty(parameters{2}) || strcmpi(parameters{2},'workspace')
      options.importTo='workspace';  % then 'workspace' is the choose import location
      % Otherwise, if  it is equal to 'Auto MAT-File'...
    elseif strcmpi(parameters{2},'Auto MAT-File')
      options.importTo=[options.fileName(1:end-4) '.mat']; % Then an auto named MAT file is the import location
      % Otherwise, if ends in .mat...
    elseif strcmpi(parameters{2}(end-3:end),'.mat')
      options.importTo=parameters{2}; % Then use the specified MAT file
      % Otherwise, error out.
    else
      error(['2nd parameter ''' parameters{2} ''' is not valid. Should be either ''workspace'', ''Auto MAT-File'', a MAT file name or empty.']);
    end
  else
    options.importTo='workspace'; % Default
  end
  
  
  %% Process 3rd parameter: signal selection
  if length(parameters)>=3
    
    % 3) selecton file: ['all'], 'xxx.txt' (test valid), cell array of
    % stings, empty
    if length(parameters{3})>=5 % Test if long enough to be a file name
      txtFile=strcmpi(parameters{3}(end-3:end),'.txt'); % check for txt file
    end
    if isempty(parameters{3})  % a) Empty
      options.selectedChannelList=channelList; % Import all channels
      options.importAllChannels=true;
    elseif isa(parameters{3},'char') % If text value
      if strcmpi(parameters{3},'all') % a) all is only valid text value
        options.selectedChannelList=channelList; % Import all channels
        options.importAllChannels=true;
        
      elseif txtFile % b) Use specified txt file
        if exist(parameters{3},'file')
          requestedChannelList=readtextfile(parameters{3}); % Load file
          [selectedChannelList,unselectedChannelList]=...
            findrequestedchannels(requestedChannelList,channelList);
          options.selectedChannelList=selectedChannelList;
          options.importAllChannels=false;
        else
          error(['Can''t read signal selection file ' parameters{3}]);
        end
        
      else % Must be one signal name
        requestedChannelList={parameters{3}}; % Put teh one siganl in a cell
        [selectedChannelList,unselectedChannelList]=...
          findrequestedchannels(requestedChannelList,channelList);
        options.selectedChannelList=selectedChannelList;
        options.importAllChannels=false;
        %error(['3rd parameter ' parameters{3}... % Error
        %' is not valid.''all'' is the only valid text string. Put signal names in a cell array']);
      end
      
    elseif isa(parameters{3},'cell') % c) Cell array
      requestedChannelList=parameters{3};
      [selectedChannelList,unselectedChannelList]=...
        findrequestedchannels(requestedChannelList,channelList);
      options.selectedChannelList=selectedChannelList;
      options.importAllChannels=false;
      
    else
      error(['3rd parameter ''' parameters{3} ''' is not valid. Should be either ''all'', a cell array of signal names, one signal name char array (string) or a signal selection file name']);
    end
  else
    options.selectedChannelList=channelList; % Default
    options.importAllChannels=true; % Default
  end
  
  %% % Process 4th parameter: time vector instants
  if length(parameters)>=4
    if isempty(parameters{4}) | strcmpi(parameters{4},'actual') % a) Empty or actual
      options.timeVectorChoice='actual';
    elseif strcmpi(parameters{4},'ideal')
      options.timeVectorChoice='ideal';
    else
      error(['4th parameter ''' parameters{4} ''' is not valid. Should be ''actual'' or ''ideal''']);
    end
  else
    options.timeVectorChoice='actual'; % Default
  end
  
  %% Process 5th parameter: rate designation
  if length(parameters)>=5 % Import location
    if isempty(parameters{5}) | strcmpi(parameters{5},'ratenumber') % a) Empty or number
      options.blockDesignation='ratenumber';
    elseif strcmpi(parameters{5},'ratestring')
      options.blockDesignation='ratestring';
    else
      error(['5th parameter ''' parameters{5} ''' is not valid. Should be ''ratenumber'' or ''ratestring''']);
    end
  else
    options.blockDesignation='ratenumber'; % Default
  end
  
  %% Process 6th parameter: additional text
  if length(parameters)>=6 & ~isempty(parameters{6})
    if isa(parameters{6},'char')
      options.additionalText=parameters{6};
    else
      error(['6th parameter ''' parameters{6} ''' is not valid. Must be a char array (string) or empty']);
    end
  else
    options.additionalText=''; % Default
  end
  
  %% Error if more than 6 parameters
  if length(parameters)>=7
    error('Too many parameters');
  end
  
  %% Other parameters
  % These not defined when called from command line
  [rateStrings,possibleRates,possibleRateIndices]=processrates(options.selectedChannelList);
  options.possibleRateIndices=possibleRateIndices;
  options.possibleRates=possibleRates;
  options.waitbarhandle=[];
  
end