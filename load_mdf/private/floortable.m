function floorData=floortable(int_table,phys_table,int)
% FLOORTABLE return physcial values looked up
%   FLOORTABLE(INT_TABLE,PHYS_TABLE,INT) returns the physical value
%   from PHYS_TABLE corresponding to the value in INT_TABLE that is closest
%   to and less than INT.

%   Example:
%   floorData=floortable([1 5 7],[10 50 70],3);
% Copyright 2006-2014 The MathWorks, Inc.

  if ~all(diff(int_table)>=0)
    error('Table not monotically increasing');
  end
  
  int=double(int);
  if min(size(int_table))==1 || min(size(phys_table))==1
    
    % Saturate data to min and max
    int(int>int_table(end))= int_table(end);
    int(int<int_table(1))= int_table(1);
    floorData=zeros(size(int)); % Preallocate
    
    % Look up value in table
    for k=1:length(int)
      differences=(int(k)-int_table);
      nonNegative=differences>=0;
      [floorInt,index]=min(differences(nonNegative));
      temp=phys_table(nonNegative);
      floorData(k)=temp(index);
    end
    
  else
    error('Only vector input supported');
  end
end