function Block=mdfblockread(blockFormat,fid,offset,repeat)
% MDFBLOCKREAD Extract block of data from MDF file in orignal data types
%   Block=MDFBLOCKREAD(BLOCKFORMAT, FID, OFFSET, REPEAT) returns a
%   structure with field names specified in data structure BLOCKFORMAT, fid
%   FID, at byte offset in the file OFFSET and repeat factor REPEAT
%
% Example block format is:
% blockFormat={...
%     UINT8  [1 4]  'ignore';...
%     INT32  [1 1]  'pointerToFirstDGBlock';  ...
%     UINT8  [1 8]   'ignore';  ...
%     UINT16 [1 1]  'numberOfDataGroups'};
%
% Example function call is:
% Block=mdfblockread(blockFormat, 1, 413, 1);
% Copyright 2006-2014 The MathWorks, Inc.

  % Extract parameters
  numFields=size(blockFormat,1); % Number of fields
  precisions=blockFormat(:,1); % Precisions (data types) of each field
  fieldnames=blockFormat(:,3); % Field names
  
  % Number of elements of a data type in one field
  % This is only not relevent to one for string arrays
  
  % Calculate counts variable to store number of data types
  % For R14SP3: counts= cellfun(@max,blockFormat(:,2));
  counts=zeros(numFields,1);
  for k=1:numFields
    %counts(k)=max(blockFormat{k,2});
    counts(k)=blockFormat{k,2}(end); % Get last value
  end
  
  fseek(fid,double(offset),'bof');
  for record=1:double(repeat)
    for field=1:numFields
      count=counts(field);
      precision=precisions{field};
      fieldname=fieldnames{field};
      if strcmp(fieldname,'ignore')
        fseek(fid,getsize(precision)*count,'cof');
      else
        Block.(fieldname)(record,:)=fread(fid,count,['*' precision])';
      end
    end
  end
end