function varargout = mdfimport(varargin)
% MDFIMPORT MDF File import tool and function
%   MDFIMPORT Launches the MDF import GUI tool or raises the existing tool
%   to the front. This tools lets you interactively import signals from an
%   MDF data file.
% 
%   MDFIMPORT(fileName) Imports signals from the specified MDF file to the
%   workspace using default options.
%
%   MDFIMPORT(fileName,importlocation,signalselection,timevectortype,ratedesignation,additionaltext)
%   Imports signals from the specified MDF file with specific options set.
% 
%   All parameters are optional except for the first, the file name, which
%   must be provided if MDFIMPORT is to be called as a function. See
%   <a href="mdfimportfunctionhelp.html">MDF import function help</a> for all possible input parameter options. 
%

% Original GIUDE help
% MDFIMPORT M-file for mdfimport.fig
%      MDFIMPORT, by itself, creates a new MDFIMPORT or raises the existing
%      singleton*.
%
%      H = MDFIMPORT returns the handle to a new MDFIMPORT or the handle to
%      the existing singleton*.
%
%      MDFIMPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MDFIMPORT.M with the given input arguments.
%
%      MDFIMPORT('Property','Value',...) creates a new MDFIMPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mdfimport_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mdfimport_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mdfimport

% Last Modified by GUIDE v2.5 08-Mar-2006 15:32:21
%
% Copyright 2006-2014 The MathWorks, Inc.

%% GUIDE generated code edited
% Intercept GUI function for command line operation
% If some parameters or second is not gcbo then coming from caommand line
if nargin % If arguments past in
    if nargin>1 % Could be from command line or GUI
        if isa(varargin{2},'double') | isa(varargin{2}, 'handle') & ~isempty(varargin{2}) %#ok allows for [] input
            % Its coming form the GUI, do nothing, gcbo
        else
            options=parseparameters(varargin);
            importdatawithoptions(options);
            return
        end
    else  % Just one argument, must be from the command line
        options=parseparameters(varargin);
        importdatawithoptions(options);
        return
    end
end
%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mdfimport_OpeningFcn, ...
    'gui_OutputFcn',  @mdfimport_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1}) %#ok
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mdfimport is made visible.
function mdfimport_OpeningFcn(hObject, eventdata, handles, varargin) %#ok
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mdfimport (see VARARGIN)

% Choose default command line output for mdfimport
handles.output = hObject;

% Set figure name and calculate uibackground color
set(handles.figure1,'Name','MDF File Import');
uibackgroundcolor=get(handles.selectallchannels,'background'); % Get color

% Initialize signal selection panel uicontrols
set(handles.Select_Signals_axes,'color',uibackgroundcolor); % Set axes color
set(handles.MDF_File_Text_Box,'String','No file specified'); % No MDF file selected
set(handles.Selection_File_Text_Box,'String','No file specified'); % No MDF file selected

set(handles.unselectedchannellistbox,'Max',2); % Allow Multi-select
set(handles.selectedchannellistbox,'Max',2); % Allow Multi-select

set(handles.unselectedchannellistbox,'String',[]); % Clear
set(handles.selectedchannellistbox,'String',[]); % Clear
set(handles.unselectedchannellistbox,'Value',[]); % Clear
set(handles.selectedchannellistbox,'Value',[]); % Clear

set(handles.removedevicenames_checkbox,'Value',1); % Initialize to remove names

% Signal import uicontrols
set(handles.Signal_Import_Options_axes,'color',uibackgroundcolor); % Set axes color


% Time vector generation uicontrols
set(handles.Time_Vector_axes,'color',uibackgroundcolor); % Set axes color
set(handles.timevectorchoice1,'Value',1); % Default to use actual times. Select this radion button..
set(handles.timevectorchoice2,'Value',0); % ...and deselect other radio button.
set(handles.selectedrates_listbox,'String',[]); % Clear rates list box
set(handles.selectedrates_listbox,'Value',1); % Initialize selected value (must be>0 for single selection list boxes)


