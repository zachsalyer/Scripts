function interpdata=interptable(int_table,phys_table,int)
% INTERPTABLE return physical values from look up table
%   FLOORTABLE(INT_TABLE,PHYS_TABLE,INT) returns the physical value
%   from PHYS_TABLE corresponding to the value in INT_TABLE that is closest
%   to and less than INT.
%
%   Example:
%   floorData=floortable([1 5 7],[10 50 70],3);
% Copyright 2006-2014 The MathWorks, Inc.

  if ~all(diff(int_table)>=0)
    error('Interpolation table not monotically increasing');
  end
  
  int=double(int);
  if min(size(int_table))==1 || min(size(phys_table))==1
    % Saturate data to min and max
    int(int>int_table(end))= int_table(end);
    int(int<int_table(1))= int_table(1);
    
    % Interpolate
    interpdata=interp1(int_table,phys_table,int,'linear');
    
  else
    error('Only vector input supported');
  end
end