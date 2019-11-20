function [Value rr_time rr_interval]=processsegment2(handles,r_time)   

    rr_interval=diff(r_time);    
    rr_time = r_time(1:end-1);

% Ready to compute HRV for this segment

%Exclude outlier 
    Value=[];
    hii = leverage(rr_interval);   ri = rr_interval-mean(rr_interval);   
    ci = hii./(1-hii).*ri.^2;
    indr=ci>4/length(rr_interval); % index of outliers
    temp=rr_interval;
    temp(indr)=[];

    if handles.set.hrv.mnn, Value=[Value mean(temp)]; end
    if handles.set.hrv.sdnn, Value=[Value std(temp)]; end
    if handles.set.hrv.cv, Value=[Value std(temp)/mean(temp)]; end
   
    if handles.set.hrv.poincare
        Poincare=PoincarePlotCalculation(rr_interval,handles.param.hrv.pctau);
        Value=[Value Poincare.SD1];
        Value=[Value Poincare.SD2];
        Value=[Value Poincare.SDRatio];
    end
    
    if handles.set.hrv.lomb
        LF = [handles.param.hrv.lowerLF handles.param.hrv.higherLF];
        HF = [handles.param.hrv.lowerHF handles.param.hrv.higherHF];
        TF = [LF(1) HF(2)];
        Flomb=FlombCalculation(rr_time,rr_interval,TF,HF,LF);
        Value=[Value Flomb.LFP];
        Value=[Value Flomb.HFP];
        Value=[Value Flomb.LHR];        
    end

%     Temp = DFA(RR_interval);
%     Value = [Value Temp];
end
