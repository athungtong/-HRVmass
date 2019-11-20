 function [index index1 indr]= FilterPeak2(ecg2,index,fs)
% Remove too low and suspicious low amplitute peak
% Locate low amplitute by check if RR interval is an
% outlier by computing cook distance.
% For each suspicious point, compare amplitute of the peak 
% before and itself, if the amplitude drop ten time,
% remove this peak.

if isempty(index) || length(index)==1
    return;
end


% Remove too low amplitude peak
index(ecg2(index) < 0.1*median(ecg2(index)))=[];

index1=1; index2=1;
RR = diff(index)/fs;%+ecg2(indmax(1:end-1));
% 
% figure(5)
% [Px,xi] = ksdensity(ecg2(indmax));
% plot(xi,Px);
% plot(ecg2)

hii = leverage(RR);   ri = mean(RR)-RR;   
ci = hii./(1-hii).*ri;
indr=ci>4/length(RR); % index of outliers
indr=find(indr);

% amp=ecg2(indmax(2:end));
% hii = leverage(amp);   ri = mean(amp)-amp;   
% ci2 = hii./(1-hii).*ri;
% figure(4)
%     plot((1:length(ecg2))/fs/60,ecg2);hold on;
%     plot(indmax/fs/60,ecg2(indmax),'r.');
% %     plot(indmax(2:end)/fs/60,ci2*100,'gx-');
%     plot(indmax(2:end)/fs/60,ci*100,'cx-');
% %     plot(indmax(2:end)/fs/60,(ci+ci2)*100,'rx-');
%     hold off;
% % indr2=ci>4/length(amp); % index of outliers
% % indr2=find(indr2);
% % indr2

while ~isempty(indr) && ( ~isempty(index1) || ~isempty(index2) ) 
    
%     drr=RR(2:end)/RR(1:end-1);
%     indr=find(drr<0.4)+1;
%     indr(indr<1)=[];
%     p30 = prctile(RR,30);
%     indr = find(RR<p30);
%     
    ind=[indr-1 indr indr+1];
    ind(ind(:,1)<1,:)=[];
    ind(ind(:,3)>length(index),:)=[];
    
    amp=[ecg2(index(ind(:,1))) ecg2(index(ind(:,2)))  ];
    ratio=amp(:,1)./amp(:,2);
    index1=indr(ratio>10);
    
    amp=[ecg2(index(ind(:,2))) ecg2(index(ind(:,3)))  ];
    ratio=amp(:,1)./amp(:,2);
    index2=indr(ratio>10)+1;
    index([index1;index2])=[];
    
    % search for new outlier
    RR = diff(index)/fs;%+ecg2(indmax(1:end-1));    
    hii = leverage(RR);   ri = mean(RR)-RR;   
    ci = hii./(1-hii).*ri;
    indr=ci>4/length(RR); % index of outliers
    indr=find(indr);

end

