function varargout = Setting(varargin)
% SETTING MATLAB code for Setting.fig
%      SETTING, by itself, creates a new SETTING or raises the existing
%      singleton*.
%
%      H = SETTING returns the handle to a new SETTING or the handle to
%      the existing singleton*.
%
%      SETTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETTING.M with the given input arguments.
%
%      SETTING('Property','Value',...) creates a new SETTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Setting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Setting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Setting

% Last Modified by GUIDE v2.5 24-Jul-2014 12:48:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Setting_OpeningFcn, ...
                   'gui_OutputFcn',  @Setting_OutputFcn, ...
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


% --- Executes just before Setting is made visible.
function Setting_OpeningFcn(hObject, eventdata, handles, varargin)

set(handles.figure1,'Name','Setting')

handles.set=varargin{1};
handles.param=varargin{2};
handles.isreadonly=varargin{3};
fromEDFview = varargin{4};
handles.SettingName = varargin{5};
set(handles.figure1,'Name',[handles.SettingName ' - HRV Setting'] );


handles.rootpath=cd;
handles.IPerror=0;

if strcmp(handles.set.ifileopt,'ECG')==1
    handles.chnum=handles.set.ecgch.chnum;

    handles.detrend=handles.param.filter.detrend;
    handles.notch=handles.param.filter.notch;
    handles.lowpass=handles.param.filter.lowpass;
    handles.highpass=handles.param.filter.highpass;
else
    handles.chnum='';

    handles.detrend=0;
    handles.notch=[];
    handles.lowpass=[];
    handles.highpass=[];
end

handles.epochsize=handles.param.hrv.epochsize;
handles.artifact=handles.set.preprocess.artifact;
    handles.maxhr=handles.param.preprocess.maxhr;
    handles.minhr=handles.param.preprocess.minhr;
    handles.maxdhr=handles.param.preprocess.maxdhr;
    

handles.mnn=handles.set.hrv.mnn;
handles.sdnn=handles.set.hrv.sdnn;
handles.cv=handles.set.hrv.cv;
handles.poincare=handles.set.hrv.poincare;
    handles.pctau=handles.param.hrv.pctau;

handles.lomb=handles.set.hrv.lomb;
    handles.lowerLF=handles.param.hrv.lowerLF;
    handles.higherLF=handles.param.hrv.higherLF;
    handles.lowerHF=handles.param.hrv.lowerHF;
    handles.higherHF=handles.param.hrv.higherHF;

handles.fnameopt=handles.set.save.fnameopt;
handles.savexls=handles.set.save.savexls;
if ismac
    set(handles.savexlscheck,'enable','off');
end
handles.savetxt=handles.set.save.savetxt;

handles.outfolderopt=handles.set.save.outfolderopt;
handles.outPath=handles.set.save.outPath;
handles.showlog=handles.set.save.showlog;
handles=setbox(handles);
% Choose default command line output for Setting
if handles.isreadonly
    disablebox(handles);
end
% if fromEDFview
%     set(handles.needfiltercheck,'enable','off');
% end

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Setting wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Setting_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.set;
varargout{2} = handles.param;
varargout{3} = handles.SettingName;
delete(handles.figure1);



