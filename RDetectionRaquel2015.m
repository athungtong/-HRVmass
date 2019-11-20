function r=RDetectionRaquel2015(ecg,fs)
%%

% load('bi0010.mat'); ecg=ecg(:,2);
% ecg=load('ecg123at35.txt'); fs=100;ecg=ecg(:,2);

% ecg=randn(10000,1);
[row col]=size(ecg);
if col>row,ecg=ecg';end

%set parameter
N=round(3*fs/128);
Nd = N-1;
Pth = 0.7*fs/128 + 4.7;
RRmin=300e-3;
RRint = 60e-3;
w=round((RRmin+RRint)*fs); 
NRRmin=round((RRmin-RRint)*fs);
Sec=ceil(length(ecg)/w);

% Preprocessing by derivative and moving average and squaring
%derivative
y=ecg;
y(Nd+1:end)=ecg(Nd+1:end)-ecg(1:end-Nd);
y=filter(ones(N,1)/N,1,y); %MA filter and zero padding the last point
y=y.^2;


%This is for s=0, the first segment
x=y(1 : w);
[~, r]=max(x);

for s=1:Sec-1    
    %state one: find the maximum
    if s==Sec-1
        x=y(w*s+1:end);
        if length(x)< 4, continue; end
    else
        x=y(w*s+1 : w*(s+1));
    end
    [Ramp, indRpeak]=max(x);    

    %state two, the waiting time
    th = median(y(r));
    %state 3: the initial mean value
    ind = w*s+indRpeak;
    d=ind-(r(end)+NRRmin);
    
    if( d>NRRmin )
       th=th*exp(-d*Pth/fs);
       if (Ramp>th)
         r=[r;ind];
         
       end
    end
    
end
r=adjustPeak(ecg.^2,r);
return;


    
    %thresholding
    
    %state 1 looking for a maximum peak in 
    % minimum QRS+RR interval (360ms for human)
    
   
%Post processing
% 
% 
% %Adjust index to the peak of ecg.^2 instead of
% %decomposed signal
% 
% r=adjustPeak(ecg2,r); % Adjust peak to the local max of square of detrended raw signal
% 
% r=FilterPeak(ecg2,r,fs); % Remove too small RR interval
% r=FilterPeak2(ecg2,r,fs); % Remove suspicious low amplitude peak
% r=FilterPeak3(ecg2,r,fs); % Search for suspicious high RR interval 
% % and try to reduce threshold see if peaks exist
% 
% 
% % % % % %     
% % % Scrip to plot
% % RR = diff(index)/fs;
% % RR(RR> 3)=NaN;
% % figure(2)
% % subplot(211),
% % plot(index(1:end-1)/fs/60,RR,'.-'); 
% % subplot(212)
% % 
% % 
% % plot((1:length(ecg2))/fs/60,ecg2);hold on;
% % % plot((1:length(x2))/fs/60,x2,'r');hold on;
% % plot(index/fs/60,ecg2(index),'g.','markersize',20); 
% % % plot(index2(index)/fs/60,ecg2(index2(index)),'ro'); 
% % 
% % % index2(index)=[];
% % % plot(index2/fs/60,ecg2(index2),'r*'); 
% % 
% % hold off; axis tight;
% % % input('con');
