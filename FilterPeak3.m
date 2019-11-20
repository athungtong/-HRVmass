function index= FilterPeak3(ecg2,index,fs)
% Search back for too high RR interval
% Locate high RR interval by cook distance (search outlier)
% Reduce Threshold for ecg between normal RR and process to alll filters



if isempty(index) || length(index)==1
    return;
end

temp=-Inf;
RR = diff(index)/fs;
hii = leverage(RR);   ri = RR-mean(RR);   
ci = hii./(1-hii).*ri;
indl=ci>4/length(RR); % index of outliers
indl=find(indl);

%     figure(4)
%     plot((1:length(ecg2))/fs/60,ecg2);hold on;
%     plot(index/fs/60,ecg2(index),'r.');
%     plot(index(1:end-1)/fs/60,ci*100,'cx-');
%     hold off;

iter=0;  
while ~isempty(indl) && indl(1) ~= temp && iter<100
    iter=iter+1;
    temp=indl(1);
    for i=1:length(indl)
        indr=indl(i)+find( ci(indl(i)+1:end) < 4/length(RR) ,1,'first');
        x=ecg2(index(indl(i)) : index(indr));
        if length(x)<4,continue;end
        indexi = getCandidatePeak (x,2);

        th = 0.3 * min ([x(1) x(end)]);    
        indexi = indexi ( x(indexi)>th);
        index=[index;index(indl(i))+indexi-1]; 
%          (index(indl(i))+indexi-1)/fs/60
    end
    index=adjustPeak(ecg2,index); % Adjust peak to the local max of square of detrended raw signal
    index=FilterPeak(ecg2,index,fs); % Remove too small RR interval
    index=FilterPeak2(ecg2,index,fs); % Remove suspicious low amplitude peak
    

    
    % re-search
    RR = diff(index)/fs;

    hii = leverage(RR);   ri = RR-mean(RR);   
    ci = hii./(1-hii).*ri;
    indl=ci>4/length(RR); % index of outliers
    indl=find(indl);
end
    
    % 
% figure(4)
%     plot((1:length(ecg2))/fs/60,ecg2);hold on;
%     plot(index/fs/60,ecg2(index),'r.');
%     
% %     plot(indmax(2:end)/fs/60,ci2*100,'gx-');
% %     plot(index(1:end-1)/fs/60,ci*100,'cx-');
% %     plot(index(indl)/fs/60,ci(indl)*100,'go-');
%     hold off;
    
    
    