function handles=setbox(handles)
% 
set(handles.ECGchnumbox,'string',handles.chnum);
% filter boxes
    set(handles.detrendcheck,'Value',handles.detrend);

    if isempty(handles.notch)
        set(handles.notchbox,'string','off');
    else
        set(handles.notchbox,'string',num2str(handles.notch));
    end

    if isempty(handles.lowpass)
        set(handles.lowpassbox,'string','off');
    else
        set(handles.lowpassbox,'string',num2str(handles.lowpass));
    end

    if isempty(handles.highpass)
        set(handles.highpassbox,'string','off');
    else
        set(handles.highpassbox,'string',num2str(handles.highpass));
    end
    
    %Disable if ifile is not ECG file
    if strcmp(handles.set.ifileopt,'ECG')==1    
        set(handles.ECGchnumbox,'enable','on');
        enablefilterbuttons(handles,'on')
    else
        set(handles.ECGchnumbox,'enable','off');
        enablefilterbuttons(handles,'off')        
    end
    
    
    set(handles.epochbox,'string',num2str(handles.epochsize));

    set(handles.artifactcheck,'value',(handles.artifact));
    set(handles.artifactcheck,'enable','on');
    set(handles.maxHRbox,'string',num2str(handles.maxhr));
    set(handles.minHRbox,'string',num2str(handles.minhr));
    set(handles.maxdHRbox,'string',num2str(handles.maxdhr));
    if handles.artifact
        set(handles.maxHRbox,'enable','on');
        set(handles.minHRbox,'enable','on');
        set(handles.maxdHRbox,'enable','on');
    else
        set(handles.maxHRbox,'enable','off');
        set(handles.minHRbox,'enable','off');
        set(handles.maxdHRbox,'enable','off');
    end

    set(handles.mnncheck,'value',handles.mnn);
    set(handles.sdnncheck,'value',handles.sdnn);
    set(handles.cvcheck,'value',handles.cv);
    set(handles.poincarecheck,'value',handles.poincare);
    set(handles.delaybox,'string',num2str(handles.pctau));
    
    if handles.poincare
        set(handles.delaybox,'enable','on');
        set(handles.delaypopup,'enable','on');
    else
        set(handles.delaybox,'enable','off');
        set(handles.delaypopup,'enable','off');
    end 
    
    %set(handles.delaybox,'string',num2str(handles.epochsize));
    
    set(handles.lombcheck,'value',handles.lomb);
    set(handles.higherLFbox,'string',num2str(handles.higherLF));
    set(handles.lowerLFbox,'string',num2str(handles.lowerLF));
    set(handles.higherHFbox,'string',num2str(handles.higherHF));
    set(handles.lowerHFbox,'string',num2str(handles.lowerHF));
   
    
    
    if handles.lomb
        enableLombbuttons(handles,'on')

    else
        enableLombbuttons(handles,'off')
    end 
    
    set(handles.fnameoptbox,'string',handles.fnameopt);
    set(handles.savematcheck,'value',1);
    set(handles.savematcheck,'enable','off');
    set(handles.savexlscheck,'value',(handles.savexls));
    set(handles.savetxtcheck,'value',(handles.savetxt));
    set(handles.foldertab,'string',handles.outPath);

    if strcmp(handles.outfolderopt,'Save in same folder as input file')
        set(handles.samefolder,'value',1);
        set(handles.foldertab,'enable','off');
    else
        set(handles.newfolder,'value',1);
        set(handles.foldertab,'enable','on');
    end
% set(handles.showlogcheck,'value',(handles.showlog));

function disablebox(handles)
set(handles.ECGchnumbox,'enable','off');

% set(handles.needfiltercheck,'enable','off');
    enablefilterbuttons(handles,'off');

set(handles.artifactcheck,'enable','off');
    set(handles.maxHRbox,'enable','off');
    set(handles.minHRbox,'enable','off');
    set(handles.maxdHRbox,'enable','off');

set(handles.epochpopup,'enable','off');
set(handles.epochbox,'enable','off');


set(handles.mnncheck,'enable','off');
set(handles.sdnncheck,'enable','off');
set(handles.cvcheck,'enable','off');
set(handles.poincarecheck,'enable','off');
    set(handles.delaypopup,'enable','off');
    set(handles.delaybox,'enable','off');

set(handles.lombcheck,'enable','off');
    enableLombbuttons(handles,'off');

set(handles.fnameoptbox,'enable','off');
set(handles.savematcheck,'enable','off');
set(handles.savetxtcheck,'enable','off');
set(handles.savexlscheck,'enable','off');
% set(handles.showlogcheck,'enable','off');