% Initalize data storage values
handles.pathName=pwd; % Set directory to look in to current directory
handles.fullFileName=''; % set to blank
handles.unselectedChannelList=[]; % Clear unselected channel data
handles.selectedChannelList=[]; % Clear selected channel data
handles.channelList=[]; % Clear total channel data
handles.removeDeviceNames=1; % Default is to remove device names
handles.requestedChannelList=''; % Initialize to none
handles.possibleRates=[];
handles.possibleRateIndices=[];
handles.MDFInfo=[];

%handles.timechannel=1; % Default location of time channel

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mdfimport wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mdfimport_OutputFcn(hObject, eventdata, handles) %#ok
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function unselectedchannellistbox_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to unselectedchannellistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in unselectedchannellistbox.
function unselectedchannellistbox_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to unselectedchannellistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns unselectedchannellistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from unselectedchannellistbox


% --- Executes during object creation, after setting all properties.
function selectedchannellistbox_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to selectedchannellistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in selectedchannellistbox.
function selectedchannellistbox_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to selectedchannellistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns selectedchannellistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectedchannellistbox


% --- Executes on button press in selectchannels.
function selectchannels_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to selectchannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get selection list
selectedChannelIndices=get(handles.unselectedchannellistbox,'Value');

% Check if there are any   selected loaded and any have been unselected
if length(handles.unselectedChannelList)>0 & length(selectedChannelIndices)>0 %#ok

    % Update these channels by appending to existing list
    handles.selectedChannelList=[handles.selectedChannelList;...
        handles.unselectedChannelList(selectedChannelIndices,:)];

    % Sort these channels
    [dummy,sortIndices]=sort(handles.selectedChannelList(:,1)); % Get sorted names

    handles.selectedChannelList=handles.selectedChannelList(sortIndices,:);

    % Update channel list box for these channels
    updatedNames=processsignalname(handles.selectedChannelList,handles.removeDeviceNames,1);
    set(handles.selectedchannellistbox,'String',updatedNames);

    % Update channels and list box for other set
    handles.unselectedChannelList(selectedChannelIndices,:)=[];

    updatedNames=processsignalname(handles.unselectedChannelList,handles.removeDeviceNames,1);
    set(handles.unselectedchannellistbox,'Value',[]); % Update unselected list
    set(handles.unselectedchannellistbox,'String',updatedNames);

    % Updates rate list box and edit box
    handles=updaterates(handles);

    % Update handles structure
    guidata(hObject, handles);

end
% --- Executes on button press in unselectchannels.
function unselectchannels_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to unselectchannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get selection list
unselectedChannelIndices=get(handles.selectedchannellistbox,'Value');

% Check if there are any unselected loaded and any have been   selected
if length(handles.selectedChannelList)>0 & length(unselectedChannelIndices)>0 %#ok

    % Update these channels by appending to existing list
    handles.unselectedChannelList=[handles.unselectedChannelList;...
        handles.selectedChannelList(unselectedChannelIndices,:)];

    % Sort these channels
    [dummy,sortIndices]=sort(handles.unselectedChannelList(:,1)); % Get sorted names
    handles.unselectedChannelList=handles.unselectedChannelList(sortIndices,:);

    % Update channel list box for these channels
    updatedNames=processsignalname(handles.unselectedChannelList,handles.removeDeviceNames,1);
    set(handles.unselectedchannellistbox,'String',updatedNames);

    % Update channels and list box for other set
    handles.selectedChannelList(unselectedChannelIndices,:)=[];
    updatedNames=processsignalname(handles.selectedChannelList,handles.removeDeviceNames,1);
    set(handles.selectedchannellistbox,'Value',[]); % Clear selected list
    set(handles.selectedchannellistbox,'String',updatedNames);

    % Updates rate list box and edit box
    handles=updaterates(handles);

    % Update handles structure
    guidata(hObject, handles);

