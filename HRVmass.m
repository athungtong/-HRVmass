function varargout = HRVmass(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HRVmass_OpeningFcn, ...
                   'gui_OutputFcn',  @HRVmass_OutputFcn, ...
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


% --- Executes just before HRVmass is made visible.
function HRVmass_OpeningFcn(hObject, eventdata, handles, varargin)
handles.inputPath=cd;
handles.fname={};

handles=setsetting(handles);
handles=setparam(handles);
handles.config.set=handles.set;
handles.config.param=handles.param;
handles.rootpath=cd;
handles.SettingName = fullfile(handles.rootpath,'setting','defaultsetting.mat');
content=handles.config;
save(handles.SettingName,'content');
[~, name] = fileparts(handles.SettingName);
set(handles.textconfigname,'string',name);

set(handles.textTotalFile,'string','0');

enablefilebuttons(handles,'off');

set(handles.ListFile,'max',2); 
set(handles.ListFile,'String','');
% Choose default command line output for HRVmass

% remove preference for overwrite saving dialog
if ispref('savefile'),rmpref('savefile');end
set(handles.figure1,'Name','HRVmass');
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HRVmass wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HRVmass_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function handles=setparam(handles)

handles.param.hrv.epochsize=5;
handles.param.hrv.pctau=1;
handles.param.hrv.lowerLF=0.04;
handles.param.hrv.higherLF=0.15;
handles.param.hrv.lowerHF=0.15;
handles.param.hrv.higherHF=0.4;

handles.param.preprocess.maxhr=220;
handles.param.preprocess.minhr=20;
handles.param.preprocess.maxdhr = 20;

handles.param.filter.detrend=0;
handles.param.filter.notch=[];
handles.param.filter.lowpass=[];
handles.param.filter.highpass=[];

function handles=setsetting(handles)

handles.set.ifileopt = 'ECG';
    set(handles.extbox,'enable','off');
    handles.set.ext = 'txt';
    handles.set.ecgch.chnum = 'ECG';
    handles.set.ecgch.defaultname = 'ECG';
    handles.set.ecgch.chpref = 1;
    handles.set.preprocess.artifact = 0;

handles.set.save.fnameopt = '';
handles.set.save.outfolderopt = 'Save in same folder as input file';
handles.set.save.outPath = cd;
handles.set.save.inputPath=cd;
handles.set.save.savexls=0;
handles.set.save.savetxt=0;
handles.set.save.showlog=0;
handles.isoverwrite=1;

handles.set.hrv.stat=1;
handles.set.hrv.geo=1;

handles.set.hrv.poincare=1;
handles.set.hrv.lomb=1;

% --------------------------------------------------------------------
function OpenFiles_Callback(hObject, eventdata, handles)

 if strcmp(handles.set.ifileopt,'ECG')
    [filename, handles.inputPath] = uigetfile({'*.edf','EDF-files (*.edf)'},'Open files','MultiSelect', 'on',handles.inputPath);
 elseif strcmp(handles.set.ifileopt,'Rtime')
    [filename, handles.inputPath] = uigetfile(['*.' handles.set.ext],'Open files','MultiSelect', 'on',handles.inputPath);
 end

if ~isfield(handles,'fname')
    handles.fname={};
end
if ~iscell(filename) % select only one file
    if filename==0, return;end
    if sum(strcmp(handles.fname,fullfile(handles.inputPath,filename)))==0
       handles.fname=[handles.fname;{fullfile(handles.inputPath,filename)}];
    end        
else %select multiply files
    for i=1:length(filename)
        % check if new opening file is already in the list
        % select only files which are not already in the list
        if sum(strcmp(handles.fname,fullfile(handles.inputPath,filename{i})))==0
           handles.fname=[handles.fname;{fullfile(handles.inputPath,filename{i})}];
        end
    end
end
handles=updatelistfile(handles);

handles.set.save.inputPath=handles.inputPath;
if strcmp(handles.set.save.outfolderopt,'Save in same folder as input file')
    handles.set.save.outPath=handles.set.save.inputPath;
end

guidata(hObject, handles);



% --------------------------------------------------------------------
function OpenDir_Callback(hObject, eventdata, handles)
handles.inputPath = uigetdir(handles.inputPath);
if handles.inputPath==0,return;end

file =dir(handles.inputPath); 
file(1:2)=[];
if ~isfield(handles,'fname')
    handles.fname={};
end

for i=1:length(file)
    [~,~,ext]=fileparts(file(i).name);
     if strcmp(handles.set.ifileopt,'ECG')==1
        if ~strcmp('.edf',ext) ,continue; end 
     elseif strcmp(handles.set.ifileopt,'Rtime')==1
        if ~strcmp(['.' handles.set.ext],ext) ,continue; end
     end
    
    if sum(strcmp(handles.fname,fullfile(handles.inputPath,file(i).name)))==0
       handles.fname=[handles.fname;{fullfile(handles.inputPath,file(i).name)}];
    end
end
handles=updatelistfile(handles);

handles.set.save.inputPath=handles.inputPath;
if strcmp(handles.set.save.outfolderopt,'Save in same folder as input file')
    handles.set.save.outPath=handles.set.save.inputPath;
end
guidata(hObject, handles);


% --- Executes on selection change in ListFile.
function ListFile_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.selectedfilenum=get(hObject,'Value');
handles.selectedfile={};
for i=1:length(handles.selectedfilenum)
    handles.selectedfile{i}=contents{handles.selectedfilenum(i)};
end
guidata(hObject, handles);


function handles=updatelistfile(handles)

handles.totalfile=size(handles.fname,1);
set(handles.textTotalFile,'string',handles.totalfile);

set(handles.ListFile,'String',handles.fname);  
num=min(handles.totalfile,min(get(handles.ListFile,'Value')));

if handles.totalfile>0    
    handles.selectedfilenum=num;
    set(handles.ListFile,'Value',num);
    handles.selectedfile={};
    handles.selectedfile{1} = handles.fname{num};       
    enablefilebuttons(handles,'on');  
else
    enablefilebuttons(handles,'off');
end


% --- Executes during object creation, after Setting all properties.
function ListFile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function Removefile_Callback(hObject, eventdata, handles)
if handles.totalfile==0,return;end
handles.fname(handles.selectedfilenum,:)=[];
handles=updatelistfile(handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function ClearList_Callback(hObject, eventdata, handles)
handles.fname=[];
handles=updatelistfile(handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function Setting_Callback(hObject, eventdata, handles)
enableDisableFig(handles.figure1, false);
[handles.set handles.param handles.SettingName]=Setting(handles.set,handles.param,0,0,handles.SettingName);
enableDisableFig(handles.figure1, true);
handles.config.set=handles.set;
handles.config.param=handles.param;
[~, name] = fileparts(handles.SettingName);
set(handles.textconfigname,'string',name);
guidata(hObject, handles);


% --------------------------------------------------------------------
function Loadconfig_Callback(hObject, eventdata, handles)
path = fullfile(handles.rootpath,'setting');
[FileName,PathName] = uigetfile([path '\*.mat'],'Load setting');

if FileName==0,return;end
file = fullfile(PathName,FileName);
load(file);
if ~exist('config')
    warndlg([file ' is not a setting file.'],'File error','replace');
    return;
end
handles.SettingName=file;

handles.config=config;
handles.set=config.set;
handles.param=config.param;
[~, name] = fileparts(handles.SettingName);
set(handles.textconfigname,'string',name);
guidata(hObject, handles);

% --------------------------------------------------------------------
function Saveasconfig_Callback(hObject, eventdata, handles)

path = fullfile(handles.rootpath,'setting');
[FileName,PathName] = uiputfile([path '\*.mat'],'Save as');

if FileName==0,return;end

handles.SettingName = fullfile(PathName,FileName);
if ~strcmp(handles.SettingName(end-3:end),'.mat')
    handles.SettingName=[handles.SettingName '.mat'];
end

config=handles.config;
save(handles.SettingName,'config');

[~, name] = fileparts(handles.SettingName);
set(handles.textconfigname,'string',name);
guidata(hObject, handles);

% --------------------------------------------------------------------
% function Deleteconfig_Callback(hObject, eventdata, handles)
% enableDisableFig(handles.figure1, false);
% [config handles.configname]=ConfigManager(handles.config,'delete',handles.rootpath,...
%     handles.configname,'newsetting','setting','Delete a setting');
% enableDisableFig(handles.figure1, true);
% guidata(hObject, handles);

% --- Executes on button press in ProcessAllbutton.
function handles=ProcessAllbutton_Callback(hObject, eventdata, handles)
handles=Start(handles,handles.fname,1);
guidata(hObject, handles);

% --------------------------------------------------------------------

function ProcessAll_Callback(hObject, eventdata, handles)
handles=Start( handles,handles.fname,1);
guidata(hObject, handles);

% --------------------------------------------------------------------
function Processselected_Callback(hObject, eventdata, handles)
handles=Start(handles,handles.selectedfile,0);
guidata(hObject, handles);



function handles=Start(handles,listfile,isall)
set(handles.figure1,'pointer', 'watch');
handles.canceled=0;
handles.logfid=fopen('logfile.txt','w');
fprintf(handles.logfid,'%s\r',['Process start: ' datestr(now)]);

if isall
    handles.selectedfilenum=1;
    set(handles.ListFile,'Value',handles.selectedfilenum);
end

for i=1:length(listfile)
    if handles.canceled,break;end
    set(handles.File,'enable','off');
    set(handles.Config,'enable','off');
    set(handles.ProcessAllbutton,'enable','off');
    set(handles.ListFile,'enable','off');
    set(handles.Settingbutton,'enable','off');
    set(handles.extbox,'enable','off');

    handles.EDFfullfile=listfile{i};
    %Test openning file
    handles.fid=fopen(handles.EDFfullfile);
    if handles.fid==-1
        text=['Cannot load ' handles.EDFfullfile];
        warning(text);
        fprintf(handles.logfid,'%s\r',text); 
        continue;
    end
    
    % check if outfile already exist and take appropriate action
    handles=getResultsfile(handles);
    if ~handles.isoverwrite && ~handles.canceled
        % Script to remove file from ListFile
        handles.fname(strcmp(handles.fname,listfile{i}),:)=[];    
        handles=updatelistfile(handles);
        drawnow;        
        continue;
    end

    
    
    %process input file  
    %Detect R from EDF file or Load R time
    if strcmp(handles.set.ifileopt,'ECG')==1
        handles=detectRinEDFfile(handles); 
        R_time=handles.R_time;
        %save R_time for future work
        save([handles.EDFfullfile '_R_time.txt'],'R_time','-ascii');       
    elseif strcmp(handles.set.ifileopt,'Rtime')==1
        handles=loadRfile(handles);
    end
    
    if ~isempty(handles.R_time) % do not process if loading R time is fail
        handles=processfile(handles);
    end
    

    % Script to remove file from ListFile
    handles.fname(strcmp(handles.fname,listfile{i}),:)=[];    
    handles=updatelistfile(handles);
    drawnow; 
end
handles=updatelistfile(handles);

set(handles.File,'enable','on');
set(handles.Config,'enable','on');
set(handles.Settingbutton,'enable','on');

if handles.canceled
   fprintf(handles.logfid,'%s\r',['Process canceled: ' datestr(now)]);
else
    fprintf(handles.logfid,'%s\r',['Process end: ' datestr(now)]);
end
fclose(handles.logfid);
set(handles.figure1,'pointer', 'arrow');

if handles.set.save.showlog
    open('logfile.txt');
end

% function handles  = loadR_time(handles)
%  
%     % detect or load R_time
%     if strcmp(handles.set.ifileopt,'ECG')==1
%         handles=detectRinEDFfile(handles); 
%         R_time=handles.R_time;
%         save(handles.foutname,'R_time','-ascii');
%     elseif strcmp(handles.set.ifileopt,'Rtime')==1
%         handles=loadRfile(handles);
%     end
%     
% %     %temporary for testing file 
% %     if strcmp(handles.set.ifileopt,'Rtime')==1
% %          handles.R_time=handles.R_time/256;
% %     end



function enablefilebuttons(handles,mode)
    set(handles.Processselected,'enable',mode);
    set(handles.ProcessAll,'enable',mode);
    set(handles.ProcessAllbutton,'enable',mode);
    set(handles.Removefile,'enable',mode);
    set(handles.ClearList,'enable',mode);    
    set(handles.ListFile,'enable',mode);
    
    if strcmp(mode,'on')
        set(handles.ECGfile,'enable','off');
        set(handles.Rfile,'enable','off');
        if strcmp(handles.set.ifileopt,'ECG');
            set(handles.extbox,'enable','off');
        else
            set(handles.extbox,'enable','on');
        end
    else
        set(handles.ECGfile,'enable','on');
        set(handles.Rfile,'enable','on'); 
        if strcmp(handles.set.ifileopt,'Rtime');
            set(handles.extbox,'enable','on');
        end
    end
    


% --------------------------------------------------------------------
function QuitGUI_Callback(hObject, eventdata, handles)

figure1_CloseRequestFcn(hObject, eventdata, handles)

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(handles.figure1);

% --- Executes on button press in Settingbutton.
function Settingbutton_Callback(hObject, eventdata, handles)
enableDisableFig(handles.figure1, false);
[handles.set handles.param handles.SettingName]=Setting(handles.set,handles.param,0,0,handles.SettingName);
enableDisableFig(handles.figure1, true);

handles.config.set=handles.set;
handles.config.param=handles.param;
[~, name] = fileparts(handles.SettingName);
set(handles.textconfigname,'string',name);
guidata(hObject, handles);


% --- Executes when selected object is changed in fileoption.
function fileoption_SelectionChangeFcn(hObject, eventdata, handles)
temp=get(eventdata.NewValue,'string');
if strcmp(temp,'ECG in EDF format')
    handles.set.ifileopt = 'ECG';
     set(handles.extbox,'enable','off');
else
    handles.set.ifileopt = 'Rtime';
    set(handles.extbox,'enable','on');
end
guidata(hObject, handles);



function extbox_Callback(hObject, eventdata, handles)
handles.set.ext=get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function extbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% % --------------------------------------------------------------------
% function HRV_ViewMenu_Callback(hObject, eventdata, handles)
% HRV_View;
% 
% % --------------------------------------------------------------------
% function EDF_ViewMenu_Callback(hObject, eventdata, handles)
% EDF_View;
