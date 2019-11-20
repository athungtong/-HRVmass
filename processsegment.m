function [Value RR_time RR_interval]=processsegment(handles,fromEDFview)   

    if ~fromEDFview
        % Detrend (remove AC)
        if handles.param.filter.detrend 
            handles.x(:,2)=detrendECG(handles.x(:,2));
        end

        if handles.set.preprocess.needfilter
            handles.x(:,2) = filter(handles.FilterParam.B,handles.FilterParam.A,handles.x(:,2));
        end
    end   
    
%     index=DetectR(handles.x(:,2)',handles.fs);
    index=RDetectionV3(handles.x,handles.fs);
    R_time=handles.x(index,1);  %This is the time of R peak; 
    RR_interval = diff(R_time);
    RR_time = R_time(1:end-1);
    
    
    % Ready to compute HRV for this segment
    Value=[];
    if handles.set.hrv.mnn, Value=[Value mean(RR_interval)]; end
    if handles.set.hrv.sdnn, Value=[Value std(RR_interval)]; end
    if handles.set.hrv.cv, Value=[Value std(RR_interval)/mean(RR_interval)]; end
    
    if handles.set.hrv.poincare
        Poincare=PoincarePlotCalculation(RR_interval,handles.param.hrv.pctau);
        Value=[Value Poincare.SD1];
        Value=[Value Poincare.SD2];
        Value=[Value Poincare.SDRatio];
    end
    
    if handles.set.hrv.lomb
        LF = [handles.param.hrv.lowerLF handles.param.hrv.higherLF];
        HF = [handles.param.hrv.lowerHF handles.param.hrv.higherHF];
        TF = [LF(1) HF(2)];
        Flomb=FlombCalculation(RR_time,RR_interval,TF,HF,LF);
        Value=[Value Flomb.LFP];
        Value=[Value Flomb.HFP];
        Value=[Value Flomb.LHR];        
    end    
end