end
% --- Executes on button press in createselectionfile.
function createselectionfile_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to createselectionfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if length(handles.selectedChannelList)>0

    current=pwd; % Get and store current directory
    cd (handles.pathName); % Change to last directory looked at

    % Get name of file to same channel list in
    filterSpec='signal_selection1.txt';
    [selectionFileName,pathName]= uiputfile(filterSpec,'Specify TXT File to Save Signal Selections');
    cd(current);

    if isequal(selectionFileName,0)|isequal(pathName,0) %#ok
        % Ignore if dialog is closed without selecting file
    else
        % Set current directory back and store pathname
        if ~strcmp(selectionFileName(end-3:end),'.txt')
            selectionFileName=[selectionFileName '.txt'];
        end

        handles.pathName=pathName; % Set path name for later usage

        % Get list of selected channels
        selectedChannelList=handles.selectedChannelList;

        % Save as text file
        fid=fopen([pathName selectionFileName],'wt');
        for signal=1:size(selectedChannelList,1)
            fprintf(fid,'%s\n',removedevicenames(selectedChannelList{signal,1}));
        end
        fclose(fid);

        % Update handles structure
        guidata(hObject, handles);
    end

end
% --- Executes on button press in importdata.
function importdata_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to importdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectedChannelList=handles.selectedChannelList; % X

if length(selectedChannelList)>0

    % Plot waitbar
    waitbarhandle=waitbar(0, 'Importing...');
    uibackgroundcolor=get(handles.selectallchannels,'background'); % Get color
    set(waitbarhandle,'color',uibackgroundcolor) % Set background color
    set(waitbarhandle,'Name','Import Signals'); %Set Window title
    drawnow; % Ensure title is drawn immediately

    %% Extract some options from GUI   
    options=getoptionsfromgui(handles);
    options.waitbarhandle=waitbarhandle;
    
    % Call generic import function
    importdatawithoptions(options);
    
    % Finish up waitbar display
    waitbar(1,waitbarhandle,'Finished');
    close(waitbarhandle);
end

% --- Executes during object creation, after setting all properties.
function mdffileedit_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to mdffileedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function mdffileedit_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to mdffileedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mdffileedit as text
%        str2double(get(hObject,'String')) returns contents of mdffileedit as a double


% --- Executes during object creation, after setting all properties.
function selectionfile_edit_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to selectionfile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function selectionfile_edit_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to selectionfile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selectionfile_edit as text
%        str2double(get(hObject,'String')) returns contents of selectionfile_edit as a double

function handles=populate_GUI(handles)

[MDFsummary, MDFInfo, counts, channelList]=mdfinfo(handles.fullFileName);
handles.MDFInfo=MDFInfo;

handles.selectedChannelList=[];
handles.unselectedChannelList=channelList;

% Remove Time channels
handles.unselectedChannelList(cell2mat(handles.unselectedChannelList(:,9))==1,:)=[]; %Remove

% % Remove data blocks containing Type 7 channels
% channelIndicesWithSignalType7=cell2mat(handles.unselectedChannelList(:,8))==7;
% channelsWithSignalType7=handles.unselectedChannelList(channelIndicesWithSignalType7,:);
% blocksWithSignalType7=unique(cell2mat(channelsWithSignalType7(:,4)));
% remove=ismember(cell2mat(handles.unselectedChannelList(:,4)),blocksWithSignalType7);
% handles.unselectedChannelList(remove,:)=[]; %Remove

% Remove blcoks with no records
channelIndicesWithNoRecords=cell2mat(handles.unselectedChannelList(:,6))==0;
handles.unselectedChannelList(channelIndicesWithNoRecords,:)=[]; %Remove

% Sort alphabetically
[dummy,sortIndices]=sort(handles.unselectedChannelList(:,1)); % Get sorted names
handles.unselectedChannelList=handles.unselectedChannelList(sortIndices,:);

% Set default list
handles.channelList=handles.unselectedChannelList;

% Initialize listboxes
updatedNames=processsignalname(handles.unselectedChannelList,handles.removeDeviceNames,1);
set(handles.unselectedchannellistbox,'String',updatedNames);

set(handles.selectedchannellistbox,'String','No signals selected');
set(handles.selectedchannellistbox,'Value',[]); % Update unselected list


% --- Executes on button press in removedevicenames_checkbox.
function removedevicenames_checkbox_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to removedevicenames_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of removedevicenames_checkbox


