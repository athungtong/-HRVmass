function [Flomb f P]=FlombCalculation(RR_time,RR_interval,TF,HF,LF)
%%
% input 
% RR_time =time when beat2beat occur
% RR_interval=beat to beat interval
% TF: total freq range
% HF high freq range
% LF low freq range
if nargin<3
    TF = [0.04 0.4];
end
if nargin<4
    LF=[min(TF) mean(TF)];
    HF=[mean(TF) max(TF)];
% HF=[.15 .4]; %High Freq range
% LF=[.04 .15];%Low Freq range. For Human
% HF=[.25 1.5]; %High Freq range
% LF=[.01 .1];%Low Freq range. 
end
X=(RR_time);
Y=(RR_interval);
X=X-min(X);
[WK1 WK2]=FASPER(X,Y);
f=WK1;P=WK2;

% plot(f,(A/sum(A)));
% con=input('con?');

PVLF = P((f>=0) & ((f<LF(1))));
PLF = P((f>LF(1)) & ((f<LF(2))));
PHF = P((f>HF(1)) & ((f<HF(2))));
PTF = P((f>=TF(1)) & ((f<TF(2))));
if ~isempty(PLF)
    LFP=sum(PLF);
    LFnu=sum(PLF)/(sum(P)-sum(PVLF))*100;
else
    LFP = -Inf;
    LFnu = -Inf;
end

if ~isempty(PHF) 
    HFP=sum(PHF);
    HFnu=sum(PHF)/(sum(P)-sum(PVLF))*100;
else
    HFP = -Inf;
    HFnu = -Inf;
end

if ~isempty(PTF)
    TFP=sum(PTF);
else
    TFP = -Inf;
end
LHR=LFP./HFP;

Flomb.LFP=LFP;
Flomb.HFP=HFP;
Flomb.LHR=LHR;
Flomb.LFnu=LFnu;
Flomb.HFnu=HFnu;

Flomb.TFP=TFP;


end

