function sout = mdfload(fileInfo,varargin)
% MDFLOAD Reads an MDF file and returns the signals
% into the workspace creating individual variables or each channel.
% The time channel is renamed 'time' if it is not so named

%storageType='';
% Copyright 2006-2014 The MathWorks, Inc.

  % Inspect fileInfo variable
  switch class(fileInfo)
    case 'char' % If its a filename...
      [MDFsummary MDFInfo counts]=mdfinfo(fileInfo); % ...load it
    case  'struct' % If its a structure...
      MDFInfo=fileInfo; % ...just copy it
  end
  
  
  % Default settings
  blockDesignation='ratenumber';
  
  % Set variables based on input parameters
  switch nargin
    
    case 1 % Select all signals for all data blocks
      % Set to all blocks
      selectedDatablocks=1:double(MDFInfo.HDBlock.numberOfDataGroups); % Linear array
      
    case 2 % Select all signals from specified data block
      % Set specified block
      selectedDatablocks=varargin{1};
      
    case 3 % Select specified signals from specified data block
      selectedChannels= varargin{2}; % Set specified channels
      selectedDatablocks=varargin{1}; % Set specified block
      
    case 4 % Select specified signals from specified data block
      blockDesignation= varargin{3}; % 'ratenumber' or 'ratestring'
      selectedChannels= varargin{2}; % Set specified channels
      selectedDatablocks=varargin{1}; % Set specified block
      
    case 5 % Import location
      ws= varargin{4}; % import location
      blockDesignation= varargin{3}; % 'ratenumber' or 'ratestring'
      selectedChannels= varargin{2}; % Set specified channels
      selectedDatablocks=varargin{1}; % Set specified block
      
    case 6 %  Additional text
      additionalText=varargin{5}; % Additional text
      ws= varargin{4}; % import location
      blockDesignation= varargin{3}; % 'ratenumber' or 'ratestring'
      selectedChannels= varargin{2}; % Set specified channels
      selectedDatablocks=varargin{1}; % Set specified block
      
    otherwise % Error
      error('Wrong number of parameters');
  end
  
  numValidBlocks=0; % Initialize block count
  totalNumChannels=0; % Initialize channel count
  
  for dataBlock=selectedDatablocks % For each (either one or all)
    
    % Find time channel
    timeChannel=findtimechannel(MDFInfo.DGBlock(dataBlock).CGBlock(1).CNBlock);
    
    numberOfRecords= MDFInfo.DGBlock(dataBlock).CGBlock(1).numberOfRecords; % Number of records in this block
    rateComment=MDFInfo.DGBlock(dataBlock).CGBlock.TXBlock.comment; % Comment rate for this block
    if numberOfRecords>=1 % As long as there is at least one record...
      
      numValidBlocks=numValidBlocks+1; % Increment block count
      
      % Load data
      if ~exist('selectedChannels','var') % If signals are not specified...
        [data signalNames]=mdfread(MDFInfo,dataBlock); % Load all signals
        
      else % If signals are specified...
        [data signalNames]=mdfread(MDFInfo,dataBlock,selectedChannels); % Load specified signals
      end
      
      % Assign columns of data into workspace as seperate variables
      for k=1: length(signalNames) % For each signal
        
        if selectedChannels(k)==timeChannel;
          signalNames{k}='time'; % Overide to time string if time channel
        else
          signalNames{k}=removedevicenames(signalNames{k}); % Remove device names
        end
        
        % Construct variable name
        if ~exist('additionalText','var') % If not defined, set to empty string
          additionalText='';
        end
        % Determine if numbers or rate strings are to be used to
        % designatr the different rate variables
        switch blockDesignation
          case 'ratenumber'
            varEnding=int2str(dataBlock);
            varName= [signalNames{k} '_' varEnding additionalText];
          case 'ratestring'
            varEnding=rateComment;
            varName=[signalNames{k} '_' varEnding additionalText];
          otherwise
            error('Block designator not known');
        end
        varName=mygenvarname(varName); % Make legal if you can
        
        % Test if legal, then assign to variable
        if ~exist('ws','var')
          ws='base';
        end
        
        if isvarname(varName)  % If legal
          if nargout == 0
            assignin(ws, varName, data{k}); % Save it in choose location
          else                               
            sout.(varName) = data{k};    % Store in a struct 
          end
        else % If not
          warning(['Ignoring modified signal name ''' varName '''. Cannot be turned into a variable name.']);
        end
        
        totalNumChannels=totalNumChannels+1;
      end
      
      % Display what was generated in command window
      tempvar=mygenvarname(['x_' varEnding additionalText]);  % Calculate var name
      if exist('selectedChannels','var') % If channel selction have been specified (if a called fom mdfimport tool)
        if ismember(timeChannel,selectedChannels) % If one of the channels selected is time
          disp(['Created ' int2str(length(signalNames)-1) ' signal variable(s) appended with ''' tempvar(2:end) ''' for ''' rateComment ''' rate']);
          disp(['... and 1 actual time vector ''' mygenvarname(['time_' varEnding additionalText]) '''']);
        else
          disp(['Created ' int2str(length(signalNames)) ' signal variable(s) appended with ''' tempvar(2:end) ''' for ''' rateComment ''' rate']);
        end
      else
        disp(['Created ' int2str(length(signalNames)-1) ' signal variable(s) appended with ''' tempvar(2:end) ''' for ''' rateComment ''' rate']);
        disp(['... and 1 actual time vector ''' mygenvarname(['time_' varEnding additionalText]) '''']);
      end
      
    end
  end
end