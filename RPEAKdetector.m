function varargout = RPeakdetector(varargin)
% RPEAKDETECTOR MATLAB code for RPeakdetector.fig
%      RPEAKDETECTOR, by itself, creates a new RPEAKDETECTOR or raises the existing
%      singleton*.
%
%      H = RPEAKDETECTOR returns the handle to a new RPEAKDETECTOR or the handle to
%      the existing singleton*.
%
%      RPEAKDETECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RPEAKDETECTOR.M with the given input arguments.
%
%      RPEAKDETECTOR('Property','Value',...) creates a new RPEAKDETECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RPeakdetector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RPeakdetector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RPeakdetector

% Last Modified by GUIDE v2.5 25-Jan-2017 12:34:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RPeakdetector_OpeningFcn, ...
                   'gui_OutputFcn',  @RPeakdetector_OutputFcn, ...
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


% --- Executes just before RPeakdetector is made visible.
function RPeakdetector_OpeningFcn(hObject, eventdata, handles, varargin)
% remove preference for overwrite saving dialog
if ispref('removeepoch'),rmpref('removeepoch');end
handles = getstart(handles);
handles.output = hObject;
guidata(hObject, handles);


function handles = getstart(handles)
handles.inputPath=cd;
handles.fname={};

cla(handles.axesRR);
cla(handles.axesRRz);
cla(handles.axesECG);

handles.set.ecgch.chpref = 0;
% handles.ECGFile='Choose ECG file';
set(handles.ListFile,'string','');
set(handles.DetrendCheck,'value',0);
set(handles.SquareCheck,'value',0);
set(handles.EnhanceCheck,'value',0);
handles.isdetrend=0;
handles.issquare=0;
handles.isenhance=0;

handles.ECGPath=cd;

% handles.set.ecgch.chnum='ECG';
% handles.param.filter.detrend=1;
% handles.set.preprocess.artifact = 0;

% handles.param.filter.notch=60;

% handles.param.filter.lowpass=[];
% handles.param.filter.highpass=[];

handles.epoch_length=5;
handles.popup_id=10;
set(handles.PopMenuWindowTime,'value',10);
handles.epoch_menu_values = [5; 10; 15; 20; 25; 30; 60; 120; 180; 300; 600];
handles.epoch_menu_strings = {'  5 sec','10 sec','15 sec','20 sec','25 sec',...
    '30 sec','  1 min','  2 min','  3 min','  5 min','10 min'};


handles.createSelectsubmenu=0;
handles.ResultPath=cd;
handles.currentECGfile='';
handles.fid=-1;
handles.ProjectName='';
set(handles.figure1,'Name','RPeakdetector');

handles.saved = 1;
handles.gname={};
handles.Group={};
handles.fname={};
handles.selHRV={};
handles.RRoption='RR';
set(handles.RRselectbutton,'value',1);
set(handles.HRselectbutton,'value',0);

    
handles=setsetting(handles);
handles=setparam(handles);
handles.rootpath=cd;
handles.ResultPath=handles.rootpath;

%enable multiselection
% set(handles.ListFile,'max',2); 
% set(handles.ListGroup,'max',2); 

handles=setforplot(handles,0);
handles=setforFile(handles,[]);
% set(handles.HRVFileMenu,'enable','off');

handles.showECG=0;
handles.ECGposition=[15.0000   14.2308  224.0000   49.6154];
handles.epochnum=1;

handles.stemplot=-1;
handles.stemplotz=-1;
handles.arrowplot=-1;
handles.arrowplotgroup=-1;
handles.plotanHRV=-1;
handles.plotR=-1;
% handles.pos1=get(handles.axesFile,'position');
% handles.posG=get(handles.axesGroup,'position');

handles.c=cell(24,1);
handles.c{1}=[0 100 255]/255;
handles.c{2}=[0 100 0]/255;
handles.c{3}=[200 0 255]/255;
handles.c{4}=[150 150 0]/255;
handles.c{5}=[50 0 255]/255;
handles.c{6}=[255 0 100]/255;
handles.c(7:12)=handles.c(1:6);
handles.c(13:18)=handles.c(1:6);
handles.c(19:24)=handles.c(1:6);

handles.fname='';
handles.selectedfilenum=1;
handles.RRoption='RR';
handles.popup_id=10;
handles.epoch_length=5;

handles.t0 =0;
handles.tend=0;

handles.xlimit=[ 0 1];
handles.isdetrend =0;
handles.issquare = 0;

    
fid=fopen('session.mat');
if fid==-1
     set(handles.LoadSession,'enable','off'); 
else
   set(handles.LoadSession,'enable','on'); 
end


% --- Outputs from this function are returned to the command line.
function varargout = RPeakdetector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function handles=setparam(handles)

handles.param.hrv.epochsize=5;

handles.param.filter.detrend=1;
handles.param.filter.notch=[];
handles.param.filter.lowpass=[];
handles.param.filter.highpass=[];

function handles=setsetting(handles)
handles.set.click = 'alt';
set(handles.Rclick,'value',1);
set(handles.Lclick,'value',0);
handles.set.ecgch.chnum = 'ECG';
handles.set.ecgch.defaultname = 'ECG';
handles.set.echch.chpref = 1;
handles.set.preprocess.artifact = 0;
handles.set.preprocess.needfilter = 0;

% handles.set.save.fnameCHopt = 'ECG';
handles.set.save.fnameopt = '';
handles.set.save.savexls=0;
handles.set.save.savetxt=1;
handles.set.save.outfolderopt = 'Save in same folder as ECG file';
handles.set.save.outPath = cd;
handles.set.save.showlog=0;


% --------------------------------------------------------------------
% --------------------------------------------------------------------


% --- Executes on selection change in ListFile.
function ListFile_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.EDFfullfile=contents{get(hObject,'Value')};
[filepath, filename]=fileparts(handles.EDFfullfile);
handles.foutname=[fullfile(filepath,filename) '_Rtime.txt'];
handles.fsetname=[fullfile(filepath,filename) '_setting.mat'];


handles.selectedfilenum=get(hObject,'Value');
if  isempty(handles.Results{handles.selectedfilenum}.RRinfo.R_time)
    handles=setforplot(handles,0);
    handles=loadRtimefile(handles);
end
    
handles=updateplot(handles);


guidata(hObject, handles);

% --- Executes during object creation, after Setting all properties.
function ListFile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------

function handles=updateplot(handles)

cla(handles.axesRR);
cla(handles.axesRRz);
cla(handles.axesECG);
selfile=handles.selectedfilenum;

if  isempty(handles.Results{selfile}.RRinfo.R_time)
    set(handles.OutputFiletxt,'string','Please click "Process" to detect R peak.');
    set(handles.OutputFiletxt,'ForegroundColor',[1 0 0]);
    handles=setforplot(handles,0);
end

