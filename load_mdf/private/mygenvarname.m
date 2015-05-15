function varName=mygenvarname(signalName)
% Returns a valid valiable name from the string in SIGNALNAME
%
% Example
%  a=mygenvarname('45\67')
%  a =
%  x45_bs_67
% Copyright 2006-2014 The MathWorks, Inc.

  varName=signalName; % Its a valid variable names, we are done

  % Not valid
  if ~isvarname(varName)
    
    % Remove unsupported characaters
    varName = strrep(varName,'\','_bs_');  % Replace '\' with '_bs_'
    varName = strrep(varName,'/','_fs_');  % Replace '/' with '_fs_'
    
    varName = strrep(varName,'[','_ls_');  % Replace '[' with '_ls_'
    varName = strrep(varName,']','_rs_');  % Replace ']' with '_rs_'
    
    varName = strrep(varName,'(','_lp_');  % Replace '(' with '_lp_'
    varName = strrep(varName,')','_rp_');  % Replace ')' with '_rp_'
    
    varName = strrep(varName,'@','_am_');  % Replace '@' with '_am_'
    
    %varName = strrep(varName,' ','_sp_');  % Replace ' ' with '_sp_'
    varName = strrep(varName,' ','_');      % Replace ' ' with '_'
    varName = strrep(varName,':','_co_');  % Replace ':' with '_co_'
    varName = strrep(varName,'-','_hy_');  % Replace '-' with '_hy_'
    varName = strrep(varName,'.','p');     % Replace '.' with 'p'
    varName = strrep(varName,'$','S_');    % Replace '$' with 'd_'
    %varName = strrep(varName,'.','_dot_'); % Replace '.' with '_dot_'
    
    if double(varName(1))>=48 & double(varName(1))<=57 % If starts with a number
      % if ~isvarname(varName)
      varName=['x'  varName];  % ...add an x to the start
    end
  end
end