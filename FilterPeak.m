% function [indmax indmin ind x2]=getCandidatePeak(handles)
function r=FilterPeak(x,r,fs)
% indmax is the index of all local maximum
% ind is the index of indmax that could be the R peak
% get candidate peak based on timing
if isempty(r),return;end
minpoint=getminpoint(r,fs);

i=find(diff(r)<minpoint) ;
while ~isempty(i)
    d=x(r(i))-x(r(i+1));
    t=[i(d<=0); i(d>0)+1];
    r(t)=[];
    
    minpoint=getminpoint(r,fs);
    i=find(diff(r)<minpoint) ;    
end

function minpoint=getminpoint(indmax,fs)
if isempty(indmax) || length(indmax)==1
    minpoint=0;
    return;
end

RR = diff(indmax)/fs;
meanHR=60/mean(RR);

if meanHR<= 220 % human ecg
    minRR = 60/220;
elseif meanHR >220 && meanHR <=500 %may be rat 
    minRR = 60/500;
elseif meanHR > 500 %may be mice ecg
    minRR = 60/700;
end

minpoint = round(minRR*fs);
