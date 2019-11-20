function [y ]=getQRSwaveGM(ecg,fs)
%% Let try this version, enhance by differentiation and integral

%set parameter
N=round(3*fs/128);
Nd = N-1;
Pth = 0.7*fs/128 + 4.7;

% Preprocessing by derivative and moving average and squaring
%derivative
y=ecg;
y(Nd+1:end)=ecg(Nd+1:end)-ecg(1:end-Nd);
y=[filter(ones(N,1)/N,1,y)]; %MA filter and zero padding the last point
y=y.^2;

return;



%% This is previous version, enhancing based on wavelet
%perform wavelet decomposition using db5
% x is a vector
% minpeak is interger number
N=6;

[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters('db7');
[C,L] = wavedec(x,N,Lo_D,Hi_D);


D=zeros(length(x),N);
for k=1:N
    D(:,k)=wrcoef('d',C,L,Lo_R,Hi_R,k);
end

X=zeros(size(D,1),8);
n=1;
for k = 1:4
    for j=k+1:k+2
        X(:,n)=sum(D(:,k:j),2); 
        n=n+1;
    end
end

u=zeros(8,1); 
v=zeros(8,1);
r=cell(8,1);

for k=1:8
     %figure(k)
    %[r{k} u(k)]=getthreshold8(X(:,k));
    [r{k} v(k)]=getthresholdGM(X(:,k));
end
%[sepindex,k]=min(u); %for version 8
[~,k]=max(v); % for GM



y=X(:,k);
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



