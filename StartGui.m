function varargout = StartGui(varargin)
%STARTGUI MATLAB code file for StartGui.fig
%      STARTGUI, by itself, creates a new STARTGUI or raises the existing
%      singleton*.
%
%      H = STARTGUI returns the handle to a new STARTGUI or the handle to
%      the existing singleton*.
%
%      STARTGUI('Property','Value',...) creates a new STARTGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to StartGui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      STARTGUI('CALLBACK') and STARTGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in STARTGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StartGui

% Last Modified by GUIDE v2.5 20-Jul-2016 17:19:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StartGui_OpeningFcn, ...
                   'gui_OutputFcn',  @StartGui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before StartGui is made visible.
function StartGui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = StartGui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in DWI.
function [DWIF] = DWI_Callback(hObject, eventdata, handles)
[F,P] = uigetfile('*.*');
set(handles.DWITEXT,'String',[P,F]);

% --- Executes on button press in BO.
function [B0F] = BO_Callback(hObject, eventdata, handles)
[F,P] = uigetfile('*.*');
set(handles.B0TEXT,'String',[P,F]);


% --- Executes on button press in DWIOUT.
function DWIOUT_Callback(hObject, eventdata, handles)
[F,P] = uiputfile('*.*');
set(handles.DWOTEXT,'String',[P,F]);



function BLX_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function BLX_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BLY_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function BLY_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BLZ_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function BLZ_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ThreshHold_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ThreshHold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function ClSlide_Callback(hObject, eventdata, handles)
Comp = get(handles.ClSlide,'Value');
set(handles.text6,'String',Comp);



% --- Executes during object creation, after setting all properties.
function ClSlide_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
input = struct();
input.Block = [str2num(get(handles.BLX,'String')),str2num(get(handles.BLY,'String')),str2num(get(handles.BLZ,'String'))];
input.DwiFile = get(handles.DWITEXT,'String');
input.B0File = get(handles.B0TEXT,'String');
input.DwoFile = get(handles.DWOTEXT,'String');
input.Comp = get(handles.ClSlide,'value');
input.Vout = get(handles.Vout,'value');
input.Save = get(handles.Save,'value');
input.Pre = get(handles.Pre,'value');
input.Thresh = str2num(get(handles.ThreshHold,'String'));
OverCompleteLpca(input)




% --- Executes on button press in Vout.
function Vout_Callback(hObject, eventdata, handles)



% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)



% --- Executes on button press in Pre.
function Pre_Callback(hObject, eventdata, handles)

