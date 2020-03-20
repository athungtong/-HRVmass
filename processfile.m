function handles=processfile(handles)
    
    % Exclude abnormal beats
    R_time=handles.R_time;
    
    if handles.set.preprocess.artifact 
        RR_time=R_time(1:end-1);
        RR_interval=diff(R_time);
        drr=abs(diff(RR_interval)); %detect rate of change of rr
        
        dr_time=R_time(1:end-2);
        
        % Find abnormal beat
        b=RR_time(60./RR_interval<handles.param.preprocess.minhr); % time of r peak such that rr interval greater than maxrr
        c=RR_time(60./RR_interval>handles.param.preprocess.maxhr); % time of r peak such that rr interval less than minrr
        d = dr_time(60./drr>handles.param.preprocess.maxdhr);
        a=[R_time(1);b;c;d];
%               
        
        a=sort(a);
        a=unique(a);
    else
        a=[R_time(1);R_time(end)];
    end   
    
%   preparing to process to HRV calculation       
    Value=[];
    Time=[];
    RR_time=[];
    RR_interval=[];
    
    N=handles.param.hrv.epochsize*60; %read epoch by epoch    
    for i=1:length(a)-1
        dt = a(i+1)-a(i);
        if dt<N,continue;end
        t0 = a(i);
        Seg=floor(dt/N);
        %Process segment------------------------------------------------
        for s=0:Seg-1
            r_time = R_time(R_time-t0>N*s & R_time-t0<N*(s+1));
            %skip if r_time is empty
            if isempty(r_time),continue;end
            %skip if r_time is shorter than 80% of N
            if r_time(end)-r_time(1) < N*0.8,continue;end                       
            
            rr_interval=diff(r_time);    
            rr_time = r_time(1:end-1);               
            
            value=[];
            %TIME DOMAIN ANALYSIS
            %Compute mean, sdnn, cv 
            hii = leverage(rr_interval);   ri = rr_interval-mean(rr_interval);   
            ci = hii./(1-hii).*ri.^2;
            indr=ci>4/length(rr_interval); % index of outliers
            temp=rr_interval;
            temp(indr)=[];
            
            if handles.set.hrv.stat
                dRR = diff(temp);
                value=[value mean(temp) std(temp) sqrt(mean(dRR.^2))]; %mnn,sdnn,rmssd
                %compute pNN50
                NN50 = sum(dRR>50*1e-3);
                value=[value NN50/length(dRR)*100]; %pNN50
            end            
            
            if handles.set.hrv.geo
                [f edges]=gethistogram(temp,1/128);
                value=[value sum(f)/max(f)]; %Triangular index
                
                %compute TINN here
                [Y X]=max(f); 
                %Left triangle                 
                d1=zeros(X-1,1);
                for x=1:X-1                 
                    q=[zeros(x-1,1); Y/(X-x)*((x:X)'-x)];
                    d1(x)=sum((f(1:X)-q).^2);              
                end
                [~, iA]=min(d1);
                A = edges(iA);
                
                %Right triangle                     
                d2=zeros(length(edges)-X,1);
                for x=X+1:length(edges)                   
                    q=[Y/(x-X)*(x-(X:x-1)'); zeros(length(edges)-x+1,1)];
                    d2(x-X)=sum((f(X:end)-q).^2);   
                end
                
                [~, iB]=min(d2); 
                B=edges(iB+X-1);      
                value=[value B-A]; %TINN=B-A               
            end 
            
            %FREQUENCE DOMAIN ANALYSIS
            %Compute Flomb index
            if handles.set.hrv.lomb
                LF = [handles.param.hrv.lowerLF handles.param.hrv.higherLF];
                HF = [handles.param.hrv.lowerHF handles.param.hrv.higherHF];
                TF = [LF(1) HF(2)];
                Flomb=FlombCalculation(rr_time,rr_interval,TF,HF,LF);
                value=[value Flomb.LFP Flomb.HFP Flomb.LHR Flomb.LFnu Flomb.HFnu];      
            end
            
            %NONLINEAR ANALYSIS
            %Compute poincare SD
            if handles.set.hrv.poincare
                Poincare=PoincarePlotCalculation(rr_interval,handles.param.hrv.pctau);
                value=[value Poincare.SD1 Poincare.SD2 Poincare.SDRatio];
            end
            
            %Sample and Approximate Entropy
            apen = ApEn(2,0.2*std(rr_interval),rr_interval,1);
            saen = SampEn(2,0.2*std(rr_interval),rr_interval,1);
            value=[value apen saen];
            %Detrended Fluctuation Analysis, DFA
            n=4:16;   N1=length(n);
            F_n=zeros(N1,1);
            for j=1:N1
                F_n(j)=DFA(rr_interval,n(j),1);
            end
            n=n';
           
            A=polyfit(log10(n(1:end)),log10(F_n(1:end)),1);
            Alpha1=A(1);
            
            % Again for alpha2
            n=16:3:64;   N1=length(n);
            F_n=zeros(N1,1);
            for j=1:N1
                F_n(j)=DFA(rr_interval,n(j),1);
            end
            n=n';
            A=polyfit(log10(n(1:end)),log10(F_n(1:end)),1);
            Alpha2=A(1);
            value=[value Alpha1 Alpha2];
%#########################################################################            
            % Add script to compute any other HRV index here 
            % Add new index on the right of vector "value"

%#########################################################################
            Value=[Value;value];
            Time=[Time;r_time(1)];
            RR_time=[RR_time;rr_time];
            RR_interval=[RR_interval;rr_interval];
        end
    end
    
    % Save infomation to the Results structure to be exported later
    Labels={};
    if handles.set.hrv.stat,Labels=[Labels {'MNN'},{'SDNN'},{'RMSSD'},{'pNN50'}];end
    if handles.set.hrv.geo,Labels=[Labels {'TRI'},{'TINN'}];end
    if handles.set.hrv.lomb,Labels=[Labels {'LFP'} {'HFP'} {'LHR'} {'LFnu'} {'HFnu'}];end 
    if handles.set.hrv.poincare,Labels=[Labels {'SD1'} {'SD2'} {'SDRatio'}];end
    Labels=[Labels {'ApEn'} {'SampEn'}];
    Labels=[Labels {'Alpha1'} {'Alpha2'}];
    
%#########################################################################            
    % If new HRV index are added, the label of the index must be added here 
    %Labels=[Labels {'new label'}];

%#########################################################################
        
    
    Results.hrv.Labels=Labels;
    Results.hrv.Value=Value;
    Results.hrv.time=Time;
    
    Results.RRinfo.segmentlength = handles.param.hrv.epochsize;
    Results.RRinfo.R_time=RR_time;
    Results.RRinfo.RR_interval=RR_interval;
        
    Results.rawfilename=handles.EDFfullfile;
    
    Results.set=handles.set;
    Results.param=handles.param;
    
    Results.fromHRVmass=1;
        
%     if strcmp(handles.set.ifileopt,'ECG')==1
%         Results.fileinfo.samplingfreq=handles.fs;
%     elseif strcmp(handles.set.ifileopt,'Rtime')==1
%         Results.fileinfo.samplingfreq=[];
%     end
    
    % save result into selected format files
    foutname=fullfile(handles.ResultsPath,handles.foutname);
    saveResults(foutname,Results);
    
end



