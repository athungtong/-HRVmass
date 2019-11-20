function handles = detectRinEDFfile(handles)

    handles=findchannelnum(handles);
    if isempty(handles.ECGch)
       text=['Cannot find the ECG channel name "'...
        handles.set.ecgch.chnum '" in the file '...
        handles.EDFfullfile];
        fprintf(handles.logfid,'%s\r',text); 
        handles.R_time=[];
        return;
    end
    

    % Collect file information
    h=edfInfo(handles.EDFfullfile);
    handles.FileInfo=h.FileInfo; handles.ChInfo=h.ChInfo;
    handles.fs=handles.ChInfo.nr(handles.ECGch)/handles.FileInfo.DataRecordDuration;
    handles.numdata=handles.FileInfo.NumberDataRecord*handles.FileInfo.DataRecordDuration;

    handles.fid=fopen(handles.EDFfullfile,'r');
    numSkipHeaderByte=handles.FileInfo.HeaderNumBytes; %header byte
    numSkipBeforByte=2*sum(handles.ChInfo.nr(1:(handles.ECGch-1))); %byte of channels before first ecg channel    
    handles.numSkipAfterByte=2*(sum(handles.ChInfo.nr)-handles.ChInfo.nr(handles.ECGch)); %byte of channel after the last ECGch
    fseek(handles.fid,numSkipHeaderByte+numSkipBeforByte,-1);
    handles.origin=ftell(handles.fid);

    
    % Design filter
    handles=DesignFilters(handles);

    % preparing to load ECG and process to R detection
    N=handles.param.hrv.epochsize*60; %read epoch by epoch
    offset=0;
    data=zeros(N*handles.fs,1);    
    w=handles.ChInfo.nr(handles.ECGch);

    nloop=0; approx_Nloop = handles.numdata/N;
    hwait=waitbar(nloop,handles.EDFfullfile,...
          'name','Loading ECG file and detecting R peak','CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');  
    setappdata(hwait,'canceling',0);

    
    %Read EDF data N points at a time, N depends on epoch size and sampling
    %frequency
    handles.canceled = 0;
    handles.R_time=[];
%     s=1;
    while offset<handles.numdata      
        handles.x=edfread(N,handles,w,data,offset,0);
        if isempty(handles.x),return;end           

        if handles.param.filter.detrend 
%             handles.x(:,2)=detrendECG(handles.x(:,2));
        end
        
        %Do not apply filter if not need notch
        %any low and high filter will not be used
        
        if ~isempty(handles.param.filter.notch)
            %handles.x(:,2) = filter(handles.FilterParam.B,handles.FilterParam.A,handles.x(:,2));
        end
        % Detect R index from ECG data
        index=RpeakDetectionAlgoFile(handles.x(:,2),handles.fs);
%         index=DetectR(handles.x(:,2)',handles.fs);
%          index=RDetectionV4(handles.x(:,2),handles.fs);
 %       index=RDetectionRaquel2015(handles.x(:,2),handles.fs);
%         index=HangsikShin(handles.x(:,2),handles.fs,0);
        
        r=handles.x(index,1);  %This is the time of R peak; 
        handles.R_time=[handles.R_time;r];
        if getappdata(hwait,'canceling')
            handles.canceled=1;            
            break;
        end
        nloop=nloop+1;
        waitbar(nloop / approx_Nloop);

        offset=offset+N;
%         s=s+1;
%         if s==2;break;end
    end
    delete(hwait);
    if handles.canceled,return;end
    % save R time in txt file
    
end


function x=edfread(N,handles,w,data,offset,ndel1)
if handles.FileInfo.SignalNumbers==1
    %if there is only ecg recording,don't need to do for loop, no skip
    data=fread(handles.fid,[N*handles.fs 1],'int16');
else        
    for i=1 : floor(N/handles.FileInfo.DataRecordDuration)           
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
data =(data-handles.ChInfo.DiMin(handles.ECGch))/(handles.ChInfo.DiMax(handles.ECGch)-handles.ChInfo.DiMin(handles.ECGch)) *...
    (handles.ChInfo.PhyMax(handles.ECGch)-handles.ChInfo.PhyMin(handles.ECGch))+handles.ChInfo.PhyMin(handles.ECGch);

if isempty(data)
    x=[];return;
end
data(1:ndel1)=[];
temp=offset + (0:length(data)-1)'/handles.fs;
x=[temp data];
end


