function  truncstring=truncintstochars(ints)
% Converts an array of integers to characters and truncates the string to
% the first non zero integers.
% Copyright 2006-2014 The MathWorks, Inc.

  [m,n]=size(ints);
  
  if m > 1 % if multiple strings
    truncstring=cell(m,1); %preallocate
  end
  
  for k=1:m % for each row
    lastchar=find(ints(k,:)==0)-1;
    
    if isempty(lastchar) % no blanks
      truncstring{k}=char(ints(k,:));
    else
      lastchar=lastchar(1); % Get first
      truncstring{k}=char(ints(k,1:lastchar));
    end
  end
  
  if m == 1 % If just one string
    truncstring=truncstring{1}; % Convert to char
  end
end