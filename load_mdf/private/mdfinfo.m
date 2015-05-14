function [MDFsummary, MDFstructure, counts, channelList]=mdfinfo(fileName)
% MDFINFO Return information about an MDF (Measure Data Format) file
%
%   MDFSUMMARY = mdfinfo(FILENAME) returns an array of structures, one for
%   each data group, containing key information about all channels in each
%   group. FILENAME is a string that specifies the name of the MDF file.
%
%   [..., MDFSTRUCTURE] = mdfinfo(FILENAME) returns a structure containing
%   all MDF file information matching the structure of the file. This data structure
%   match closely the structure of the data file.
%
%   [..., COUNTS] = mdfinfo(FILENAME) contains the total
%   number of channel groups and channels.
% Copyright 2006-2014 The MathWorks, Inc.

  % Open file
  fid=fopen(fileName,'r');
  
  if fid==-1
    error([fileName ' not found'])
  end
  % Input information about the format of the individual blocks
  formats=blockformats;
  channelGroup=1;
  
  % Insert fileName into field or output data structure
  MDFstructure.fileName=fileName;
  
  %%% Read header block (HDBlock) information
  
  % Set file poniter to start of HDBlock
  offset=64;
  
  % Read Header block info into structure
  MDFstructure.HDBlock=mdfblockread(formats.HDFormat,fid,offset,1);
  
  %%% Read Data Group blocks (DGBlock) information
  
  % Get pointer to first Data Group block
  offset=MDFstructure.HDBlock.pointerToFirstDGBlock;
  for dataGroup=1:double(MDFstructure.HDBlock.numberOfDataGroups) % Work for older versions
    
    % Read data Data Group block info into structure
    DGBlockTemp=mdfblockread(formats.DGFormat,fid,offset,1);
    
    % Get pointer to next Data Group block
    offset=DGBlockTemp.pointerToNextCGBlock;
    
    %%% Read Channel Group block (CGBlock) information - offset set already
    
    % Read data Channel Group block info into structure
    CGBlockTemp=mdfblockread(formats.CGFormat,fid,offset,1);
    
    offset=CGBlockTemp.pointerToChannelGroupCommentText;
    
    % Read data Text block info into structure
    TXBlockTemp=mdfblockread(formats.TXFormat,fid,offset,1);
    
    % Read data Text block comment into structure after knowing length
    current=ftell(fid);
    TXBlockTemp2=mdfblockread(formatstxtext(TXBlockTemp.blockSize),fid,current,1);
    
    % Convert blockIdentifier and comment string data from uint8 to char
    TXBlockTemp.blockIdentifier=truncintstochars(TXBlockTemp.blockIdentifier);
    TXBlockTemp.comment=truncintstochars(TXBlockTemp2.comment); % accessing TXBlockTemp2
    
    % Copy temporary Text block info into main MDFstructure
    CGBlockTemp.TXBlock=TXBlockTemp;
    
    % Get pointer to next first Channel block
    offset=CGBlockTemp.pointerToFirstCNBlock;
    
    % For each Channel
    for channel=1:double(CGBlockTemp.numberOfChannels)
      
      %%% Read Channel block (CNBlock) information - offset set already
      
      % Read data Channel block info into structure
      
      CNBlockTemp=mdfblockread(formats.CNFormat,fid,offset,1);
      
      % Convert blockIdentifier, signalName, and signalDescription
      % string data from uint8 to char
      CNBlockTemp.signalName=truncintstochars(CNBlockTemp.signalName);
      CNBlockTemp.signalDescription=truncintstochars(CNBlockTemp.signalDescription);
      
      %%% Read Channel text block (TXBlock)
      
      offset=CNBlockTemp.pointerToTXBlock1;
      if double(offset)==0
        TXBlockTemp=struct('blockIdentifier','NULL','blocksize', 0);
        CNBlockTemp.longSignalName='';
      else
        % Read data Text block info into structure
        TXBlockTemp=mdfblockread(formats.TXFormat,fid,offset,1);
        
        if TXBlockTemp.blockSize>0 % If non-zero (check again)
          % Read data Text block comment into structure after knowing length
          current=ftell(fid);
          TXBlockTemp2=mdfblockread(formatstxtext(TXBlockTemp.blockSize),fid,current,1);
          
          % Convert blockIdentifier and comment string data from uint8 to char
          TXBlockTemp.blockIdentifier=truncintstochars(TXBlockTemp.blockIdentifier);
          TXBlockTemp.comment=truncintstochars(TXBlockTemp2.comment); % accessing TXBlockTemp2
          CNBlockTemp.longSignalName=TXBlockTemp.comment;
        else % If block size is zero (sometimes it is)
          TXBlockTemp=struct('blockIdentifier','NULL','blocksize', 0);
          CNBlockTemp.longSignalName='';
        end
        
      end
      % Copy temporary Text block info into main MDFstructure
      CNBlockTemp.TXBlock=TXBlockTemp;
      % NOTE: This could be removed later, only required for long name which
      % gets stored in structure seperately
      
      if CNBlockTemp.signalDataType==7 % If text only
        offset=CNBlockTemp.pointerToConversionFormula;
        CCBlockTemp=mdfblockread(formats.CCFormat,fid,offset,1);
        %% TODO to support strings
      else
        
        %%% Read Channel Conversion block (CCBlock)
        
        % Get pointer to Channel convertion block
        offset=CNBlockTemp.pointerToConversionFormula;
        
        if offset==0; % If no conversion formula, set to 1:1
          CCBlockTemp.conversionFormulaIdentifier=65535;
        else % Otherwise get conversion formula, parameters and physical units
          % Read data Channel Conversion block info into structure
          CCBlockTemp=mdfblockread(formats.CCFormat,fid,offset,1);
          
          % Extract Channel Conversion formula based on conversion
          % type(conversionFormulaIdentifier)
          
          switch CCBlockTemp.conversionFormulaIdentifier
            
            case 0 % Parameteric, Linear: Physical =Integer*P2 + P1
              
              % Get current file position
              currentPosition=ftell(fid);
              
              % Read data Channel Conversion parameters info into structure
              CCBlockTemp2=mdfblockread(formats.CCFormatFormula0,fid,currentPosition,1);
              
              % Extract parameters P1 and P2
              CCBlockTemp.P1=CCBlockTemp2.P1;
              CCBlockTemp.P2=CCBlockTemp2.P2;
              
            case 1 % Table look up with interpolation
              
              % Get number of paramters sets
              num=CCBlockTemp.numberOfValuePairs;
              
              % Get current file position
              currentPosition=ftell(fid);
              
              % Read data Channel Conversion parameters info into structure
              CCBlockTemp2=mdfblockread(formats.CCFormatFormula1,fid,currentPosition,num);
              
              % Extract parameters int value and text equivalent
              % arrays
              CCBlockTemp.int=CCBlockTemp2.int;
              CCBlockTemp.phys=CCBlockTemp2.phys;
              
            case 2 % table look up
              
              % Get number of paramters sets
              num=CCBlockTemp.numberOfValuePairs;
              
              % Get current file position
              currentPosition=ftell(fid);
              
              % Read data Channel Conversion parameters info into structure
              CCBlockTemp2=mdfblockread(formats.CCFormatFormula1,fid,currentPosition,num);
              
              % Extract parameters int value and text equivalent
              % arrays
              CCBlockTemp.int=CCBlockTemp2.int;
              CCBlockTemp.phys=CCBlockTemp2.phys;
              
            case 6 % Polynomial
              
              %  Get current file position
              currentPosition=ftell(fid);
              
              % Read data Channel Conversion parameters info into structure
              CCBlockTemp2=mdfblockread(formats.CCFormatFormula6,fid,currentPosition,1);
              
              % Extract parameters P1 to P6
              CCBlockTemp.P1=CCBlockTemp2.P1;
              CCBlockTemp.P2=CCBlockTemp2.P2;
              CCBlockTemp.P3=CCBlockTemp2.P3;
              CCBlockTemp.P4=CCBlockTemp2.P4;
              CCBlockTemp.P5=CCBlockTemp2.P5;
              CCBlockTemp.P6=CCBlockTemp2.P6;
              
            case 10 % Text formula
              
              %  Get current file position
              currentPosition=ftell(fid);
              CCBlockTemp2=mdfblockread(formats.CCFormatFormula10,fid,currentPosition,1);
              CCBlockTemp.textFormula=truncintstochars(CCBlockTemp2.textFormula);
              
            case {65535, 11,12} % Physical = integer (implementation) or ASAM-MCD2 text table
              
            otherwise
              
              % Give warning that conversion formula is not being
              % made
              warning(['Conversion Formula type (conversionFormulaIdentifier='...
                int2str(CCBlockTemp.conversionFormulaIdentifier)...
                ')not supported.']);
          end
          
          % Convert physicalUnit string data from uint8 to char
          CCBlockTemp.physicalUnit=truncintstochars(CCBlockTemp.physicalUnit);
        end
      end
      
      
      % Copy temporary Channel Conversion block info into temporary Channel
      % block info
      CNBlockTemp.CCBlock=CCBlockTemp;
      
      % Get pointer to next Channel block ready for next loop
      offset=CNBlockTemp.pointerToNextCNBlock;
      
      % Copy temporary Channel block info into temporary Channel
      % Group info
      CGBlockTemp.CNBlock(channel,1)=CNBlockTemp;
    end
    
    % Sort channel list before copying in because sometimes the first
    % channel is not listed first in the block
    pos=zeros(length(CGBlockTemp.CNBlock),1);
    for ch = 1: length(CGBlockTemp.CNBlock)
      pos(ch)=CGBlockTemp.CNBlock(ch).numberOfTheFirstBits; % Get start bits
    end
    
    [dummy,idx]=sort(pos); % Sort positions to getindices
    clear CNBlockTemp2
    for ch = 1: length(CGBlockTemp.CNBlock)
      CNBlockTemp2(ch,1)= CGBlockTemp.CNBlock(idx(ch)); % Sort blocks
    end
    
    % Copy sorted blocks back
    CGBlockTemp.CNBlock=CNBlockTemp2;
    
    % Copy temporary Channel Group block info into temporary Channel
    % Group array in temporary Data Group info
    DGBlockTemp.CGBlock(channelGroup,1)=CGBlockTemp;
    
    
    % Get pointer to next Data Group block ready for next loop
    offset=DGBlockTemp.pointerToNextDGBlock;
    
    % Copy temporary Data Group block info into Data Group array
    % in main MDFstructure ready for returning from the function
    MDFstructure.DGBlock(dataGroup,1)=DGBlockTemp;
  end
  
  % CLose the file
  fclose(fid);
  
  % Calculate the total number of Channels
  
  totalChannels=0;
  for k= 1: double(MDFstructure.HDBlock.numberOfDataGroups)
    totalChannels=totalChannels+double(MDFstructure.DGBlock(k).CGBlock.numberOfChannels);
  end
  
  % Return channel coutn information in counts variable
  counts.numberOfDataGroups=MDFstructure.HDBlock.numberOfDataGroups;
  counts.totalChannels=totalChannels;
  
  % Put summary of data groups into MDFsummary structure
  [MDFsummary, channelList]=mdfchannelgroupinfo(MDFstructure);
  
end