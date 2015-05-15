function Block=mdfchannelread(blockFormat,fid,repeat,varagin)
% Copyright 2006-2014 The MathWorks, Inc.

  % Store starting point of file pointer
  offset=ftell(fid);
  
  if nargin==4
    selectedChannels=varagin; % Define channel selection vector
  end
  
  % Extract parameters
  numFields=size(blockFormat,1); % Number of fields
  precisions=blockFormat(:,1); % Precisions (data types) of each field
  
  % Number of elements of a data type in one field
  % This is only not relevent to one for string arrays
  
  % For R14SP3: counts= cellfun(@max,blockFormat(:,2));
  counts=zeros(numFields,1);
  for k=1:numFields
    counts(k,1)=max(blockFormat{k,2});
  end
  
  % For R14 SP3: numFieldBytes=cellfun(@getsize,precisions).*counts;
  
  % Number of bytes in each field
  for k=1:numFields
    numFieldBytes(k,1)=getsize(precisions{k}).*counts(k); % Number of bytes in each field
  end
  
  numBlockBytes=sum(numFieldBytes); % Total number of bytes in block
  numBlockBytesAligned=ceil(numBlockBytes); % Aligned to byte boundary
  cumNumFieldBytes=cumsum(numFieldBytes); % Cumlative number of bytes
  startFieldBytes=[0; cumNumFieldBytes]; % Starting number of bytes for each field relative to start
  
  % Preallocate Clock cell array
  Block= cell(1,numFields);
  
  % Find groups of fields with the same data type
  fieldGroup=1;
  numSameFields(fieldGroup)=1;
  countsSameFields(fieldGroup)=counts(1);
  for field =1:numFields-1
    if strcmp(precisions(field),precisions(field+1))& counts(field)==counts(field+1) % Next field is the same data type
      numSameFields(fieldGroup,1)=numSameFields(fieldGroup,1)+1; % Increment counter
      
    else
      numSameFields(fieldGroup+1,1)=1; % Set to 1...
      countsSameFields(fieldGroup+1)=counts(field+1);
      fieldGroup=fieldGroup+1; % ...and more to next filed group
    end
  end
  
  field=1;
  for fieldGroup=1:length(numSameFields)
    
    % Set pointer to start of fieldGroup
    offsetPointer=offset+startFieldBytes(field);
    fseek(fid,offsetPointer,'bof');
    
    count=1*repeat; % Number of rows repeated
    precision=precisions{field}; % Extract precision of all channels in field
    
    % Calculate precision string
    if strcmp(precision, 'ubit1')
      skip=8*(numBlockBytesAligned-getsize(precision)*numSameFields(fieldGroup)); % ensure byte aligned
      precisionString=[int2str(numSameFields(fieldGroup)) '*ubit1=>uint8'];
    elseif strcmp(precision, 'ubit2')
      skip=8*(numBlockBytesAligned-getsizealigned(precision)*numSameFields(fieldGroup)); % ensure byte aligned
      precisionString=[int2str(numSameFields(fieldGroup)) '*ubit2=>uint8']; % TO DO change skip to go to next byte
    else
      skip=numBlockBytesAligned-getsize(precision)*countsSameFields(fieldGroup)*numSameFields(fieldGroup); % ensure byte aligned
      precisionString=[int2str(numSameFields(fieldGroup)*countsSameFields(fieldGroup)) '*' precision '=>' precision];
    end
    
    % Read file
    if countsSameFields(fieldGroup)==1  % TO Do remove condistiuon
      data=fread(fid,double(count)*numSameFields(fieldGroup),precisionString,skip);
    else %% string
      % Read in columnwize, ech column is a string lengt - countsSameFields(fieldGroup)
      data=fread(fid,double([countsSameFields(fieldGroup) count*numSameFields(fieldGroup)]),precisionString,skip);
      data=data';
    end
    
    % Copy each field from the field group into the cell array
    if numSameFields(fieldGroup)==1
      Block{field}=data;
      field=field+1;
    else
      for k=1:numSameFields(fieldGroup)
        Block{field}=data(k:numSameFields(fieldGroup):end);
        field=field+1;
      end
    end
  end
  if exist('selectedChannels','var')
    Block=Block(:,selectedChannels);
  end
  
  %% Align to start of next row
  current=ftell(fid); % Current poisition
  movement=current-offset; % Distance gone
  remainder=rem(movement,numBlockBytesAligned); % How much into next row it is
  fseek(fid,-remainder,'cof'); % Rewind to start of next row
  
end