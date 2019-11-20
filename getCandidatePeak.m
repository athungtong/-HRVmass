function indmax=getCandidatePeak(x,minpeak)
% indmax is the index of all local maximum
% ind is the index of indmax that could be the R peak
%
%minpeak is the number of minimum local max around the candidate r peak. For example,
%the local maximum that is lower than the neighbor local maximum equal minpeak away to
%the left and to the right should not be the r peak



indmax=find(localmaxmin(x,'max'));
if isempty(indmax),return;end

%Take care of the tail, select the maximum peak
[~, imax]=max(x(indmax(end-minpeak+1:end)));
indmax( length(indmax)-minpeak+1:length(indmax) ~= length(indmax)-imax ) = [];


t=[];
for i=1:minpeak
    a=minpeak+find((x(indmax(minpeak+1:end-minpeak))-x(indmax(minpeak+1-i:end-minpeak-i)))<0);
    b=minpeak+find((x(indmax(minpeak+1:end-minpeak))-x(indmax(minpeak+1+i:end-minpeak+i)))<0);
    t=[t;a;b];
end
indmax(t)=[];

%Take care of the head, select the maximum peak
if length(indmax)<minpeak
    return;
end

[~, imax]=max(x(indmax(1:minpeak)));
indmax( 1:minpeak ~= imax ) = [];