if ~isempty(handles.Results{selfile}.RRinfo.R_time)
    set(handles.OutputFiletxt,'string',handles.foutname);
    set(handles.OutputFiletxt,'ForegroundColor',[0 0 0]);
    handles=setforplot(handles,1);
    handles.epochnum=1;
            
    handles=plotRR(handles);
    handles.t0=handles.Results{selfile}.RRinfo.R_time(1)/60;
    
    handles=plotstem(handles);    

    handles=plotsubRR(handles);
    handles=prepareECGfile(handles);
    if handles.foundECG
        handles=LoadandPlotECG(handles); 
    end
    
        
end

    
function handles=plotRR(handles)
    set(handles.OutputFiletxt,'string',handles.foutname); 
    fnum=handles.selectedfilenum;
    if isempty(handles.Results{fnum}.RRinfo.R_time),return;end   
    
    RR = handles.Results{fnum}.RRinfo.RR_interval;
    RR=filterRR(RR);
    
    if strcmp(handles.RRoption,'RR')        
        label='RR interval (s)';
    else
        RR = 60./RR;
        label=[{'Heart Rate'},{'(beats/min)'}];
    end 
    axes(handles.axesRR);
    plot(handles.Results{fnum}.RRinfo.R_time/60,RR,'color',[255 0 0]/256);    
    ylabel(label,'fontweight','bold');
    
%     handles.clickRR=0;
    set(handles.axesRR,'Color',[0.96,0.92,0.92],'fontsize',9);
    
    tend=handles.Results{fnum}.RRinfo.R_time(end);
    t1=handles.Results{fnum}.RRinfo.R_time(1);
    
    tick=round((t1:(tend-t1)/6:tend)/60*10/5)*5/10;
    tick =unique(tick);
    temp=datestr(tick/24/60,'HH:MM:SS');
    tickvec=cell(size(temp,1),1);
    for i=1:size(temp,1)
        tickvec{i}=temp(i,:);
    end
    if ~isempty(tick)
        xlim([tick(1) tend/60+handles.epoch_length/4]); 
    end
    set(handles.axesRR,'xtick',tick,'XTickLabel',tickvec);
    
    grid on;

    
% --------------------------------------------------------------------
function QuitGUI_Callback(hObject, eventdata, handles)

figure1_CloseRequestFcn(hObject, eventdata, handles)

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
if ~isempty(handles.fname)
    session.fname=handles.fname;
    session.selectedfilenum=handles.selectedfilenum;
    session.RRoption=handles.RRoption;
    session.popup_id=handles.popup_id;
    session.epoch_length=handles.epoch_length;
    
    session.t0 =handles.t0 ;
    session.tend=handles.tend;
    session.xlimit=handles.xlimit;
    session.isdetrend=handles.isdetrend;
    session.issquare=handles.issquare;
    session.isenhance=handles.isenhance;
    session.chnum =  handles.set.ecgch.chnum ;
    session.click =  handles.set.click;
    session.notch=handles.param.filter.notch;
    save('session.mat','session');
end
delete(handles.figure1);


function handles=setforplot(handles,plotting)
if plotting
        set(handles.PopMenuWindowTime,'enable','on');
%     set(handles.deletefileMenu,'enable','on');
%     set(handles.deletefilebutton,'enable','on');
%     set(handles.PrintMenu,'enable','on');
%     set(handles.printtool,'enable','on');
    set(handles.zoomintool,'enable','on');
    set(handles.zoomouttool,'enable','on');
    set(handles.pantool,'enable','on');
    set(handles.cursortool,'enable','on');
    
%     set(handles.TPVAMenu,'enable','on');
%     set(handles.showECGcheck,'enable','on');
    
    set(handles.pbRightButton,'enable','on');
    set(handles.pbLeftEpochButton,'enable','on');
    set(handles.subRRleftbutton,'enable','on');
    set(handles.subRRrightbutton,'enable','on');
%     set(handles.pb_GoToStart,'enable','on');
%     set(handles.pbGoToEnd,'enable','on');
%     set(handles.epochnumbox,'enable','on');
%     set(handles.firstepochnumbox,'enable','on');
%     set(handles.lastepochnumbox,'enable','on');
%     set(handles.RemoveEpochbutton,'enable','on');
    set(handles.RRselectbutton,'enable','on');
    set(handles.HRselectbutton,'enable','on');
    
    set(handles.DetrendCheck,'enable','on');
    set(handles.SquareCheck,'enable','on');
    set(handles.EnhanceCheck,'enable','on');
    
    set(handles.chnamebox,'enable','off');
    set(handles.notchpopup,'enable','off');
    set(handles.Processall,'enable','off');
    set(handles.Processselect,'enable','off');

else
     set(handles.PopMenuWindowTime,'enable','off');
%      set(handles.printtool,'enable','off');
    set(handles.zoomintool,'enable','off');
    set(handles.zoomouttool,'enable','off');
    set(handles.pantool,'enable','off');
    set(handles.cursortool,'enable','off');
        set(handles.pbRightButton,'enable','off');
    set(handles.pbLeftEpochButton,'enable','off');
        set(handles.subRRleftbutton,'enable','off');
    set(handles.subRRrightbutton,'enable','off');
%     set(handles.pb_GoToStart,'enable','off');
%     set(handles.pbGoToEnd,'enable','off');
%     set(handles.epochnumbox,'enable','off');
%     set(handles.firstepochnumbox,'enable','off');
%     set(handles.lastepochnumbox,'enable','off');
%     set(handles.RemoveEpochbutton,'enable','off');
    set(handles.RRselectbutton,'enable','off');
    set(handles.HRselectbutton,'enable','off');

    set(handles.DetrendCheck,'enable','off');
    set(handles.SquareCheck,'enable','off');
    set(handles.EnhanceCheck,'enable','off');
    
    set(handles.chnamebox,'enable','on');
    set(handles.notchpopup,'enable','on');
    set(handles.Processall,'enable','on');
    set(handles.Processselect,'enable','on');
end

function handles=setforFile(handles,fname)

if isempty(fname)
    set(handles.ListFile,'enable','off');
    set(handles.Processall,'enable','off');
    set(handles.Processselect,'enable','off');
%     set(handles.ListFile,'string','');    

%     set(handles.deletefileMenu,'enable','off');
%     set(handles.deletefilebutton,'enable','off');
%     set(handles.SettingMenu,'enable','off');
     
%     set(handles.hrvlist,'enable','off');   
%     set(handles.hrvlist,'string','');    
    
    handles.selectedfilenum=1;
    handles.selectedfile={};
%     set(handles.pvaluetxt,'string','');

%     set(handles.PrintMenu,'enable','off');
    
%     set(handles.TPVAMenu,'enable','off');
%     set(handles.showECGcheck,'enable','off');
%     set(handles.showECGcheck,'value',0);
    
    
% %     set(handles.epochnumbox,'string','');
%     set(handles.firstepochnumbox,'string','');
%     set(handles.lastepochnumbox,'string','');
%     set(handles.totalEpochtxt,'string','');
    
%     clearaxes(handles.axesGroup);
%     clearaxes(handles.axesFile);
    clearaxes(handles.axesRR);
%     clearaxes(handles.axesRRz);
%     clearaxes(handles.axesPC);
%     clearaxes(handles.axesLomb);
  
