function RR=filterRR(RR)
% Set RR interval to NaN if it exceed some certain level
% The output is used for plotting
% This make the plot easier to look

meanHR=60/mean(RR);
if meanHR <= 220 % human ecg
    RR(RR>3)=NaN;
    RR(RR<0.2727)=NaN;
elseif meanHR >220 && meanHR <=500 %may be rat 
    RR(RR>60/200)=NaN;
    RR(RR<60/500)=NaN;
elseif meanHR > 500 %may be mice ecg
    RR(RR>60/500)=NaN;
    RR(RR<60/700)=NaN;
end
