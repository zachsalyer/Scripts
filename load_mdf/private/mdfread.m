function [data, signalNames]=mdfread(file,dataBlock,varagin)
% MDFREAD Reads MDF file and returns all the channels and signal names of
% one data group in an MDF file.
%
%   DATA = MDFREAD(FILENAME,DATAGROUP) returns in the cell array DATA, all channels
%   from data group DATAGROUP from the file FILENAME.
%
%   DATA = MDFREAD(MDFINFO,DATAGROUP) returns in the cell array DATA,  all channels
%   from data group DATAGROUP from the file whos information is in the data
%   structure MDFINFO returned from the function MDFINFO.
%
%
%   [..., SIGNALNAMES] = MDFREAD(...) Creates a cell array of signal names
%   (including time).
%
%    Example 1:
%
%             %  Retrieve info about DICP_V6_vehicle_data.dat
%             [data signaNames]= mdfread('DICP_V6_vehicle_data.dat');
% Copyright 2006-2014 The MathWorks, Inc.


  % Assume for now only sorted files supported
  channelGroup=1;

  % Get MDF structure info
  if ischar(file)
    fileName=file;
    [MDFsummary MDFInfo]=mdfinfo(fileName);
  else
    MDFInfo=file;
  end
  
  numberOfChannels=double(MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).numberOfChannels);
  numberOfRecords= double(MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).numberOfRecords);
  
  if nargin==3
    selectedChannels=varagin; % Define channel selection vector
    if any(selectedChannels>numberOfChannels)
      error('Select channel out of range');
    end
  end
  
  if numberOfRecords==0 % If no data record, ignore
    warning(['No data records in block ' int2str(dataBlock) ]);
    data=cell(1); % Return empty cell
    signalNames=''; % Return empty cell
    return
  end
  
  %% Set pointer to start of data
  offset=MDFInfo.DGBlock(dataBlock).pointerToDataRecords; % Get pointer to start of data block
  
  %% Create channel format cell array
  for channel=1:numberOfChannels
    numberOfBits= MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).numberOfBits;
    signalDataType= MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).signalDataType;
    datatype=datatypeformat(signalDataType,numberOfBits); %Get signal data type (e.g. 'int8')
    if signalDataType==7 % If string
      channelFormat(channel,:)={datatype [1 double(numberOfBits)/8] ['channel' int2str(channel)]};
    else
      channelFormat(channel,:)={datatype [1 1] ['channel' int2str(channel)]};
    end
  end
  
  %% Check for multiple record IDs
  numberOfRecordIDs=MDFInfo.DGBlock(dataBlock).numberOfRecordIDs; % Number of RecordIDs
  if numberOfRecordIDs==1 % Record IDs
    channelFormat=[ {'uint8' [1 1] 'recordID1'} ; channelFormat]; % Add column to start get record IDs
  elseif numberOfRecordIDs==2
    error('2 record IDs Not suported')
    %channelFormat=[ channelFormat ; {'uint8' [1 1] 'recordID2'}]; % Add column to end get record IDs
  end
  
  %% Check for time channel
  timeChannel=findtimechannel(MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock);
  
  if length(timeChannel)~=1
    error('More than one time channel in data block');
  end
  
  %% Open File
  fid=fopen(MDFInfo.fileName,'r');
  if fid==-1
    error(['File ' MDFInfo.fileName ' not found']);
  end
  
  %% Read data
  
  % Set file pointer to start of channel data
  fseek(fid,double(offset),'bof');
  
  if ~exist('selectedChannels','var')
    if numberOfRecordIDs==1 % If record IDs are used (unsorted)
      Blockcell = mdfchannelread(channelFormat,fid,numberOfRecords); % Read all
      recordIDs=Blockcell(1);         % Extract Record IDs
      Blockcell(1)=[];                % Delete record IDs
      selectedChannels=1:numberOfChannels; % Set selected channels
    else
      Blockcell = mdfchannelread(channelFormat,fid,numberOfRecords); % Read all
      selectedChannels=1:numberOfChannels; % Set selected channels
    end
  else % if selectedChannels exists
    if numberOfRecordIDs==1  % If record IDs are used (unsorted)
      % Add Record ID column no mater the orientation of selectedChannels
      newSelectedChannels(2:length(selectedChannels)+1)=selectedChannels+1; % Shift
      newSelectedChannels(1)=1; % Include first channel of Record IDs
      Blockcell = mdfchannelread(channelFormat,fid,numberOfRecords,newSelectedChannels);
      recordIDs=Blockcell(1);         % Extract Record IDs, for future expansion
      Blockcell(1)=[];                % Delete record IDs,  for future expansion
    else
      Blockcell = mdfchannelread(channelFormat,fid,numberOfRecords,selectedChannels);
    end
  end
  
  % Cloce file
  fclose(fid);
  
  % Preallocate
  data=cell(1,length(selectedChannels)); % Preallocate cell array for channels
  
  % Extract data
  for selectedChannel=1:length(selectedChannels)
    channel=selectedChannels(selectedChannel); % Get delected channel
    
    % Get signal names
    longSignalName=[MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).longSignalName MDFInfo.DGBlock(dataBlock).CGBlock.CNBlock(channel).CCBlock.physicalUnit];
    if ~isempty(longSignalName) % if long signal name is not empty use it
      signalNames{selectedChannel,1}=longSignalName; % otherwise use signal name
    else
      signalNames{selectedChannel,1}= [MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).signalName MDFInfo.DGBlock(dataBlock).CGBlock.CNBlock(channel).CCBlock.physicalUnit];
    end
    
    if MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).signalDataType==7
      % Strings: Signal Data Type 7
      data{selectedChannel}=truncintstochars(Blockcell{selectedChannel}); % String
    elseif MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).signalDataType==8
      % Byte arrays: Signal Data Type 8
      error('MDFReader:signalType8','Signal data type 8 (Byte array) not currently supported');
      
      %     elseif MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).valueRangeKnown % If physical value is correct...
      %         % No need for conversion formula
      %         data{selectedChannel}=double(Blockcell{selectedChannel});
    else
      % Other data types: Signal Data Type 0,1,2, or 3
      
      % Get conversion formula type
      conversionFormulaIdentifier=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.conversionFormulaIdentifier;
      
      % Based on each convwersion fourmul type...
      switch conversionFormulaIdentifier
        case 0 % Parameteric, Linear: Physical =Integer*P2 + P1
          
          % Extract coefficients from data structure
          P1=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.P1;
          P2=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.P2;
          int=double(Blockcell{selectedChannel});
          data{selectedChannel}=int.*P2 + P1;
          
        case 1 % Tabular with interpolation
          
          % Extract look-up table from data structure
          int_table=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.int;
          phys_table=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.phys;
          int=Blockcell{selectedChannel};
          data{selectedChannel}=interptable(int_table,phys_table,int);
          
        case 2 % Tabular
          
          % Extract look-up table from data structure
          int_table=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.int;
          phys_table=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.phys;
          int=Blockcell{selectedChannel};
          data{selectedChannel}=floortable(int_table,phys_table,int);
          
        case 6 % Polynomial
          
          % Extract polynomial coefficients from data structure
          P1=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.P1;
          P2=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.P2;
          P3=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.P3;
          P4=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.P4;
          P5=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.P5;
          P6=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.P6;
          
          int=double(Blockcell{selectedChannel}); % Convert to doubles
          numerator=(P2-P4.*(int-P5-P6)); % Evaluate numerator
          denominator=(P3.*(int-P5-P6)-P1); % Evaluate denominator
          
          % Avoid divide by zero warnings and return nan
          denominator(denominator==0)=nan; % Set 0's to Nan's
          result=numerator./denominator;
          
          data{selectedChannel}=result;
          
        case 10 % ASAM-MCD2 Text formula
          textFormula=MDFInfo.DGBlock(dataBlock).CGBlock(channelGroup).CNBlock(channel).CCBlock.textFormula;
          x=double(Blockcell{selectedChannel}); % Assume stringvariable is 'x'
          data{selectedChannel}=eval(textFormula); % Evaluate string
          
        case 65535 % 1:1 conversion formula (Int = Phys)
          data{selectedChannel}=double(Blockcell{selectedChannel});
          
        case {11, 12} % ASAM-MCD2 Text Table or ASAM-MCD2 Text Range Table
          % Return numbers instead of strings/enumeration
          data{selectedChannel}=double(Blockcell{selectedChannel});
          
        otherwise % Un supported conversion formula
          error('MDFReader:conversionFormulaIdentifier','Conversion Formula Identifier not supported');
          
      end
    end
  end
end