else % has some files
    set(handles.ListFile,'String',fname);
    set(handles.ListFile,'enable','on');  
    set(handles.Processall,'enable','on');
    set(handles.Processselect,'enable','on');
end

function clearaxes(h)
    cla(h);
    set(h,'XGrid','off')
    set(h,'YGrid','off')
    set(h,'yticklabel','','xticklabel','');
    axes(h); ylabel('');



% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)

if ~isfield(handles,'Results')
        guidata(hObject, handles);
        return;
end

Loc=get(handles.axesECG,'CurrentPoint');
handles.locdown=Loc;

Loc=get(handles.axesRR,'CurrentPoint');
xLim = get(handles.axesRR,'xlim');
yLim = get(handles.axesRR,'ylim');

% Check if button down is in RR(file) window
if (Loc(3)>yLim(1) & Loc(3)<yLim(2) & Loc(1)>xLim(1) & Loc(1)<xLim(2))
    selfile=handles.selectedfilenum;
    if isempty(handles.Results{selfile}.RRinfo.R_time)
        guidata(hObject, handles);
        return;
    end
    handles.t0=Loc(1)-handles.epoch_length/2; 
    if handles.t0<0, handles.t0=0; end
%     enableDisableFig(handles.figure1, false);

    handles=plotstem(handles);
    handles=plotsubRR(handles);
    handles=LoadandPlotECG(handles);
end

Loc=get(handles.axesRRz,'CurrentPoint');
xLim = get(handles.axesRRz,'xlim');
yLim = get(handles.axesRRz,'ylim');
% Check if button down is in RR(file) PopMenuWindowTime
if (Loc(3)>yLim(1) & Loc(3)<yLim(2) & Loc(1)>xLim(1) & Loc(1)<xLim(2))
   if isempty(handles.Results{handles.selectedfilenum}.RRinfo.R_time)
        guidata(hObject, handles);
        return;
   end
    
    epoch_length = min(handles.epoch_length,20/60);
    t0=Loc(1);
    handles.xlimit=[t0-epoch_length/2 t0+epoch_length/2];

    handles = moveblock(handles,handles.xlimit);
end

guidata(hObject, handles);

function handles=manualeditR(handles)
% manually edit R peak based on user right click
% -click on a peak which wasn't detected as R peak will result in adding
% that peak as an R peak
% -click on a peak which was detected as R peak will result in removing
% that R peak


t=handles.loc(1)*60;

index = round(handles.fs*t)-round(handles.fs*handles.x(1,1))+1;
index(index>length(handles.x))=[];

%Adjust peak to local max of ecg^2
x=handles.x(:,2);
ecg2=(detrendECG(x)).^2;

mx=localmaxmin(ecg2,'max');
mx=find(mx);
ind1=find(mx<index,2,'last');
ind2=find(mx>index,2,'first');
ind=[mx(ind1)'     index    mx(ind2)'];
[~,temp2]=max(ecg2(ind));
index=ind(temp2);

removeindex=find(ismember(handles.indexR,index), 1);

if ~isempty(removeindex)
    handles.indexR(removeindex)=[];
else
    handles.indexR=sort([handles.indexR;index]);    
end

axes(handles.axesECG);hold on;
if ishghandle(handles.plotR),delete(handles.plotR);end
handles.plotR=plot(handles.x(handles.indexR,1)/60 ,handles.ecg(handles.indexR),'.r','markersize',15); 
hold off;


function handles=semiautoeditR(handles)
% semi automatic editing R peak
% right click and drag to make a horizontal line 
% -any candidate peaks that are higher than this line will be detected as R
% peak
% - any candidate peaks that are lower than this line will not be detected
% as R peak, if there is any R peak below this line which was detected
% before, it will be removed
%
% work only if ECG is square and detrend

ecg=handles.ecg;
if ~handles.issquare
    ecg=ecg.^2;
end

minpeak = 2;
index=getCandidatePeak(ecg,minpeak);

% compute threshold, which is min point of the button down and up
th = min(handles.locdown(3), handles.locup(3)); %threshold

if ~handles.issquare
    th=th^2;
end

index=index( ecg(index)>th );

index=adjustPeak(ecg,index); % Adjust peak to the local max of square of detrended raw signal
index=FilterPeak(ecg,index,handles.fs); % Remove too small RR interval
index=FilterPeak2(ecg,index,handles.fs); % Remove suspicious low amplitude peak


% compute effective time
t=[handles.locdown(1) handles.locup(1)]*60; % start and stop time

indexminmax = sort(round(handles.fs*t)-round(handles.fs*handles.x(1,1))+1);
index(index<indexminmax(1))=[];
index(index>indexminmax(2))=[];

%existing R peaks are at these indices
indR=handles.indexR(handles.indexR>=indexminmax(1) & handles.indexR<=indexminmax(2));
% ind2=ismember(indR,index);
removeindex = indR(~ismember(indR,index)); %index to be remove

addindex=index(~ismember(index,indR)); %index to be add

handles.indexR(ismember(handles.indexR,removeindex))=[];
handles.indexR=sort([handles.indexR;addindex]);

%Need to make change to handles.Results{selfile} to change to the file

axes(handles.axesECG);hold on;
% plot(handles.x(addindex,1)/60 ,handles.ecg(addindex),'or','markersize',8); 
% plot(handles.x(removeindex,1)/60 ,handles.ecg(removeindex),'ok','markersize',8); 
if ishghandle(handles.plotR),delete(handles.plotR);end
handles.plotR=plot(handles.x(handles.indexR,1)/60 ,handles.ecg(handles.indexR),'.r','markersize',15); 

hold off;





function handles=plotstem(handles)
%Plot stem (bar) on RR plot, execuse only when RR time is available
if isempty(handles.Results{handles.selectedfilenum}.RRinfo.R_time),return;end
if ishghandle(handles.stemplot),delete(handles.stemplot);end

handles.tend=handles.t0+handles.epoch_length;

handles.ind1=find(handles.Results{handles.selectedfilenum}.RRinfo.R_time/60>=handles.t0,1,'first');
handles.ind2=find(handles.Results{handles.selectedfilenum}.RRinfo.R_time/60<=handles.tend,1,'last');

handles.R_time=handles.Results{handles.selectedfilenum}.RRinfo.R_time(handles.ind1:handles.ind2);
handles.RR_interval=handles.Results{handles.selectedfilenum}.RRinfo.RR_interval(handles.ind1:handles.ind2);    

%add for debug
ind1=find(handles.Results{handles.selectedfilenum}.RRinfo.Rann_time/60>=handles.t0,1,'first');
ind2=find(handles.Results{handles.selectedfilenum}.RRinfo.Rann_time/60<=handles.tend,1,'last');

handles.ann_time=handles.Results{handles.selectedfilenum}.RRinfo.Rann_time(ind1:ind2);



% update stem
% [handles.t0 handles.tend]
% [handles.R_time(1) handles.R_time(end)]/60 
axes(handles.axesRR);hold on;
ylimit=get(handles.axesRR,'ylim');
handles.stemplot=stem([handles.t0 handles.tend],1000*[1 1],...
'color',[0 100 255]/255,'marker','none','linewidth',1);
ylim(ylimit); hold off;