set(handles.samefolder,'enable','off');
set(handles.newfolder,'enable','off');
set(handles.foldertab,'enable','off');
set(handles.Browse,'enable','off');

set(handles.Default,'enable','off');
set(handles.OK,'enable','off');

function enablefilterbuttons(handles,mode)
    set(handles.notchpopup,'enable',mode);
    set(handles.notchbox,'enable',mode);
    set(handles.highpasspopup,'enable',mode);
    set(handles.highpassbox,'enable',mode);
    set(handles.lowpasspopup,'enable',mode);
    set(handles.lowpassbox,'enable',mode);
    set(handles.detrendcheck,'enable',mode);
    
% --- Executes on button press in artifactcheck.
function artifactcheck_Callback(hObject, eventdata, handles)
handles.artifact=get(hObject,'Value');
if handles.artifact
    set(handles.maxHRbox,'enable','on');
    set(handles.minHRbox,'enable','on');
    set(handles.maxdHRbox,'enable','on');
else
    set(handles.maxHRbox,'enable','off');
    set(handles.minHRbox,'enable','off');
    set(handles.maxdHRbox,'enable','off');
end
guidata(hObject, handles);


function fnameoptbox_Callback(hObject, eventdata, handles)
handles.fnameopt=get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function fnameoptbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in savematcheck.
function savematcheck_Callback(hObject, eventdata, handles)


% --- Executes on button press in savexlscheck.
function savexlscheck_Callback(hObject, eventdata, handles)
handles.savexls=get(hObject,'Value');
guidata(hObject, handles);


function savetxtcheck_Callback(hObject, eventdata, handles)
handles.savetxt=get(hObject,'Value');
guidata(hObject, handles);


% --- Executes when selected object is changed in saveas.
function saveas_SelectionChangeFcn(hObject, eventdata, handles)
handles.outfolderopt=get(eventdata.NewValue,'string');
if strcmp(handles.outfolderopt,'Save in same folder as input file')
    handles.outPath=handles.set.save.inputPath;    
    set(handles.foldertab,'BackgroundColor',[1 1 1]);
    set(handles.foldertab,'enable','off');    
else
    set(handles.foldertab,'enable','on');
end
guidata(hObject, handles);

% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
set(handles.newfolder,'value',1);
handles.outfolderopt='A new folder';
set(handles.foldertab,'enable','on');
temp = uigetdir(handles.outPath);
if temp==0,handles.IPerror=1; return;end
handles.outPath=temp;
set(handles.foldertab,'string',handles.outPath);
guidata(hObject, handles);


function foldertab_Callback(hObject, eventdata, handles)
handles.outPath=get(hObject,'String');
guidata(hObject, handles);

% --- Executes on button press in mnncheck.

function mnncheck_Callback(hObject, eventdata, handles)
handles.mnn=get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in sdnncheck.
function sdnncheck_Callback(hObject, eventdata, handles)
handles.sdnn=get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in cvcheck.
function cvcheck_Callback(hObject, eventdata, handles)
handles.cv=get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in poincarecheck.
function poincarecheck_Callback(hObject, eventdata, handles)
handles.poincare=get(hObject,'Value');
if handles.poincare
    set(handles.delaybox,'enable','on');
    set(handles.delaypopup,'enable','on');
else
    set(handles.delaybox,'enable','off');
    set(handles.delaypopup,'enable','off');
end
guidata(hObject, handles);




    
% --- Executes on button press in lombcheck.
function lombcheck_Callback(hObject, eventdata, handles)
handles.lomb=get(hObject,'Value');
if handles.lomb
    enableLombbuttons(handles,'on')    
else
    enableLombbuttons(handles,'off') 
end 
guidata(hObject, handles);

