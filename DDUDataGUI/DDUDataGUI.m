function varargout = DDUDataGUI(varargin)
% DDUDATAGUI MATLAB code for DDUDataGUI.fig
%      DDUDATAGUI, by itself, creates a new DDUDATAGUI or raises the existing
%      singleton*.
%
%      H = DDUDATAGUI returns the handle to a new DDUDATAGUI or the handle to
%      the existing singleton*.
%
%      DDUDATAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DDUDATAGUI.M with the given input arguments.
%
%      DDUDATAGUI('Property','Value',...) creates a new DDUDATAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DDUDataGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DDUDataGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DDUDataGUI

% Last Modified by GUIDE v2.5 10-May-2018 12:47:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DDUDataGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DDUDataGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before DDUDataGUI is made visible.
function DDUDataGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DDUDataGUI (see VARARGIN)
waitfor(msgbox('Press Ok, then select the data file in MATLAB format.','Import Data File'));
[filename,path] = uigetfile('.mat');
handles.data = load(strcat(path,filename));

% Choose default command line output for DDUDataGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using DDUDataGUI.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes DDUDataGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DDUDataGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        cla(handles.axes1,'reset')
        plots.CellTempPlot(handles.data.CoreData)
    case 2
        cla(handles.axes1,'reset')
        waitfor(msgbox('Cell Volt Plot needs reworked.'));
        %plots.CellVoltPlot(handles.data.CoreData)
    case 3
        cla(handles.axes1,'reset')
        plots.ControllerCoolingPlot(handles.data.CoreData)
    case 4
        cla(handles.axes1,'reset')
        plots.DCBusPowerPlot(handles.data.CoreData)
    case 5
        cla(handles.axes1,'reset')
        plots.DCVoltageCurrentPlot(handles.data.CoreData)
    case 6
        cla(handles.axes1,'reset')
        plots.GPSPlot(handles.data.CoreData)
    case 7
        cla(handles.axes1,'reset')
        plots.MotorCoolingPlot(handles.data.CoreData)
    case 8
        cla(handles.axes1,'reset')
        plots.RPMvsTorquePlot(handles.data.CoreData)
    case 9
        cla(handles.axes1,'reset')
        plots.ThrottleCurrentComparePlot(handles.data.CoreData)
    case 10
        cla(handles.axes1,'reset')
        plots.VelocityPlot(handles.data.CoreData)
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Cell Temp', 'Cell Volt', 'Controller Cooling', 'DC Bus Power', 'DC Voltage & Current', 'GPS', 'Motor Cooling', 'RPM vs Torque', 'Throttle - Current Comparison', 'Velocity'});