% handles=plotepoch(handles,selfile,t0);
% enableDisableFig(handles.figure1, true);       

% function handles=plotepoch(handles,selfile,t0)
% T=handles.epoch_length;
% tend=t0+T;
% ind1=find(handles.Results{selfile}.RRinfo.R_time/60>=t0,1,'first');
% ind2=find(handles.Results{selfile}.RRinfo.R_time/60<tend,1,'last');
% rr_time=handles.Results{selfile}.RRinfo.R_time(ind1:ind2);
% rr_interval=handles.Results{selfile}.RRinfo.RR_interval(ind1:ind2);    
% handles.RR_interval=rr_interval;
% handles.R_time=rr_time;
% handles.t0=t0;
% 
% 
% handles=prepareECGfile(handles,selfile);
% 
% if handles.foundECG
%     % don't need to call ECGViewer if it's been already opened      
%     handles=LoadandPlotECG(handles); 
%     %plot subRR
%     handles=plotsubRR(handles);
% end

     

function handles=prepareECGfile(handles)

%     if strcmp(handles.currentECGfile,handles.Results{handles.selectedfilenum}.rawfilename)
%         return; %same file, use current file info
%     end        
    
    
    %HRVFileMenu new file
    handles.EDFfullfile=handles.Results{handles.selectedfilenum}.rawfilename;
    if handles.fid~=-1
        fclose(handles.fid);
        % close current file and process to hrvfilemenu the new one
    end
    handles.fid = fopen(handles.EDFfullfile);
    handles.currentECGfile=handles.EDFfullfile;

    % HRVFileMenu file dlg if cannot file not found
    if handles.fid==-1 
        [filename, filepath] = uigetfile('*.edf','Select ECG file');
        if filename==0,handles.foundECG=0;return;end
        handles.EDFfullfile=fullfile(filepath,filename);
        handles.fid = fopen(handles.EDFfullfile);
        handles.currentECGfile=handles.EDFfullfile;
    end
       
    % Load some setting
    fid=fopen(handles.fsetname);
    if fid~=-1
        load(handles.fsetname); 
        handles.set.ecgch.chnum = setting.chnum;
        handles.param.filter.notch = setting.notch;
        fclose(fid);
    end
    
    set(handles.chnamebox,'string',handles.set.ecgch.chnum);
    if isempty(handles.param.filter.notch)
        set(handles.notchpopup,'value',1);
    elseif handles.param.filter.notch==60
        set(handles.notchpopup,'value',2);
    else 
        set(handles.notchpopup,'value',3);
    end

    
%     handles.set=handles.Results{selfile}.set;
%     handles.param=handles.Results{selfile}.param;
    handles.set.ecgch.defaultname = handles.set.ecgch.chnum;
    handles=findchannelnum(handles);
    if isempty(handles.ECGch)
        set(handles.DetrendCheck,'enable','off');
        set(handles.SquareCheck,'enable','off');
        set(handles.EnhanceCheck,'enable','off');
        handles.foundECG=0;
        return;
    end
    handles.foundECG=1;
    set(handles.DetrendCheck,'enable','on');
    set(handles.SquareCheck,'enable','on');
    set(handles.EnhanceCheck,'enable','on');
    

    % Collect file information
    h=edfInfo(handles.EDFfullfile);
    handles.FileInfo=h.FileInfo; handles.ChInfo=h.ChInfo;
    handles.fs=handles.ChInfo.nr(handles.ECGch)/handles.FileInfo.DataRecordDuration;
    handles.numdata=handles.FileInfo.NumberDataRecord*handles.FileInfo.DataRecordDuration;

    numSkipHeaderByte=handles.FileInfo.HeaderNumBytes; %header byte
    numSkipBeforByte=2*sum(handles.ChInfo.nr(1:(handles.ECGch-1))); %byte of channels before first ecg channel    
    handles.numSkipAfterByte=2*(sum(handles.ChInfo.nr)-handles.ChInfo.nr(handles.ECGch)); %byte of channel after the last ECGch
     
     
    fseek(handles.fid,numSkipHeaderByte+numSkipBeforByte,-1);
    handles.origin=ftell(handles.fid);
    
    % Design filter
    handles=DesignFilters(handles);
    handles.w=handles.epoch_length*60;

    
function handles=LoadandPlotECG(handles)

if ~handles.foundECG,return;end

handles.w=handles.epoch_length*60;

handles.offset=handles.t0*60;

blockstart=floor(handles.offset/handles.FileInfo.DataRecordDuration)*handles.FileInfo.DataRecordDuration;
ndel1 = round((handles.offset-blockstart)*handles.fs); %number of data point to be deleted after load the block

N=ceil(handles.w/handles.FileInfo.DataRecordDuration)*handles.FileInfo.DataRecordDuration+1; %number of second to be read
data=zeros(N*handles.fs,1);    
w=handles.ChInfo.nr(handles.ECGch); %number of data point in each block
fseek(handles.fid,handles.origin+2*sum(handles.ChInfo.nr)*blockstart/handles.FileInfo.DataRecordDuration,-1);


handles.x=edfread(N,handles,w,data,handles.offset,ndel1);
% fclose(handles.fid);

if isempty(handles.x)
    return;
end


handles.x(handles.x(:,1)>handles.offset+handles.w,:)=[];


handles=plotECG(handles);


function handles=plotECG(handles)


%Plot ECG
handles.ecg=handles.x(:,2);

% RDetectionV4(handles.ecg,handles.fs);

if handles.isenhance
    minpeak=2;
    handles.ecg=getQRSwaveGM(handles.ecg,handles.fs);
end

if handles.isdetrend 
    handles.ecg=detrendECG(handles.ecg);    
end

if handles.issquare
    handles.ecg=handles.ecg.^2;   
end

% handles.x(:,2) = filter(handles.FilterParam.B,handles.FilterParam.A,handles.x(:,2));
% handles.x(:,2)=detrendECG(handles.x(:,2));
% RDetectionV3(handles.x(:,2),handles.fs);


axes(handles.axesECG); 
plot(handles.x(:,1)/60 ,handles.ecg,'color',[0 100 200]/255); hold on; 
ylabel([{handles.ChInfo.Labels(handles.ECGch,1:5)}, {['(' handles.ChInfo.PhyDim(handles.ECGch,1:2) ')']}],'fontweight','bold');
t1=handles.x(1,1);
tend=handles.x(end,1);

tick=(t1:(tend-t1)/5:tend)/60*2/2;
tick =unique(tick);
temp=datestr(tick/24/60,'HH:MM:SS');
tickvec=cell(size(temp,1),1);
for i=1:size(temp,1)
    tickvec{i}=temp(i,:);
end

set(handles.axesECG,'xtick',tick,'XTickLabel',tickvec);
if ~isempty(tick)
    xlim([tick(1) tick(end)]);
end
grid on;
handles.xlimit = get(gca,'xlim');


