function [y ]=getQRSwave(x,minpeak)
%perform wavelet decomposition using db5
% x is a vector
% minpeak is interger number
N=6;

[C,L] = wavedec(x,N,'db7');
% N=6; [C,L] = wavedec(x,N,'haar');

X=zeros(length(x),N);

selectm=[]; sd=zeros(1,N);
for i=1:N
    X(:,i)=wrcoef('d',C,L,'db7',i);
% X(:,i)=wrcoef('d',C,L,'haar',i);
    X2=X(:,i).^2;
    indmax=getCandidatePeak(X2,minpeak);
    
    [Px,xi] = ksdensity(log(X2(indmax)));  %Px=smooth(Px,3); 
%     [Px,xi] = hist(log(y),100);  
    Px=smooth(Px,10)';   %Px=smooth(Px,10);
    
    indPx=localmaxmin(Px,'min');
    indPx(1)=0; indPx(end)=0; indPx=find(indPx);
    candidate=[]; %compute if plot
    for j=1:length(indPx)
        if sum(Px(1:indPx(j))/sum(Px))>0.1 && sum(Px(indPx(j)+1:end)/sum(Px))>0.05
            candidate =[candidate; j];   
        end
    end
    if ~isempty(candidate)
        selectm = [selectm i];
    else  % compute mean and variance, in case there is no local minimum occur
        mn=sum(xi.*Px)/sum(Px);    
        sd(i)=sum( (xi-mn).^2.*Px )/sum(Px);
    end
    
%     figure(4)
%     
%     subplot(N,1,i)
%     plot(x/5);hold on;
%     plot( X2,'g' ); hold on;
%     
%     plot(indmax,X2(indmax),'r.');hold off;
%     ylabel(num2str(i));
%     set(gca,'xticklabel','');
% % % %      
%     figure(5)
%     indPx=indPx(candidate);
%     subplot(N,1,i)
%     plot(xi,Px,'.-');hold on;
%     plot(xi(indPx),Px(indPx),'r*');hold off;
%     set(gca,'xticklabel','');
%     ylabel(num2str(i));
    
end

if isempty(selectm)
    [~,ind]=sort(sd,'descend');
    selectm = ind(1:2);
end
% selectm
% selectm=[4 5];
y=sum(X(:,selectm),2);
% y=X(:,4).*X(:,5);
% temp=ismember(1:N,selectm);
% n= temp==0;
% y=sum(X(:,n),2);
% y=x-y;




% xlimit=zeros(N,2);
% for i=1:N
%     figure(5), subplot(N,1,i);
%     xlimit(i,:)=get(gca,'xlim');
% end
% xlimit = [min(xlimit(:,1)) max(xlimit(:,2))];
% for i=1:N
%     figure(5), subplot(N,1,i);
%     xlim(xlimit);
% end    
    
% ind=find(diff(selectm)>1);
% selectm(ind+1)=[]; %exclude jumping component


% if no local minimum occur, select one component with
% highest variances.



