function r=RpeakDetectionAlgoFile(ecg,fs)
%%

% load('bi0010.mat'); ecg=ecg(:,2);
% ecg=load('ecg123at35.txt'); fs=100;ecg=ecg(:,2);


[row col]=size(ecg);
if col>row,ecg=ecg';end

w=5*60*fs; 

Sec=ceil(length(ecg)/w);

% Perform wavelet decomposition 
% select component that is corresponding to
% mixtures of pdf
% ecgd=ecg;
% ecgd2 = ecgd.^2;% Square to enhanced peak
r=[]; 
%detrendECG=[];
N=round(3*fs/128);
Nd = N-1;


% Preprocessing by derivative and moving average
y=ecg;
y(Nd+1:end)=ecg(Nd+1:end)-ecg(1:end-Nd);
N=round(3*fs/128);
% y=filter(ones(N,1)/N,1,y); %MA filter and zero padding the last point
y=smooth(y,N); 

for s=0:Sec-1
    
    if s==Sec-1
        x=y(w*s+1:end); x2=ecg(w*s+1:end);
        if length(x)< 4, continue; end
    else
        x=y(w*s+1 : w*(s+1));
    end
   
    [~, rs]=getRindex(x,fs);    
    r=[r;rs+w*s];    
end



% %Post processing
% % Adjust index to the peak of preprocessed signal (squared)
y2=y.^2;
r=adjustPeak(y2,r);
% 
r=FilterPeak3(y2,r,fs); % Search for suspicious high RR interval 
r=FilterPeak(y2,r,fs); % Remove too small RR interval
r=FilterPeak2(y2,r,fs); % Remove suspicious low amplitude peak

%Finally adjustPeak to ECG2
%prepare ecg2 for adjusting peak at the end of the process (detrend and square)
[c1,l1] = wavedec(ecg,8,'db7');
trend=wrcoef('a',c1,l1,'db7',8);
ecg2=(ecg-trend).^2;

r=adjustPeak(ecg2,r);