%Plot R_time
handles.indexR = round(handles.fs*handles.R_time)-round(handles.fs*handles.x(1,1))+1;
% index = round(handles.fs*handles.R_time-handles.x(1,1))+1;
% index = floor(handles.fs*handles.R_time)-floor(handles.fs*handles.x(1,1))+1

% tempR_time=handles.R_time;
% tempR_time(index>length(handles.x))=[];
handles.indexR(handles.indexR>length(handles.x))=[];


handles.plotR=plot(handles.x(handles.indexR,1)/60 ,handles.ecg(handles.indexR),'.r','markersize',15); 

%add for debug

handles.indexann = round(handles.fs*handles.ann_time)-round(handles.fs*handles.x(1,1))+1;
% [handles.fs length(handles.x) max(handles.indexann) ]

plot(handles.x(handles.indexann,1)/60 ,handles.ecg(handles.indexann),'ob','markersize',5); 

hold off;

%handles=forplot1(handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%show ECG filename
set(handles.axesECG,'Color',[0.97,0.97,0.9],'fontsize',9);
% enableDisableFig(handles.figure1, true);

function handles=plotsubRR(handles)
if isempty(handles.Results{handles.selectedfilenum}.RRinfo.R_time),return;end

axes(handles.axesRRz);
RR= handles.RR_interval;

RR=filterRR(RR);

if strcmp(handles.RRoption,'RR')    
    label='RR interval (s)';
else
    RR = 60./RR;
    label=[{'Heart Rate'},{'(beats/min)'}];
end  
plot(handles.R_time/60,RR,'.-','color',[255 0 0]/256);    
ylabel(label,'fontweight','bold');
grid on;
set(handles.axesRRz,'Color',[0.96,0.92,0.92],'fontsize',9);

t0=handles.t0*60;
tend=handles.tend*60;
tick=(t0:(tend-t0)/5:tend)/60*2/2;
tick =unique(tick);
temp=datestr(tick/24/60,'HH:MM:SS');
tickvec=cell(size(temp,1),1);
for i=1:size(temp,1)
    tickvec{i}=temp(i,:);
end

set(handles.axesRRz,'xtick',tick,'XTickLabel',tickvec);
if ~isempty(tick)
    xlim([tick(1) tick(end)]);
end

 

function x=edfread(N,handles,w,data,offset,ndel1)
if handles.FileInfo.SignalNumbers==1
    %if there is only ecg recording,don't need to do for loop, no skip
    data=fread(handles.fid,[N*handles.fs 1],'int16');
else     
    for i=1 : ceil(N/handles.FileInfo.DataRecordDuration)           
        temp=fread(handles.fid,[w 1],'int16'); 
        if length(temp)<w
            data(w*(i-1)+1 : w*(i-1)+length(temp))=temp;
            data(w*(i-1)+length(temp)+1:end)=[];
            break; 
        end
        data(w*(i-1)+(1:w))=temp;   
        fseek(handles.fid,handles.numSkipAfterByte,'cof');
    end
end

% scalling
data =(data-handles.ChInfo.DiMin(handles.ECGch))/(handles.ChInfo.DiMax(handles.ECGch)-handles.ChInfo.DiMin(handles.ECGch)) *...
    (handles.ChInfo.PhyMax(handles.ECGch)-handles.ChInfo.PhyMin(handles.ECGch))+handles.ChInfo.PhyMin(handles.ECGch);

if isempty(data)
    x=[];return;
end

data(1:ndel1)=[];

temp=offset+ (0:length(data)-1)'/handles.fs;
x=[temp data];




% --------------------------------------------------------------------
function SettingMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SettingMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
selfile=handles.selectedfilenum;
if ~isfield(handles,'Results'),return;end

if isempty(handles.Results{selfile}.RRinfo.R_time),return;end
if strcmp(eventdata.Key,'leftarrow') || strcmp(eventdata.Key,'backspace')
%     enableDisableFig(handles.figure1, false);
    handles.t0=handles.t0-handles.epoch_length;
    if handles.t0<0,handles.t0=0;end
    handles=plotstem(handles); 
    handles=plotsubRR(handles);
    handles=LoadandPlotECG(handles);

elseif strcmp(eventdata.Key,'rightarrow') || strcmp(eventdata.Key,'space')
%     enableDisableFig(handles.figure1, false);
    handles.t0=handles.t0+handles.epoch_length;
    if handles.t0+handles.epoch_length > handles.Results{selfile}.RRinfo.R_time(end)/60
        handles.t0=handles.Results{selfile}.RRinfo.R_time(end)/60-handles.epoch_length;
    end
    handles=plotstem(handles);
    handles=plotsubRR(handles);
    handles=LoadandPlotECG(handles);

elseif strcmp(eventdata.Key,'uparrow')
%     enableDisableFig(handles.figure1, false);
    handles.t0=0;
    handles=plotstem(handles); 
    handles=plotsubRR(handles);
    handles=LoadandPlotECG(handles);

elseif strcmp(eventdata.Key,'downarrow')
%     enableDisableFig(handles.figure1, false);
    handles.t0=handles.Results{selfile}.RRinfo.R_time(end)/60-handles.epoch_length;       
    handles=plotstem(handles); 
    handles=plotsubRR(handles);
    handles=LoadandPlotECG(handles);

end
guidata(hObject,handles);


% --- Executes when selected object is changed in RRoptions.
function RRoptions_SelectionChangeFcn(hObject, eventdata, handles)
temp=get(eventdata.NewValue,'string');
if strcmp(temp,'RR interval')
    handles.RRoption = 'RR';
else
    handles.RRoption = 'HR';
end

handles=updateRR(handles);
guidata(hObject, handles);


function handles=updateRR(handles)
issubstem=ishghandle(handles.stemplotz);

handles=plotRR(handles);
handles=plotstem(handles);
handles=plotsubRR(handles);

if issubstem
    xlimit=get(handles.axesECG,'xlim');
    axes(handles.axesRRz); hold on;
    ylimit=get(handles.axesRRz,'ylim');
    handles.stemplotz=stem(xlimit,1000*[1 1],...
    'color',[0 100 255]/255,'marker','none','linewidth',2);hold off;
    ylim(ylimit); 
end



% --- Executes on button press in pbRightButton.
function pbRightButton_Callback(hObject, eventdata, handles)
selfile=handles.selectedfilenum;
handles.t0=handles.t0+handles.epoch_length;
if handles.t0+handles.epoch_length > handles.Results{selfile}.RRinfo.R_time(end)/60
    handles.t0=handles.Results{selfile}.RRinfo.R_time(end)/60-handles.epoch_length;
end
handles=plotstem(handles);
handles=plotsubRR(handles);
handles=LoadandPlotECG(handles);
guidata(hObject, handles);


% --- Executes on button press in pbLeftEpochButton.
function pbLeftEpochButton_Callback(hObject, eventdata, handles)
handles.t0=handles.t0-handles.epoch_length;
if handles.t0<0,handles.t0=0;end
handles=plotstem(handles);
handles=plotsubRR(handles);
handles=LoadandPlotECG(handles);
guidata(hObject, handles);


% --- Executes on selection change in PopMenuWindowTime.
function PopMenuWindowTime_Callback(hObject, eventdata, handles)
xlimit=get(handles.axesRRz,'xlim');
% % xlimit0=get(handles.h.axesRRz,'xlim');
% xlimit0=get(handles.axesRR,'xlim');
% 
handles.popup_id = get(handles.PopMenuWindowTime,'value');
handles.epoch_length = handles.epoch_menu_values(handles.popup_id)/60;

handles.t0=xlimit(1);
handles=plotstem(handles);    
handles=plotsubRR(handles);    
handles=LoadandPlotECG(handles);
% if handles.epoch_length> xlimit0(2)-xlimit0(1), handles.epoch_length = xlimit0(2)-xlimit0(1);end
% xlimit(2) = xlimit(1)+handles.epoch_length;
% 
% if xlimit(2)>xlimit0(2)
%     xlimit(2)=xlimit0(2);
%     xlimit(1)=xlimit(2)-handles.epoch_length;
% end  
% handles = moveblock(handles,xlimit);


guidata(hObject,handles);

function handles = moveblock(handles,xlimit)
epoch_length = min(handles.epoch_length,20/60); 
xlimit0=get(handles.axesRRz,'xlim');
if xlimit(2)>xlimit0(2)
    xlimit(2)=xlimit0(2);
    xlimit(1)=xlimit(2)-epoch_length;
end

if xlimit(1)<xlimit0(1)
    xlimit(1)=xlimit0(1);
    xlimit(2)=xlimit(1)+epoch_length;
end
handles.xlimit=xlimit;

if ishghandle(handles.stemplotz),delete(handles.stemplotz);end
axes(handles.axesRRz); hold on;
ylimit=get(handles.axesRRz,'ylim');
handles.stemplotz=stem(handles.xlimit,1000*[1 1],...
'color',[0 100 255]/255,'marker','none','linewidth',2);hold off;
ylim(ylimit); 

axes(handles.axesECG);
set(handles.axesECG,'xlim',handles.xlimit);
ylim('auto');
tick=((handles.xlimit(1):(handles.xlimit(2)-handles.xlimit(1))/5:handles.xlimit(2))*2)/2;
tick =unique(tick);
temp=datestr(tick/24/60,'HH:MM:SS');
tickvec=cell(size(temp,1),1);
for i=1:size(temp,1)
    tickvec{i}=temp(i,:);
end
set(handles.axesECG,'xtick',tick,'XTickLabel',tickvec);

%handles=forplot2(handles);

% --- Executes during object creation, after setting all properties.
function PopMenuWindowTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopMenuWindowTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function handles=openfile(handles)


[filename, temp] = uigetfile({'*.edf','EDF-files (*.edf)'},'Open files','MultiSelect', 'on',handles.inputPath);

% if ~isfield(handles,'fname')
    handles.fname={};
% end

if ~iscell(filename) % select only one file
    if filename==0, return;end % do not select any file
    handles.inputPath=temp;
%     if sum(strcmp(handles.fname,fullfile(handles.inputPath,filename)))==0
       handles.fname={fullfile(handles.inputPath,filename)};
       handles.Results{1}.RRinfo.R_time=[];
%     end        
else %select multiply files
    handles.inputPath=temp;
    for i=1:length(filename)
        % check if new opening file is already in the list
        % select only files which are not already in the list
        if sum(strcmp(handles.fname,fullfile(handles.inputPath,filename{i})))==0
           handles.fname=[handles.fname;{fullfile(handles.inputPath,filename{i})}];
           %assign empty R time to this new file
           handles.Results{length(handles.fname)}.RRinfo.R_time=[];
        end
    end
end
handles=setforFile(handles,handles.fname);

function handles=start(handles,i)
%Ready to compute R time
handles.selectedfilenum=i;
set(handles.ListFile,'enable','off');
set(handles.figure1,'pointer', 'watch');
handles.canceled=0;
handles.logfid=fopen('logfile.txt','w');
fprintf(handles.logfid,'%s\r',['Process start: ' datestr(now)]);


set(handles.ListFile,'Value',i);
drawnow;
handles.EDFfullfile=handles.fname{i};
fid=fopen(handles.EDFfullfile);
if fid==-1
    text=['Cannot load ' handles.EDFfullfile];
    warndlg(text);
    fprintf(handles.logfid,'%s\r',text); 
    fclose(handles.logfid);
    set(handles.figure1,'pointer', 'arrow');
    set(handles.ListFile,'enable','on');
    return;
else
    fclose(fid);
end


%Check if outfile is already exist
[filepath, filename]=fileparts(handles.EDFfullfile);
handles.foutname=[fullfile(filepath,filename) '_Rtime.txt'];
handles.fsetname=[fullfile(filepath,filename) '_setting.mat'];
handles=detectRinEDFfile(handles);                
if ~isempty(handles.R_time)        
    R_time=handles.R_time;    
    setting.chnum = handles.set.ecgch.chnum ;
    setting.notch = handles.param.filter.notch;
    
    save(handles.foutname,'R_time','-ascii');
    save(handles.fsetname,'setting');
    
    handles.Results{i}.RRinfo.R_time=handles.R_time(1:end-1);
    handles.Results{i}.RRinfo.RR_interval=diff(handles.R_time);
    handles.Results{i}.rawfilename=handles.EDFfullfile;
end

if handles.canceled
   fprintf(handles.logfid,'%s\r',['Process canceled: ' datestr(now)]);
else
    fprintf(handles.logfid,'%s\r',['Process end: ' datestr(now)]);
end

fclose(handles.logfid);
set(handles.figure1,'pointer', 'arrow');
set(handles.ListFile,'enable','on');





function enablefilebuttons(handles,mode)
    set(handles.ListFile,'enable',mode);
%     if strcmp(mode,'on')
%         set(handles.ECGfile,'enable','off');
%         set(handles.Rfile,'enable','off');
%     else
%         set(handles.ECGfile,'enable','on');
%         set(handles.Rfile,'enable','on'); 
%      end



% --- Executes on button press in Processselect.
function Processselect_Callback(hObject, eventdata, handles)
handles.canceled=0;
handles.EDFfullfile=handles.fname{handles.selectedfilenum};
handles=start(handles,handles.selectedfilenum);
handles.EDFfullfile=handles.fname{handles.selectedfilenum};
[filepath, filename]=fileparts(handles.EDFfullfile);
handles.fsetname = [fullfile(filepath,filename) '_setting.mat'];
set(handles.ListFile,'Value',handles.selectedfilenum);
handles=updateplot(handles);

guidata(hObject, handles);



% --- Executes on button press in Processall.
function Processall_Callback(hObject, eventdata, handles)

handles.canceled=0;
for i=1:length(handles.fname)
    if handles.canceled,break;end
    
    handles.selectedfilenum=i;
    handles.EDFfullfile=handles.fname{i};
    [filepath, filename]=fileparts(handles.EDFfullfile);
    handles.foutname=[fullfile(filepath,filename) '_Rtime.txt'];
    fid=fopen(handles.foutname);
    if fid==-1
        handles=start(handles,i);
    else
        handles=loadRtimefile(handles);
        fclose(fid);
    end
end

handles.EDFfullfile=handles.fname{handles.selectedfilenum};
[filepath, filename]=fileparts(handles.EDFfullfile);
handles.fsetname = [fullfile(filepath,filename) '_setting.mat'];
set(handles.ListFile,'Value',handles.selectedfilenum);
handles=updateplot(handles);

guidata(hObject, handles);





function ECGchnumbox_Callback(hObject, eventdata, handles)
handles.chnum=get(hObject,'String');
allblank = 1;
for i=1:length(handles.chnum)
    if int16(handles.chnum(i))~=32
        allblank = 0;
    end
end

if (isempty(handles.chnum) || allblank)
   errordlg('ECG channel name must contain at least a letter.','Input error','replace'); 
   set(handles.ECGchnumbox,'BackgroundColor',[1 0.6 0.7]);
   handles.IPerror=1; return;
end
set(handles.ECGchnumbox,'BackgroundColor',[1 1 1]);
handles.set.ecgch.chnum = handles.chnum;

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


% --------------------------------------------------------------------
function opentool_ClickedCallback(hObject, eventdata, handles)
% handles=openfile(handles);
% guidata(hObject, handles);
handles=loadEDFfile(handles);
guidata(hObject, handles);


function handles=loadEDFfile(handles)

%save session before loading new files
if ~isempty(handles.fname)
    session.fname=handles.fname;
    session.selectedfilenum=handles.selectedfilenum;
    session.RRoption=handles.RRoption;
    session.popup_id=handles.popup_id;
    session.epoch_length=handles.epoch_length;
    
    session.t0 =handles.t0 ;
    session.tend=handles.tend;
    
    session.xlimit=handles.xlimit;
    session.isdetrend=handles.isdetrend;
    session.issquare=handles.issquare;
    session.isenhance=handles.isenhance;

    save('session.mat','session');
end

handles=openfile(handles);
if isempty(handles.fname),return;end

% processall new session
% handles=getstart(handles);
set(handles.ListFile,'value',1);
handles.EDFfullfile=char(handles.fname(1));

[filepath, filename]=fileparts(handles.EDFfullfile);
handles.foutname=[fullfile(filepath,filename) '_Rtime.txt'];
handles.fsetname=[fullfile(filepath,filename) '_setting.mat'];

set(handles.OutputFiletxt,'string',handles.foutname);

handles.selectedfilenum=1;

%show result only if R file is found
handles=loadRtimefile(handles);
handles=updateplot(handles);

function handles = loadRtimefile(handles)
[filepath, filename]=fileparts(handles.EDFfullfile);
handles.foutname=[fullfile(filepath,filename) '_Rtime.txt'];
handles.fsetname=[fullfile(filepath,filename) '_setting.mat'];
%add for debuging
handles.fannname=[fullfile(filepath,filename) '_ann.txt'];
fid=fopen(handles.foutname);
if fid~=-1
    handles.Results{handles.selectedfilenum}.rawfilename=handles.EDFfullfile;
    handles.EDFfullfile=handles.foutname;
%         handles=loadRfile(handles);
    handles.R_time = load(handles.EDFfullfile);
     handles.ann_time = load(handles.fannname);
%handles.ann_time=[];
    handles.Results{handles.selectedfilenum}.RRinfo.R_time=handles.R_time(1:end-1);
    handles.Results{handles.selectedfilenum}.RRinfo.RR_interval=diff(handles.R_time);    
    %added for debug
    handles.Results{handles.selectedfilenum}.RRinfo.Rann_time=handles.ann_time(1:end-1);

    fclose(fid);
end  

% --------------------------------------------------------------------
function newlist_ClickedCallback(hObject, eventdata, handles)
handles=getstart(handles);
handles=openfile(handles);
guidata(hObject, handles);



% --- Executes on button press in SquareCheck.
function SquareCheck_Callback(hObject, eventdata, handles)
handles.issquare = get(hObject,'Value');
xlimit=get(handles.axesECG,'xlim');
% handles=LoadandPlotECG(handles);
handles=plotECG(handles);
set(handles.axesECG,'xlim',xlimit);
guidata(hObject, handles);

% --- Executes on button press in DetrendCheck.
function DetrendCheck_Callback(hObject, eventdata, handles)
handles.isdetrend  = get(hObject,'Value');
xlimit=get(handles.axesECG,'xlim');
% handles=LoadandPlotECG(handles);
handles=plotECG(handles);
set(handles.axesECG,'xlim',xlimit);
guidata(hObject, handles);

% --- Executes on button press in EnhanceCheck.
function EnhanceCheck_Callback(hObject, eventdata, handles)
handles.isenhance  = get(hObject,'Value');
xlimit=get(handles.axesECG,'xlim');
% handles=LoadandPlotECG(handles);
handles=plotECG(handles);
set(handles.axesECG,'xlim',xlimit);
guidata(hObject, handles);


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'Results')
        guidata(hObject, handles);
        return;
