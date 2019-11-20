function index2=adjustPeak(ecg2,index)
% Adjust peak to the closest local max of square of detrended raw signal
% figure(1)
% plot(ecg2); hold on;
% plot(index,ecg2(index),'og');

index2=index;
mx=localmaxmin(ecg2,'max');
mx=find(mx);


% mx=getCandidatePeak(ecg2,2);
    
% for i=2:length(index)-1    
for i=1:length(index)    

    ind1=find(mx<index(i),5,'last');
    ind2=find(mx>index(i),5,'first');
    ind=[mx(ind1)'     index(i)    mx(ind2)'];
    ind(ind>length(ecg2))=[];
    [~,temp2]=max(ecg2(ind));
    index2(i)=ind(temp2);
%     input('continue?');

end
index2=unique(index2);

% 
% plot(index2,ecg2(index2),'.r'); hold off
%  input('continue?');