remove=get(handles.removedevicenames_checkbox,'Value'); % Get value of check ox
handles.removeDeviceNames=remove;

if length(handles.selectedChannelList)>0
    updatedNames=processsignalname(handles.selectedChannelList,handles.removeDeviceNames,1);
    set(handles.selectedchannellistbox,'String',updatedNames);
end

if length(handles.unselectedChannelList)>0
    updatedNames=processsignalname(handles.unselectedChannelList,handles.removeDeviceNames,1);
    set(handles.unselectedchannellistbox,'String',updatedNames);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in selectallchannels.
function selectallchannels_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to selectallchannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get all channels
selectedChannelIndices=1:size(handles.unselectedChannelList,1);

% Check if any have been unselected
if length(handles.unselectedChannelList)>0 % Check if there are some unselected channels

    % Update selected channels
    handles.selectedChannelList=[handles.selectedChannelList;...
        handles.unselectedChannelList(selectedChannelIndices,:)];

    % Sort these channels
    [dummy,sortIndices]=sort(handles.selectedChannelList(:,1)); % Get sorted names
    handles.selectedChannelList=handles.selectedChannelList(sortIndices,:);

    % Update channel list box for these channels
    updatedNames=processsignalname(handles.selectedChannelList,handles.removeDeviceNames,1);
    set(handles.selectedchannellistbox,'String',updatedNames);

    % Update channels and list box for other set
    handles.unselectedChannelList(selectedChannelIndices,:)=[];

    set(handles.unselectedchannellistbox,'Value',[]); % Update unselected list
    set(handles.unselectedchannellistbox,'String',[]);

    % Updates rate list box and edit box
    handles=updaterates(handles);

    % Update handles structure
    guidata(hObject, handles);

end
% --- Executes on button press in unselectallchannels.
function unselectallchannels_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to unselectallchannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set all channels
unselectedChannelIndices=1:size(handles.selectedChannelList,1);

% Check if there are any unselected loaded and any have been   selected
if length(handles.selectedChannelList)>0 % Check if there are some selected channels

    % Update these channels and list box
    handles.unselectedChannelList=[handles.unselectedChannelList;...
        handles.selectedChannelList(unselectedChannelIndices,:)];

    % Sort
    [dummy,sortIndices]=sort(handles.unselectedChannelList(:,1)); % Get sorted names
    handles.unselectedChannelList=handles.unselectedChannelList(sortIndices,:);

    % Update channel list box for these channels
    updatedNames=processsignalname(handles.unselectedChannelList,handles.removeDeviceNames,1);
    set(handles.unselectedchannellistbox,'String',updatedNames);

    % Update channels and list box for other set
    handles.selectedChannelList(unselectedChannelIndices,:)=[];

    set(handles.selectedchannellistbox,'Value',[]); % Update selected list
    set(handles.selectedchannellistbox,'String',[]);

    % Updates rate list box and edit box
    handles=updaterates(handles);

    % Update handles structure
    guidata(hObject, handles);

end


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit3_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

if length(handles.possibleRates>0)

    inputValue=str2double(get(hObject,'String')); % Input value
    selectedItem=get(handles.selectedrates_listbox,'Value'); % Get item selected in list box
    handles.possibleRates(selectedItem)=inputValue; % Store new value

    % Update string in listbox
    rateStrings=get(handles.selectedrates_listbox,'String'); % Current strings
    currentString=rateStrings{selectedItem};
    index=strfind(currentString,'|'); % Find '|'
    newString=[currentString(1:index-1) '| ' num2str(inputValue)];%[ Old to | new]
    rateStrings{selectedItem}=newString;
    set(handles.selectedrates_listbox,'String',rateStrings);

    % Update handles structure
    guidata(hObject, handles);

end

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Load_MDF_File_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Select_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


current=pwd;
cd (handles.pathName); % Change to current or last directory looked at
[fileName,pathName]= uigetfile({'*.dat';'*.mdf';'*.*'},'Select MDF File'); % Get file name
cd(current); %set cd back

