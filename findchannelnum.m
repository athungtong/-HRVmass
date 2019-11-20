function [handles CHlabel]=findchannelnum(handles)
%give label of a channel, return the number of that channel

%get file handles
h = edfInfo(handles.EDFfullfile);
% search for required channel;

if handles.set.ecgch.chpref
    handles.set.ecgch.defaultname = handles.set.ecgch.chnum;
end
    

handles.ECGch=[];
for i=1:h.FileInfo.SignalNumbers
    isfound=strcmp(strtrim(h.ChInfo.Labels(i,:)),handles.set.ecgch.defaultname);    
    if isfound%~isempty(isfound)
        handles.ECGch=i;break;
    end
end


% check if there is any ECG channel
if isempty(handles.ECGch)
    enableDisableFig(handles.figure1, false);
    [handles.ECGch CHlabel handles.set.ecgch.chpref]=...
        selectCh(handles.EDFfullfile,handles.set.ecgch.defaultname,h.ChInfo.Labels,handles.set.ecgch.chpref);
    enableDisableFig(handles.figure1, true);
        
    if handles.set.ecgch.chpref
        handles.set.ecgch.defaultname = CHlabel;
    end
    handles.set.ecgch.chnum = CHlabel;
else
    handles.set.ecgch.chnum = handles.set.ecgch.defaultname;
end


