function [Xstar r]=getRindex(ECG,fs)
%perform wavelet decomposition using db5
% x is a vector
% minpeak is interger number


% Perform wavelet decomposition upto level N=7 using db7 wavelet

N=ceil(log2(fs/2)+1);
M=10;
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters('db7');
[C,L] = wavedec(ECG,N,Lo_D,Hi_D);

% Scrip to access index of cA and cD
% indexcA = [1 L(1)];
% indexcD = zeros(N,2);
% n=L(1);
% for i=1:N
%     cD{N-i+1} = C( n+1: n+L(i+1));
%     indexcD(N-i+1,:) = [n+1  n+L(i+1)];
%     n=n+L(i+1);
% end

% Select 10 combinations of Di for reconstruction process
D=zeros(length(ECG),N);
for k=1:N
    D(:,k)=wrcoef('d',C,L,Lo_R,Hi_R,k);
end

X=zeros(size(D,1),M);
n=1;
for k = 1:5
    for j=k+1:k+2
        X(:,n)=sum(D(:,k:j),2); 
        n=n+1;
    end
end


% Send each reconstruction signal Yi to the function getthreshold
% to check how candidate max are distribute, see if the distribution
% is from population with normal probability density function which results
% in best separation btw peak and ripple
u=zeros(M,1); 
v=zeros(M,1);
r=cell(M,1);
s=v;

% figure(1)
% width = 7.134; % width of both column
% width = 3.475; 
% height = 4.0;    % Height in inches
% 
% [ha, pos] = tight_subplot(5,2,[.04 .04],[.1 .01],[.13 .03]); % [left right],[buttom, above], [left right of all subplot]
% pos = get(gcf, 'Position');
% set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size

% figure(2)
% width = 7.134; % width of both column
% %width = 3.475; 
% height = 4.0;    % Height in inches
% 
% [ha, pos] = tight_subplot(3,2,[.04 .04],[.1 .01],[.13 .03]); % [left right],[buttom, above], [left right of all subplot]
% pos = get(gcf, 'Position');
% set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size

% figure(3)
% width = 7.134; % width of both column
% %width = 3.475; 
% height = 4.0;    % Height in inches
% 
% [ha, pos] = tight_subplot(2,3,[.04 .04],[.1 .01],[.13 .03]); % [left right],[buttom, above], [left right of all subplot]
% pos = get(gcf, 'Position');
% set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size



for k=1:M
      
    [r{k} u(k)]=getthreshold11(X(:,k),k);
     s(k) = mean( abs(diff( diff(r{k})) ) ); %This is the sum of derivative of rr interval. We expected this to be small     
end

s=(s-min(s))/range(s); 
u=(u-min(u))/range(u);
  
[~,k]=min(u+s); % for v9

Xstar=X(:,k);
r = r{k};

return;
input('like it?');

 


axes(ha(1)),plot(X(1:N,2),'k'); 
box off; axis('tight'); set(gca,'xticklabel','','yticklabel','','FontSize', fsz, 'LineWidth', alw,'ylim',[-1.2 1.2],'ytick',[-1,0,1]); 
axes(ha(2)),plot(X(1:N,4),'k'); 
box off; axis('tight'); set(gca,'xticklabel','','yticklabel','','FontSize', fsz, 'LineWidth', alw,'ylim',[-1.2 1.2],'ytick',[-1,0,1]); 
axes(ha(3)),plot(X(1:N,6),'k');
box off; axis('tight'); set(gca,'xticklabel','','yticklabel','','FontSize', fsz, 'LineWidth', alw,'ylim',[-1.2 1.2],'ytick',[-1,0,1]); 




return;
plot(X(:,k))
for k=1:M
    subplot(5,2,k)
    plot(X(:,k));
end
%subplot(4,1,4),plot(ECG);

input(':')