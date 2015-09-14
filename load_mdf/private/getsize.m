function sz = getsize(f)
% GETSIZE returns the size in bytes of the data type f
%
%   Example: 
%
% a=getsize('uint32');
% Copyright 2006-2014 The MathWorks, Inc.

  switch f
    case {'double', 'uint64', 'int64'}
      sz = 8;
    case {'single', 'uint32', 'int32'}
      sz = 4;
    case {'uint16', 'int16'}
      sz = 2;
    case {'uint8', 'int8'}
      sz = 1;
    case {'ubit1'}
      sz = 1/8;
    case {'ubit2'}
      sz = 2/8; % for purposes of fread
  end
end