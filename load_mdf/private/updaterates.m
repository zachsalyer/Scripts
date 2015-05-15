function handles=updaterates(handles)
% Looks at rate selection list box an edit box and modifies stored possible
% rates to new ones
% Copyright 2006-2014 The MathWorks, Inc.
  % Update rates list
  [rateStrings,possibleRates,possibleRateIndices]=processrates(handles.selectedChannelList);
  handles.possibleRates=possibleRates; % Update stored possible rates
  handles.possibleRateIndices=possibleRateIndices; % Update stored possible rate indices
  selectedIndex=get(handles.selectedrates_listbox,'Value');    % Current selected index
  if selectedIndex>length(possibleRates) | selectedIndex==0
    % Make sure value of list box is never more than length
    set(handles.selectedrates_listbox,'Value',length(possibleRates));
  end
  set(handles.selectedrates_listbox,'String',rateStrings); % Update strings
  
  % Update edit box
  selectedItem=get(handles.selectedrates_listbox,'Value'); % Get item selected
  if ~isempty(handles.possibleRates) & selectedItem > 0
    selectedItem=get(handles.selectedrates_listbox,'Value'); % Get item selected
    selectedRate=handles.possibleRates(selectedItem); % Get rate selected
    set(handles.edit3,'String',num2str(selectedRate)); % Update edit box with rate
  else
    set(handles.edit3,'String',[]); % Update edit box with rate
  end
end