function enableLombbuttons(handles,mode)
    set(handles.higherLFbox,'enable',mode);
    set(handles.higherLFpopup,'enable',mode);
    set(handles.higherHFbox,'enable',mode);
    set(handles.higherHFpopup,'enable',mode);
    set(handles.lowerLFbox,'enable',mode);
    set(handles.lowerLFpopup,'enable',mode);
    set(handles.lowerHFbox,'enable',mode);
    set(handles.lowerHFpopup,'enable',mode);

% --- Executes on button press in Default.
function Default_Callback(hObject, eventdata, handles)

handles.ECGchname = 'ECG';

% handles.needfilter = 1;
    handles.detrend=1;
    handles.notch=60;
    handles.lowpass=[];
    handles.highpass=[];

handles.epochsize=5; 

handles.artifact = 0;
    handles.maxhr=110;
    handles.minhr=40;
    handles.maxdhr = 20;

handles.mnn=1;
handles.sdnn=1;
handles.cv=1;
handles.poincare=1;
    handles.pctau=1;
handles.lomb=1;
    handles.lowerLF=0.04;
    handles.higherLF=0.15;
    handles.lowerHF=0.15;
    handles.higherHF=0.4;

handles.fnameopt='';
handles.outfolderopt = 'Save in same folder as input file';
handles.outPath = cd;
handles.savexls=0;
handles.savetxt=0;
handles.showlog=0;

setbox(handles);
guidata(hObject, handles);


% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% check error control and assign value to the output handle 
% if there is no error

if handles.isreadonly
    figure1_CloseRequestFcn(hObject, eventdata, handles);
    return;
end

handles=checkform(handles);
if handles.IPerror
    return;
end

config=handles.config;
save(handles.SettingName,'config');

guidata(hObject, handles);
figure1_CloseRequestFcn(hObject, eventdata, handles);

function err=notpositive(x,y,msg)
err=0;

if ~isempty(x) 
    if isnan(x) || x<=0
       errordlg([msg ' must be a positive number'],'Input error','replace'); 
       set(y,'BackgroundColor',[1 0.6 0.7]);
       err = 1;
    end
end



% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
figure1_CloseRequestFcn(hObject, eventdata, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
uiresume(handles.figure1);


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% currentCharacter = get(hObject,'CurrentCharacter')+0;
% if currentCharacter==13 %if hit enter
%     OK_Callback(hObject, eventdata, handles);
% end
    
    


% % --- Executes on button press in showlogcheck.
% function showlogcheck_Callback(hObject, eventdata, handles)
% handles.showlog=get(hObject,'Value');
% guidata(hObject, handles);




function epochbox_Callback(hObject, eventdata, handles)
handles.epochsize=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function epochbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in epochpopup.
function epochpopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.epochsize=str2double(contents{get(hObject,'Value')});
set(handles.epochbox,'string',contents{get(hObject,'Value')});
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function epochpopup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in delaypopup.
function delaypopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.pctau=str2double(contents{get(hObject,'Value')});
set(handles.delaybox,'string',contents{get(hObject,'Value')});
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function delaypopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delaypopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delaybox_Callback(hObject, eventdata, handles)
handles.pctau=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function delaybox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in lowerLFpopup.
function lowerLFpopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.lowerLF=str2double(contents{get(hObject,'Value')});
set(handles.lowerLFbox,'string',contents{get(hObject,'Value')});
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lowerLFpopup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lowerLFbox_Callback(hObject, eventdata, handles)
handles.lowerLF=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lowerLFbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in higherLFpopup.
function higherLFpopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.higherLF=str2double(contents{get(hObject,'Value')});
set(handles.higherLFbox,'string',contents{get(hObject,'Value')});
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function higherLFpopup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function higherLFbox_Callback(hObject, eventdata, handles)
handles.higherLF=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function higherLFbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lowerHFpopup.
function lowerHFpopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.lowerHF=str2double(contents{get(hObject,'Value')});
set(handles.lowerHFbox,'string',contents{get(hObject,'Value')});
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lowerHFpopup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lowerHFbox_Callback(hObject, eventdata, handles)
handles.lowerHF=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lowerHFbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in higherHFpopup.
function higherHFpopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.higherHF=str2double(contents{get(hObject,'Value')});
set(handles.higherHFbox,'string',contents{get(hObject,'Value')});
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function higherHFpopup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function higherHFbox_Callback(hObject, eventdata, handles)
handles.higherHF=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function higherHFbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxHRbox_Callback(hObject, eventdata, handles)
handles.maxhr=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxHRbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minHRbox_Callback(hObject, eventdata, handles)
handles.minhr=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function minHRbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxdHRbox_Callback(hObject, eventdata, handles)
handles.maxdhr=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxdHRbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ECGchnumbox_Callback(hObject, eventdata, handles)
handles.chnum=get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ECGchnumbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ECGchnumbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in detrendcheck.
function detrendcheck_Callback(hObject, eventdata, handles)
handles.detrend=get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on selection change in notchpopup.
function notchpopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.notch=str2double(contents{get(hObject,'Value')});
if isnan(handles.notch)
    handles.notch=[];
end
set(handles.notchbox,'string',contents{get(hObject,'Value')});
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function notchpopup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function notchbox_Callback(hObject, eventdata, handles)
handles.notch=str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function notchbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in highpasspopup.
function highpasspopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.highpass=str2double(contents{get(hObject,'Value')});
if isnan(handles.highpass)
    handles.highpass=[];
end
set(handles.highpassbox,'string',contents{get(hObject,'Value')});
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function highpasspopup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function highpassbox_Callback(hObject, eventdata, handles)
handles.highpass=str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function highpassbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lowpasspopup.
function lowpasspopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.lowpass=str2double(contents{get(hObject,'Value')});
if isnan(handles.lowpass)
    handles.lowpass=[];
end
set(handles.lowpassbox,'string',contents{get(hObject,'Value')});
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lowpasspopup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lowpassbox_Callback(hObject, eventdata, handles)
handles.lowpass=str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lowpassbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveAsMenu_Callback(hObject, eventdata, handles)
handles=checkform(handles);
if handles.IPerror
    return;
end

path = fullfile(handles.rootpath,'setting');
[FileName,PathName] = uiputfile([path '\*.mat'],'Save as');

if FileName==0,return;end

handles.SettingName = fullfile(PathName,FileName);
if ~strcmp(handles.SettingName(end-3:end),'.mat')
    handles.SettingName=[handles.SettingName '.mat'];
end

config=handles.config;
save(handles.SettingName,'config');
set(handles.figure1,'Name',[handles.SettingName ' - HRV Setting'] );

guidata(hObject, handles);


% --------------------------------------------------------------------
function SaveMenu_Callback(hObject, eventdata, handles)
handles=checkform(handles);
if handles.IPerror
    return;
end

config=handles.config;
save(handles.SettingName,'config');
guidata(hObject, handles);

% --------------------------------------------------------------------
function handles=checkform(handles)
allblank = 1;
for i=1:length(handles.chnum)
    if int16(handles.chnum(i))~=32
        allblank = 0;
    end
end

if (isempty(handles.chnum) || allblank) && strcmp(handles.set.ifileopt,'ECG')==1
   errordlg('ECG channel name must contain at least a letter.','Input error','replace'); 
   set(handles.ECGchnumbox,'BackgroundColor',[1 0.6 0.7]);
   handles.IPerror=1; return;
end
set(handles.ECGchnumbox,'BackgroundColor',[1 1 1]);
handles.set.ecgch.chnum = handles.chnum;

% handles.set.preprocess.needfilter=handles.needfilter;
    handles.param.filter.detrend = handles.detrend;       
    if notpositive(handles.notch,handles.notchbox, 'Frequency of the notch filter')
        handles.IPerror=1; return;
    end
    set(handles.notchbox,'BackgroundColor',[1 1 1]);
    handles.param.filter.notch=handles.notch;
   
    if notpositive(handles.highpass,handles.highpassbox,'Frequency of the highpass filter') 
       handles.IPerror=1; return;
    end
    set(handles.highpassbox,'BackgroundColor',[1 1 1]); 
   
    if notpositive(handles.lowpass,handles.lowpassbox,'Frequency of the lowpass filter') 
       handles.IPerror=1; return;
    end
    set(handles.lowpassbox,'BackgroundColor',[1 1 1]);
    
    %check if low cut off < high cut off
    if ~isempty(handles.lowpass) && ~isempty(handles.highpass)
        if handles.highpass>=handles.lowpass
            errordlg('Low cutoff frequency must be less than high cutoff frequency.','Input error','replace'); 
            set(handles.lowpassbox,'BackgroundColor',[1 0.6 0.7]);
            set(handles.highpassbox,'BackgroundColor',[1 0.6 0.7]);
            handles.IPerror=1; return;
        end
    end
    set(handles.lowpassbox,'BackgroundColor',[1 1 1]);
    set(handles.highpassbox,'BackgroundColor',[1 1 1]);
    
    handles.param.filter.highpass=handles.highpass;
    handles.param.filter.lowpass=handles.lowpass;

if notpositive(handles.epochsize,handles.epochbox,'Epoch length') 
   handles.IPerror=1; return;
end
if handles.epochsize>10
    errordlg('Too wide epoch size! Maximum value is 10 minutes','Input error','replace');
    set(handles.epochbox,'BackgroundColor',[1 0.6 0.7]);
    set(handles.epochbox,'BackgroundColor',[1 0.6 0.7]);
    handles.IPerror=1; return;
end

set(handles.epochbox,'BackgroundColor',[1 1 1]);
handles.param.hrv.epochsize=handles.epochsize;

handles.set.preprocess.artifact = handles.artifact;
    if notpositive(handles.maxhr,handles.maxHRbox,'Max heart rate') 
       handles.IPerror=1; return;
    end
    set(handles.maxHRbox,'BackgroundColor',[1 1 1]);

    if notpositive(handles.minhr,handles.minHRbox,'Min heart rate') 
       handles.IPerror=1; return;
    end
    set(handles.minHRbox,'BackgroundColor',[1 1 1]);
    
    if notpositive(handles.maxdhr,handles.maxdHRbox,'Max heart rate difference') 
       handles.IPerror=1; return;
    end
    set(handles.maxdHRbox,'BackgroundColor',[1 1 1]);
    
    if handles.minhr>=handles.maxhr
            errordlg('Min heart rate must be less than Max heart rate.','Input error','replace'); 
            set(handles.minHRbox,'BackgroundColor',[1 0.6 0.7]);
            set(handles.maxHRbox,'BackgroundColor',[1 0.6 0.7]);
            handles.IPerror=1; return;
    end
    set(handles.minHRbox,'BackgroundColor',[1 1 1]);
    set(handles.maxHRbox,'BackgroundColor',[1 1 1]);
    
    handles.param.preprocess.maxhr=handles.maxhr;
    handles.param.preprocess.minhr=handles.minhr;
    handles.param.preprocess.maxdhr = handles.maxdhr;

handles.set.hrv.mnn=handles.mnn;
handles.set.hrv.sdnn=handles.sdnn;
handles.set.hrv.cv=handles.cv;
handles.set.hrv.poincare=handles.poincare;
    if isnan(handles.pctau) || handles.pctau<=0 || mod(handles.pctau,1)~=0
       errordlg('Poincare delay must be a positive integer','Input error','replace'); 
       set(handles.delaybox,'BackgroundColor',[1 0.6 0.7]);
       handles.IPerror=1; return;
    end
    
    set(handles.delaybox,'BackgroundColor',[1 1 1]);
    handles.param.hrv.pctau=handles.pctau;

handles.set.hrv.lomb=handles.lomb;
    if notpositive(handles.lowerLF,handles.lowerLFbox,'LowerLF') 
       handles.IPerror=1; return;
    end
    set(handles.lowerLFbox,'BackgroundColor',[1 1 1]);
    if notpositive(handles.higherLF,handles.higherLFbox,'HigherLF') 
       handles.IPerror=1; return;
    end
    set(handles.higherLFbox,'BackgroundColor',[1 1 1]);
    if notpositive(handles.lowerHF,handles.lowerHFbox,'LowerHF') 
       handles.IPerror=1; return;
    end
    set(handles.lowerHFbox,'BackgroundColor',[1 1 1]);
    if notpositive(handles.higherHF,handles.higherHFbox,'HigherHF') 
       handles.IPerror=1; return;
    end
    set(handles.higherHFbox,'BackgroundColor',[1 1 1]);
    
    if handles.lowerLF>=handles.higherLF
       errordlg('HigherLF must be greater than lowerLF','Input error','replace'); 
       set(handles.lowerLFbox,'BackgroundColor',[1 0.6 0.7]);
       set(handles.higherLFbox,'BackgroundColor',[1 0.6 0.7]);   
       handles.IPerror=1; return;
    end
    set(handles.lowerLFbox,'BackgroundColor',[1 1 1]);
    set(handles.higherLFbox,'BackgroundColor',[1 1 1]);  
    handles.param.hrv.lowerLF=handles.lowerLF;
    handles.param.hrv.higherLF=handles.higherLF;

    if handles.lowerHF>=handles.higherHF
       errordlg('HigherHF must be greater than lowerHF','Input error','replace'); 
       set(handles.lowerHFbox,'BackgroundColor',[1 0.6 0.7]);
       set(handles.higherHFbox,'BackgroundColor',[1 0.6 0.7]);   
       handles.IPerror=1; return;
    end
    set(handles.lowerHFbox,'BackgroundColor',[1 1 1]);
    set(handles.higherHFbox,'BackgroundColor',[1 1 1]);  

    handles.param.hrv.lowerHF=handles.lowerHF;
    handles.param.hrv.higherHF=handles.higherHF;

if ~handles.mnn && ~handles.sdnn && ~handles.cv && ~handles.poincare && ~handles.lomb
    errordlg('Please select at least one HRV method','Input error','replace');
    set(handles.mnncheck,'ForegroundColor',[1 0 0]);
    set(handles.sdnncheck,'ForegroundColor',[1 0 0]);
    set(handles.cvcheck,'ForegroundColor',[1 0 0]);
    set(handles.poincarecheck,'ForegroundColor',[1 0 0]);
    set(handles.lombcheck,'ForegroundColor',[1 0 0]);
    handles.IPerror=1; return;
end
set(handles.mnncheck,'ForegroundColor',[0 0 0]);
set(handles.sdnncheck,'ForegroundColor',[0 0 0]);
set(handles.cvcheck,'ForegroundColor',[0 0 0]);
set(handles.poincarecheck,'ForegroundColor',[0 0 0]);
set(handles.lombcheck,'ForegroundColor',[0 0 0]);    
    
handles.set.save.fnameopt = handles.fnameopt;
handles.set.save.outfolderopt = handles.outfolderopt;
handles.set.save.savexls=handles.savexls;
handles.set.save.savetxt=handles.savetxt;

allblank = 1;
for i=1:length(handles.outPath)
    if int16(handles.outPath(i))~=32
        allblank = 0;
    end
end

if isempty(handles.outPath) || allblank
   errordlg('Directory cannot be empty or blank.','Input error','replace'); 
   set(handles.foldertab,'BackgroundColor',[1 0.6 0.7]);
   handles.IPerror=1; return;
end
set(handles.foldertab,'BackgroundColor',[1 1 1]);
handles.set.save.outPath = handles.outPath;

handles.set.save.showlog=handles.showlog;

handles.config.set=handles.set;
handles.config.param=handles.param;

handles.IPerror=0;
