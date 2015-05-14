function tx = formatstxtext(blockSize)
% Return format for txt block section
% Copyright 2006-2014 The MathWorks, Inc.

  tx= [{'uint8'}  {[1 double(blockSize)]}  {'comment'}];
end