if isequal(fileName,0)|isequal(pathName,0) %#ok
    % Ignore if dialog is closed without selecting file
else
    if strcmpi(fileName(end-3:end),'.dat') | strcmpi(fileName(end-3:end),'.mdf')  %#ok Look at file type
        handles.fileName=fileName; % Store file name
        handles.fullFileName=[pathName fileName]; % Set file name
        handles.pathName=pathName; % Set path name for later usage
        set(handles.MDF_File_Text_Box,'String',fileName); %Display MDF in text box

        handles=populate_GUI(handles); % Populate GUI (list box)
        set(handles.selectedrates_listbox,'String',[]); % Clear select rate list box

        if length(handles.requestedChannelList)>0
            % Apply signal selection
            handles=applyselectionfile(handles,handles.requestedChannelList);
            set(handles.selectedchannellistbox,'FontAngle','normal');
        end

    else
        errordlg('Not valid file type', 'Not valid file type');
    end
end

% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function selectedrates_listbox_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to selectedrates_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in selectedrates_listbox.
function selectedrates_listbox_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to selectedrates_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns selectedrates_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectedrates_listbox

selectedItem=get(handles.selectedrates_listbox,'Value'); % Get item selected
selectedRate=handles.possibleRates(selectedItem); % Get rate selected
set(handles.edit3,'String',num2str(selectedRate)); % Update edit box with rate

% --------------------------------------------------------------------
function Load_Signal_Selection_List_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Load_Signal_Selection_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

current=pwd;
cd (handles.pathName); % Change to current or last directory looked at
[fileName,pathName]= uigetfile('*.txt','Select Signal Selection File'); % Get file name
cd(current); % Set cd back

if isequal(fileName,0)|isequal(pathName,0) %#ok
    % Ignore if dialog is closed without selecting file
else
    switch fileName(end-3:end) % Look at file type

        case '.txt'
            %Display selection file in text box
            set(handles.Selection_File_Text_Box,'String',fileName); 

            % Load text file
            requestedChannelList=readtextfile([pathName fileName]);
            
            handles.pathName=pathName; % Set path name for later usage
            handles.requestedChannelList=requestedChannelList;
            
            if isempty(handles.fullFileName); % No MDF file loaded
                set(handles.selectedchannellistbox,'String',requestedChannelList);
                set(handles.selectedchannellistbox,'FontAngle','italic');

            else % File already loaded. Do selection
                handles=applyselectionfile(handles,requestedChannelList);
            end

        otherwise
            errordlg('Not valid file type', 'Not valid file type');
    end
end

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_About_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Help_About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toolVersion=1.3;
str = sprintf(['MDF File Import Tool ' num2str(toolVersion,'%1.1f') '\n'...
               'Copyright 2006-2014 The MathWorks, Inc.']);
msgbox(str,'About MDF File Import Tool','modal');

% --------------------------------------------------------------------
function Helpmdfimport_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Helpmdfimport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web(['file:' which('mdfimporttoolhelp.html')])


% --- Executes on button press in timevectorchoice1.
function timevectorchoice1_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to timevectorchoice1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of timevectorchoice1

set(hObject,'Value',1); % Turn this radio button on
set(handles.timevectorchoice2,'Value',0); % Turn other radio button off

set(handles.selectedrates_listbox,'Enable','off'); % Disable selected rates list box
set(handles.edit3,'Enable','off'); % Disable new sample rate edit box


% --- Executes on button press in timevectorchoice2.
function timevectorchoice2_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to timevectorchoice2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of timevectorchoice2

set(hObject,'Value',1); % Turn this radio button on
set(handles.timevectorchoice1,'Value',0); % Turn other radio button off

set(handles.selectedrates_listbox,'Enable','on'); % Enable selected rates list box
set(handles.edit3,'Enable','on'); % Enable new sample rate edit box

% Update selected rates edit box
if ~isempty(handles.possibleRates)
    selectedItem=get(handles.selectedrates_listbox,'Value'); % Get item selected
    selectedRate=handles.possibleRates(selectedItem); % Get rate selected
    set(handles.edit3,'String',num2str(selectedRate)); % Update edit box with rate
