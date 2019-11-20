function handles=DesignFilters(handles)

% SelectedCh=evalin('base','SelectedCh');
% ChInfo = evalin('base','ChInfo');
% FileInfo = evalin('base','FileInfo');
% FilterPara = evalin('base','FilterPara');


TotalFilterA=1;
TotalFilterB=1;

% notch filter

if ~isempty(handles.param.filter.notch)
        wo = handles.param.filter.notch/(handles.fs/2);
        if wo>=1
            text=['Sampling rate is lower than notch filter. Notch filter was canceled in ' handles.EDFfullfile];
            warning(text);
            fprintf(handles.logfid,'%s\r',text); 

%             set(handles.notchbox,'ForegroundColor',[1 0 0]);
%             set(handles.notchpopup,'value',1)
%             set(handles.notchbox,'string','off');
%             handles.notch=[];
%             return;
        else
            
            bw = wo/35;
            [B,A] = iirnotch(wo,bw); % design the notch filter for the given sampling rate
            
            TotalFilterA = conv(TotalFilterA,A);
            TotalFilterB = conv(TotalFilterB,B);
        end
end


% low passs filtering

if ~isempty(handles.param.filter.lowpass)    
    Temp = handles.param.filter.lowpass/(handles.fs/2);
    
    if Temp>=1
        text=['Sampling rate is lower than low pass filter settings. Low pass filter was canceled in '...
            handles.inputfullfile];
        warning(text);
        fprintf(handles.logfid,'%s\r',text);
        set(handles.PopMenuLowPass,'value',Sel)        
    else   
        [B,A] = butter(2,Temp,'low');

        TotalFilterA = conv(TotalFilterA,A);
        TotalFilterB = conv(TotalFilterB,B);
    end
end


% High pass filtering
if ~isempty(handles.param.filter.highpass)
    Temp = handles.param.filter.highpass/(handles.fs/2);
    
    if Temp>=1
       text=['Sampling rate is lower than high pass filter settings. High pass filter was canceled in '...
            handles.inputfullfile];
        warning(text);
        fprintf(handles.logfid,'%s\r',text);
    else
        [B,A] = butter(1,Temp,'high');

        TotalFilterA = conv(TotalFilterA,A);
        TotalFilterB = conv(TotalFilterB,B);
    end
end
%assignin('base','FilterPara',FilterPara);
FilterPara.A=TotalFilterA;
FilterPara.B=TotalFilterB;

handles.FilterParam = FilterPara;