function varargout = selectCh(varargin)
% SELECTCH MATLAB code for selectCh.fig
%      SELECTCH, by itself, creates a new SELECTCH or raises the existing
%      singleton*.
%
%      H = SELECTCH returns the handle to a new SELECTCH or the handle to
%      the existing singleton*.
%
%      SELECTCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTCH.M with the given input arguments.
%
%      SELECTCH('Property','Value',...) creates a new SELECTCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selectCh_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selectCh_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectCh

% Last Modified by GUIDE v2.5 13-Nov-2014 10:23:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selectCh_OpeningFcn, ...
                   'gui_OutputFcn',  @selectCh_OutputFcn, ...
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


% --- Executes just before selectCh is made visible.
function selectCh_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selectCh (see VARARGIN)

% Choose default command line output for selectCh
set(handles.figure1,'name','Please select an ECG signal');

handles.fname = varargin{1};
handles.CHlabel = varargin{2};
handles.Labels = varargin{3};
handles.pref=varargin{4};

set(handles.warntext,'string',['Cannot find signal "'...
        strtrim(handles.CHlabel) '" in the file '...
        handles.fname]);
    
set(handles.signallist,'string',handles.Labels);

set(handles.prefercheck,'value',handles.pref);

% handles.output = hObject;
handles.output.CHnum=[];
handles.output.CHlabel=handles.CHlabel;
handles.output.pref=handles.pref;

% set default for CHlabel in case user will select label 1
handles.CHlabel = strtrim(handles.Labels(1,:));
handles.CHnum=1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes selectCh wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = selectCh_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output.CHnum;
varargout{2} = handles.output.CHlabel;
varargout{3} = handles.output.pref;
delete(hObject);


% --- Executes on selection change in signallist.
function signallist_Callback(hObject, eventdata, handles)
% hObject    handle to signallist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns signallist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signallist
handles.CHnum = get(hObject,'Value');
handles.CHlabel=strtrim(handles.Labels(handles.CHnum,:));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function signallist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signallist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prefercheck.
function prefercheck_Callback(hObject, eventdata, handles)
% hObject    handle to prefercheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pref=get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in OKbutton.
function OKbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OKbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.CHnum=handles.CHnum;
handles.output.CHlabel=handles.CHlabel;
handles.output.pref=handles.pref;
guidata(hObject, handles);
figure1_CloseRequestFcn(hObject, eventdata, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(handles.figure1);


% --- Executes on button press in skipbutton.
function skipbutton_Callback(hObject, eventdata, handles)
figure1_CloseRequestFcn(hObject, eventdata, handles);