end


% --------------------------------------------------------------------
function Clear_MDF_File_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Clear_MDF_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.MDF_File_Text_Box,'String','No file specified'); % No MDF file selected

% Initalize data storage values
handles.fileName=''; % set to blank
handles.fullFileName=''; % set to blank
handles.unselectedChannelList=[]; % Clear unselected channel data
handles.selectedChannelList=[]; % Clear selected channel data
handles.channelList=[]; % Clear total channel data

% Clear list boxes
set(handles.unselectedchannellistbox,'Value',[]);
set(handles.selectedchannellistbox,'Value',[]);
set(handles.unselectedchannellistbox,'String',[]);
set(handles.selectedchannellistbox,'String',[]);

% Updates rate list box and edit box
handles=updaterates(handles);

% Update handles structure
guidata(hObject, handles);
% --------------------------------------------------------------------
function Signal_Selection_File_Menu_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Signal_Selection_File_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Clear_Signal_Selection_File_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Clear_Signal_Selection_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update GUI
set(handles.Selection_File_Text_Box,'String','No file specified'); % No MDF file selected
set(handles.selectedchannellistbox,'FontAngle','normal');
set(handles.selectedchannellistbox,'Value',[]); % Update selected list
set(handles.selectedchannellistbox,'String',[]);

% Update data
handles.requestedChannelList=[];
handles.selectedChannelList=[];

if length(handles.channelList)>0  % If some have been loaded

    % Reset data
    %handles.selectedChannelList=[];
    handles.unselectedChannelList=handles.channelList;

    % Sort these channels
    [dummy,sortIndices]=sort(handles.unselectedChannelList(:,1)); % Get sorted names
    handles.unselectedChannelList=handles.unselectedChannelList(sortIndices,:);

    % Update channel list box
    updatedNames=processsignalname(handles.unselectedChannelList,handles.removeDeviceNames,1);
    set(handles.unselectedchannellistbox,'String',updatedNames);

end