end

selfile=handles.selectedfilenum;
if isempty(handles.Results{selfile}.RRinfo.R_time),return;end

if eventdata.VerticalScrollCount==-1
    handles.t0=handles.t0-handles.epoch_length;
    if handles.t0<0,handles.t0=0;end
    handles=plotstem(handles); 
    handles=plotsubRR(handles);
    handles=LoadandPlotECG(handles);

elseif eventdata.VerticalScrollCount==1
    handles.t0=handles.t0+handles.epoch_length;
    if handles.t0+handles.epoch_length > handles.Results{selfile}.RRinfo.R_time(end)/60
        handles.t0=handles.Results{selfile}.RRinfo.R_time(end)/60-handles.epoch_length;
    end
    handles=plotstem(handles);
    handles=plotsubRR(handles);
    handles=LoadandPlotECG(handles);
end
guidata(hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Loc=get(handles.axesECG,'CurrentPoint');
handles.locup = Loc;
xLim = get(handles.axesECG,'xlim');
yLim = get(handles.axesECG,'ylim');
if ~isfield(handles,'Results')
        guidata(hObject, handles);
        return;
end

% Check if button down is in RR(file) PopMenuWindowTime
if (Loc(3)>yLim(1) & Loc(3)<yLim(2) & Loc(1)>xLim(1) & Loc(1)<xLim(2))
    handles.loc = Loc;
    
    if strcmp(get(gcbf, 'SelectionType'),handles.set.click) 
        if handles.locdown==handles.locup
            handles=manualeditR(handles);
        else
        % Semi Auto, will work when enhanced R-peak is checked
            if handles.isdetrend
                handles=semiautoeditR(handles);
            end

        end
        r_time=handles.Results{handles.selectedfilenum}.RRinfo.R_time;
        remindex=r_time>=handles.t0*60 & r_time<=handles.tend*60;
        handles.Results{handles.selectedfilenum}.RRinfo.R_time(remindex)=[];

        handles.Results{handles.selectedfilenum}.RRinfo.R_time = ...
                sort([handles.Results{handles.selectedfilenum}.RRinfo.R_time;handles.x(handles.indexR,1)]);

        handles.Results{handles.selectedfilenum}.RRinfo.RR_interval=...
                diff(handles.Results{handles.selectedfilenum}.RRinfo.R_time);
        handles.Results{handles.selectedfilenum}.RRinfo.R_time(end)=[];
        
        % update RR plot
        handles=updateRR(handles);
        
        % save new RR to file
        r_time=handles.Results{handles.selectedfilenum}.RRinfo.R_time;
        save(handles.foutname,'r_time','-ascii');
        
    end     
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenu_Callback(hObject, eventdata, handles)
handles=loadEDFfile(handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function LoadSession_Callback(hObject, eventdata, handles)
load('session.mat');
%set gui value
handles.fname=session.fname;
if isempty(handles.fname),return;end

handles.selectedfilenum=session.selectedfilenum;
handles.RRoption=session.RRoption;
handles.epoch_length=session.epoch_length;
handles.popup_id=session.popup_id;
handles.isdetrend=session.isdetrend;
handles.issquare=session.issquare;
handles.isenhance=session.isenhance;

handles.set.ecgch.chnum = session.chnum ;
set(handles.chnamebox,'string',handles.set.ecgch.chnum);
handles.set.click = session.click;
if strcmp(handles.set.click,'alt')
    set(handles.Rclick,'value',1);
    set(handles.Lclick,'value',0);
else
    set(handles.Rclick,'value',0);
    set(handles.Lclick,'value',1);   
end

handles.param.filter.notch=session.notch;
if isempty(handles.param.filter.notch)
    set(handles.notchpopup,'value',1);
elseif handles.param.filter.notch==60
    set(handles.notchpopup,'value',2);
else 
    set(handles.notchpopup,'value',3);
end
    
set(handles.ListFile,'string',handles.fname);
set(handles.ListFile,'value',handles.selectedfilenum);

if strcmp(handles.RRoption,'RR')
    set(handles.RRselectbutton,'value',1);
    set(handles.HRselectbutton,'value',0);
else
    set(handles.RRselectbutton,'value',0);
    set(handles.HRselectbutton,'value',1);
end


set(handles.PopMenuWindowTime,'value',handles.popup_id);
set(handles.DetrendCheck,'value',handles.isdetrend);
set(handles.SquareCheck,'value',handles.issquare);
handles=setforFile(handles,handles.fname);

% process to plotting output

for i=1:length(handles.fname)
    handles.Results{i}.RRinfo.R_time=[];
end

handles.EDFfullfile=char(handles.fname(handles.selectedfilenum));
[filepath, filename]=fileparts(handles.EDFfullfile);
handles.foutname=[fullfile(filepath,filename) '_Rtime.txt'];
handles.fsetname=[fullfile(filepath,filename) '_setting.mat'];
handles=loadRtimefile(handles);

if isempty(handles.Results{handles.selectedfilenum}.RRinfo.R_time)
    set(handles.OutputFiletxt,'string','No R time file found. Click "Selected file" to detect QRS for this ECG file.');
    set(handles.OutputFiletxt,'ForegroundColor',[1 0 0]);
    handles=setforplot(handles,0);
    guidata(hObject, handles);
    return;
end

handles=updateplot(handles);
handles.t0 =session.t0 ;
handles.tend=session.tend;

handles=plotstem(handles);    
handles=plotsubRR(handles);

handles=prepareECGfile(handles);
if handles.foundECG
    handles=LoadandPlotECG(handles); 
end

handles.xlimit=session.xlimit;
handles = moveblock(handles,handles.xlimit);
   

guidata(hObject, handles);


% --- Executes on button press in subRRrightbutton.
function subRRrightbutton_Callback(hObject, eventdata, handles)

    epoch_length = min(handles.epoch_length,20/60);
    xLim = get(handles.axesECG,'xlim');
    xlimit=xLim+epoch_length;
    
    handles = moveblock(handles,xlimit);
guidata(hObject, handles);


% --- Executes on button press in subRRleftbutton.
function subRRleftbutton_Callback(hObject, eventdata, handles)
    epoch_length = min(handles.epoch_length,20/60);
    xLim = get(handles.axesECG,'xlim');
    xlimit=xLim-epoch_length;%[xLim(1)-epoch_length xLim(1)];
    
    handles = moveblock(handles,xlimit);
guidata(hObject, handles);


% --------------------------------------------------------------------
function Preferences_Callback(hObject, eventdata, handles)
% enableDisableFig(handles.figure1, false);
[handles.set.ecgch.chnum handles.set.click handles.param.filter.notch] =...
    Preferences(handles.set.ecgch.chnum,handles.set.click, handles.param.filter.notch);
% enableDisableFig(handles.figure1, true);
guidata(hObject, handles);


% --- Executes on selection change in notchpopup.
function notchpopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
handles.param.filter.notch=str2double(contents{get(hObject,'Value')});
if isnan(handles.param.filter.notch)
    handles.param.filter.notch=[];
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function notchpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notchpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function chnamebox_Callback(hObject, eventdata, handles)
handles.set.ecgch.chnum=strtrim(get(hObject,'String'));
handles=updateplot(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function chnamebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chnamebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in mouseoption.
function mouseoption_SelectionChangeFcn(hObject, eventdata, handles)
temp=get(eventdata.NewValue,'string');
if strcmp(temp,'Right click')
    handles.set.click = 'alt';
else
    handles.set.click = 'normal';
end
guidata(hObject, handles);


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'Results')
        set(handles.timebox,'string','');
        guidata(hObject, handles);
        return;
end

Loc=get(handles.axesRR,'CurrentPoint');
xLim = get(handles.axesRR,'xlim');
yLim = get(handles.axesRR,'ylim');

% Check if button down is in RR(file) window
if (Loc(3)>yLim(1) & Loc(3)<yLim(2) & Loc(1)>xLim(1) & Loc(1)<xLim(2))
    t = Loc(1);
    temp=datestr(t/24/60,'HH:MM:SS');
    set(handles.timebox,'string',temp);
end


Loc=get(handles.axesRRz,'CurrentPoint');
xLim = get(handles.axesRRz,'xlim');
yLim = get(handles.axesRRz,'ylim');
% Check if button down is in RR(file) PopMenuWindowTime
if (Loc(3)>yLim(1) & Loc(3)<yLim(2) & Loc(1)>xLim(1) & Loc(1)<xLim(2))
    t=Loc(1);
    temp=datestr(t/24/60,'HH:MM:SS');
    set(handles.timebox,'string',temp);
end

Loc=get(handles.axesECG,'CurrentPoint');
xLim = get(handles.axesECG,'xlim');
yLim = get(handles.axesECG,'ylim');
% Check if button down is in RR(file) PopMenuWindowTime
if (Loc(3)>yLim(1) & Loc(3)<yLim(2) & Loc(1)>xLim(1) & Loc(1)<xLim(2))
    t=Loc(1);
    temp=datestr(t/24/60,'HH:MM:SS.FFF');
    set(handles.timebox,'string',temp);
end


% --- Executes when uipanel9 is resized.
function uipanel9_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