% Updates rate list box and edit box
handles=updaterates(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ratedesignation_popup_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to ratedesignation_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ratedesignation_popup.
function ratedesignation_popup_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to ratedesignation_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ratedesignation_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ratedesignation_popup




% --- Executes during object creation, after setting all properties.
function importlocation_popup_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to importlocation_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in importlocation_popup.
function importlocation_popup_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to importlocation_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns importlocation_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from importlocation_popup



% --- Executes during object creation, after setting all properties.
function additionaltext_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to additionaltext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function additionaltext_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to additionaltext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of additionaltext as text
%        str2double(get(hObject,'String')) returns contents of additionaltext as a double

maxLengthStr=10; % Maximum number of allowed characters
str=get(hObject,'String'); % Get current string

if length(str)>=maxLengthStr % If too long
    set(hObject,'String',str(1:maxLengthStr)); % Get current string
end


% --------------------------------------------------------------------
function Code_Generation_Menu_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Code_Generation_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Generate_Function_Call_1_Menu_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Generate_Function_Call_1_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectedChannelList=handles.selectedChannelList; % 

if length(selectedChannelList)>0
    
     % Get import options structure form uicontrols in GUI
    options=getoptionsfromgui(handles);
    
    % Generate mdfimport command string
    cmd=generatecommand(options);
    cmd=[cmd ' % Copy and paste command from here to use'];
    
    % Display command string
    disp(cmd);
    if strcmpi(options.timeVectorChoice,'ideal')
        disp('% Any modified sample rates are ignored, as this feature is not supported when called at command line.');
    end
else
    % Display command string
    disp('No command can be generated as no signals have been selected.');
end

% --------------------------------------------------------------------
function Generate_Function_Call_2_Menu_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Generate_Function_Call_2_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectedChannelList=handles.selectedChannelList; % 

if length(selectedChannelList)>0
    
     % Get import options structure form uicontrols in GUI
    options=getoptionsfromgui(handles);
    options.selectedChannelList='enter_signal_selection_file_here.txt'; % Ovewrite selected signals
    
    % Generate mdfimport command string
    cmd=generatecommand(options);
    cmd=[cmd ' % Copy and paste command from here to use.'];

    % Display command string
    disp(cmd);
    if strcmpi(options.timeVectorChoice,'ideal')
        disp('% Any modified sample rates are ignored, as this feature is not supported when called in command line.');
    end
else
    % Display command string
    disp('No command can be generated as no signals have been selected.');
end



function options=getoptionsfromgui(handles)
% Returns struction of options from GUI uicontrols and other GUI info
% used to control import routine

MDFInfo=handles.MDFInfo;

% Signal import location
choices={'workspace','MAT-File'};
importTo=choices{get(handles.importlocation_popup,'Value')};

% Choose how to designate block/rate
choices={'ratenumber','ratestring'};
blockDesignation=choices{get(handles.ratedesignation_popup,'Value')};

% Time vector type
choices={'actual','ideal'};
if get(handles.timevectorchoice1,'Value')==1 %
    timeVectorChoice=choices{1};
else
    timeVectorChoice=choices{2};
end

% Additional text
additionalText= get(handles.additionaltext,'String');

% Import all channels check
if isempty(handles.unselectedChannelList) % If no unselected channels
    importAllChannels=true; % Import them all
else
    importAllChannels=false;
end
    

% Other data from GUI
fileName=handles.fileName;
possibleRateIndices=handles.possibleRateIndices;
possibleRates=handles.possibleRates;

% Form parameters for function
options=struct('fileName',fileName,'MDFInfo',MDFInfo,...
    'importTo',importTo,'blockDesignation', blockDesignation,'timeVectorChoice', timeVectorChoice,...
    'possibleRateIndices', possibleRateIndices,'possibleRates', possibleRates,...
    'additionalText',additionalText,'importAllChannels',importAllChannels);

options.waitbarhandle=[]; % Default to empty
options.selectedChannelList=handles.selectedChannelList; % Add extra as it is a cell array
function command = generatecommand(options)
% Generate equivalent commands for a successful import

% Menu option (commdn>generate command code and selection file, auto, cells) or automatic
% go backwards

% Initialize to empty
command='';

% Additional text
if ~isempty(options.additionalText) 
    command=[ ',''' options.additionalText '''' command];
end

% Rate designation
if strcmpi(options.blockDesignation,'ratenumber') % default
    if ~isempty(command) 
        command=[',[]' command];
    end
else
    command=[ ',''' options.blockDesignation '''' command];
end

% Time vector selection
if strcmpi(options.timeVectorChoice,'actual') % default
    if ~isempty(command) 
        command=[',[]' command];
    end
else
    command=[',''' options.timeVectorChoice  '''' command];
end

% Signal selection
if options.importAllChannels | isempty(options.selectedChannelList) % default or ignore channels not found
    if ~isempty(command)
        command=[',[]' command];
    end
    
elseif isa(options.selectedChannelList,'cell') % If cell array of signal names

    str='{'; % Make cell array list
    for k= 1:size(options.selectedChannelList,1)
        str=[str '''' removedevicenames(options.selectedChannelList{k}) ''','];
    end
    str=[str(1:end-1) '}']; %  Remove last ',' and add }
    command=[',' str command]; % Put cell array in command
    
elseif isa(options.selectedChannelList,'char')% If text file
    command=[',''' options.selectedChannelList  '''' command];
else
    error('Wrong signal seltcion parameter');
end
%% Add warning if selected signal being ignored.

% Location
if strcmpi(options.importTo,'workspace')
    if ~isempty(command)
        command=[',[]' command];
    end
elseif strcmpi(options.fileName(1:end-4),options.importTo(1:end-4))  % Auto MAT file
    command=[',''Auto MAT-File''' command];
else
    command=[',''' options.importTo '''' command]; % Custom MAT file
end

% File name and finish
if isempty(command)
    command=['mdfimport(''' options.fileName ''');'];
else
    command=['mdfimport(''' options.fileName '''' command ');'];
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END GUI CODE ???? %%%%%%%%%%%%%%%%%%%%%%%%

