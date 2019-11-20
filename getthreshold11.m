function [r vk]=getthreshold11(Xk,k)
% get threshold based on pdf of y
% The assumption is that y is composed of 2 data set which have different
% center and different pdf
% The algorighm try to locate a point along the density plot of y such that
% it divides density of y into 2 sub density
% The optimal point is the point such that pdf of y is minimal and the
% center from that point to the new pdf on the left is equal to that of the
% pdf on the right
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fs=360;
k1=5;
k2=10;
N = 10*360;
% width = 3.475;     % Width in inches half page of two column
alw = 0.75;    % AxesLineWidth
fsz = 8;      % Fontsize
% lw = 0.72;      % LineWidth
% msz = 6;       % MarkerSize

% axes(ha(1)),plot((1:N)/fs,raw(1:N),'k'); 
% box off; axis('tight'); 
% set(gca,'xticklabel','','FontSize', fsz, 'LineWidth', alw,'ylim',[-0.5 1],'ytick',[0,1]); 
% ylabel('(a)','Interpreter','LaTex','fontsize',fsz)
% 
% axes(ha(2)),plot((1:N)/fs,raw(1:N),'k'); 
% box off; axis('tight'); 
% set(gca,'xticklabel','','FontSize', fsz, 'LineWidth', alw,'ylim',[-0.5 1],'ytick',[0,1]); 
% set(gca,'yticklabel','','FontSize', fsz, 'LineWidth', alw,'ylim',[-0.5 1],'ytick',[0,1]); 
% 
% 
% if k==k1
%     axes(ha(3)),plot((1:N)/fs,Xk(1:N),'k'); 
%     box off; axis('tight'); 
%     set(gca,'xticklabel','','FontSize', fsz, 'LineWidth', alw,'ylim',[-0.7 .7],'ytick',[-0.5 0.5]); 
%     ylabel('(b)','Interpreter','LaTex','fontsize',fsz)
% elseif k==k2
%     axes(ha(4)),plot((1:N)/fs,Xk(1:N),'k'); 
%     set(gca,'xticklabel','','FontSize', fsz, 'LineWidth', alw,'ylim',[-0.7 .7],'ytick',[-0.5 0.5]); 
%     set(gca,'yticklabel','','FontSize', fsz, 'LineWidth', alw,'ylim',[-0.7 .7],'ytick',[-0.5 0.5]); 
%     box off; axis('tight');
% 
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    

Xk2 = Xk.^2;




minpeak=1; % number of peak away from R
j=getCandidatePeak(Xk2,minpeak);

% Remove index with too low or too high amplitude
% because these indices will alter the density
j(Xk2(j) < 0.001*median(Xk2(j))) = [];
j(Xk2(j) > 10000*median(Xk2(j))) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if k==k1
%     axes(ha(5)),plot((1:N)/fs,Xk2(1:N),'k'); hold on; plot(j(j<N)/fs,Xk2(j(j<N)),'.k'); hold off;
%     box off; axis('tight'); 
%     set(gca,'FontSize', fsz, 'LineWidth', alw,'ylim',[-.1 0.6],'ytick',[0,0.5]); 
%     ylabel('(c)','Interpreter','LaTex','fontsize',fsz)
%     xlabel('Time (s)','Interpreter','LaTex','fontsize',fsz)    
% 
% elseif k==k2
%     axes(ha(6)),plot((1:N)/fs,Xk2(1:N),'k'); hold on; plot(j(j<N)/fs,Xk2(j(j<N)),'.k'); hold off;
%     box off; axis('tight'); 
%     set(gca,'FontSize', fsz, 'LineWidth', alw,'ylim',[-.1 0.6],'ytick',[0,0.5]); 
%     xlabel('Time (s)','Interpreter','LaTex','fontsize',fsz)
%     set(gca,'yticklabel','')
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Yk = log(Xk2(j));
[fYk,y] = ksdensity( Yk );
fYk=smooth(fYk,3)'; 


% % Consider only fYk in 5-95 percentile
% temp=cumsum(fYk/sum(fYk));
% fYk(temp<0.05 | temp>0.95)=[];
% y(temp<0.05 | temp>0.95)=[];

% Find index of local minimum of Px
[jm jn]=localmaxmin(fYk);    
jn(1)=0; jn(end)=0; jn=find(jn);
jm(1)=0; jm(end)=0; jm=find(jm);
%select only local min in 5-95 percentile
candidate=[];
for n=1:length(jn)
    % 0.05 is adjusted for 208 MITDB don't change
    if sum(fYk(1:jn(n))/sum(fYk))>0.05 && sum(fYk(jn(n)+1:end)/sum(fYk))>0.05
        candidate =[candidate; n];
    end
end
jn=jn(candidate);




if length(jn)>=1 % at least one local min exist 
    
    d=zeros(length(jn),1);
    for i=1:length(jn) 
        fN = (fYk-min(fYk))/range(fYk);  %normalized fy in 0-1 range  
%         leftmode = max(fN(jm( jm<jn(i) )));  if isempty(leftmode), leftmode = max(fN(1:(jn(i)-1))); end
%         rightmode = max(fN(jm( jm>jn(i) )));  if isempty(rightmode), rightmode = max(fN((jn(i)+1):end)); end
        leftmode = fN(jm( jm<jn(i) ));  if isempty(leftmode), leftmode = max(fN(1:(jn(i)-1))); end
        leftmode=leftmode(end);
        rightmode = fN(jm( jm>jn(i) ));  if isempty(rightmode), rightmode = max(fN((jn(i)+1):end)); end
        rightmode=rightmode(1);
%         d(i) = fN(jn(i))* min(leftmode,rightmode);
        d(i) = max( fN(jn(i))/leftmode, fN(jn(i))/rightmode ); 
    end
    
    [vk indd] = min(d);        
    jstar = jn(indd);    
    alpha=y(jstar);        

    
else %no local min exist
    %search for inflection point
    dfy = diff(fYk)/(y(2)-y(1));
    [imax imin]=localmaxmin(dfy);

    imax(1)=0; imax(end)=0; imax=find(imax);
    imin(1)=0; imin(end)=0; imin=find(imin);
    jf =[imax';imin']'; % index of inflection point
    candidate=[];
    for n=1:length(jf)
        if sum(fYk(1:jf(n))/sum(fYk))>0.05 && sum(fYk(jf(n)+1:end)/sum(fYk))>0.05
            candidate =[candidate; n];
        end
    end
    jf=jf(candidate); %inflection point

   
    d = abs(dfy(jf));
    [vk indd]=min(d);
    vk=vk+100; 
    jstar = jf(indd);
    alpha=y(jstar);     
    
end

r = j( Yk>alpha );

return;
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if k==k1
%         axes(ha(7)),plot((1:N)/fs,Xk2(1:N),'k'); hold on; plot(r(r<N)/fs,Xk2(r(r<N)),'.r'); plot((1:N)/fs,ones(N,1)*exp(alpha),'r-');hold off;
%         box off; axis('tight'); 
%         set(gca,'FontSize', fsz, 'LineWidth', alw,'ylim',[-0.1 0.6],'ytick',[0,0.5]); 
%         ylabel('(d)','Interpreter','LaTex','fontsize',fsz)
%         xlabel('Time (s)','Interpreter','LaTex','fontsize',fsz)
%         %         box off; axis('tight'); set(gca,'FontSize', fsz, 'LineWidth', alw,'ylim',[-.1 0.4],'ytick',[0,0.5]); 
%     elseif k==k2
%         axes(ha(8)),plot((1:N)/fs,Xk2(1:N),'k'); hold on; plot(r(r<N)/fs,Xk2(r(r<N)),'.r'); plot((1:N)/fs,ones(N,1)*exp(alpha),'r-');hold off;
%         box off; axis('tight'); 
%         set(gca,'FontSize', fsz, 'LineWidth', alw,'ylim',[-0.1 0.6],'ytick',[0,0.5]); 
%         set(gca,'yticklabel','','FontSize', fsz, 'LineWidth', alw,'ylim',[-0.1 0.6],'ytick',[0,0.5]); 
%         xlabel('Time (s)','Interpreter','LaTex','fontsize',fsz)
%     end
%         set(gcf,'paperposition',[2.5 4 3.475,4.0]);
% %         print(gcf,'-depsc','-loose','samplesegmentPPT2');
% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
if k==k1
    axes(ha(1)),plot((1:N)/fs,Xk2(1:N),'c'); hold on; plot(j(j<N)/fs,Xk2(j(j<N)),'.k'); hold off;
    box off; axis('tight'); 
    set(gca,'FontSize', fsz, 'LineWidth', alw,'ylim',[-.1 0.6],'ytick',[0,0.5]); 
    set(gca,'xticklabel',''); 
  

elseif k==k2
    axes(ha(4)),plot((1:N)/fs,Xk2(1:N),'c'); hold on; plot(j(j<N)/fs,Xk2(j(j<N)),'.k'); hold off;
    box off; axis('tight'); 
    set(gca,'FontSize', fsz, 'LineWidth', alw,'ylim',[-0.02 0.12],'ytick',[0,0.1]); 
    xlabel('Time (s)','Interpreter','LaTex','fontsize',fsz)
end

if k==k1
    axes(ha(2)),plot((1:N)/fs,log(Xk2(1:N)),'c'); hold on; plot(j(j<N)/fs,log(Xk2(j(j<N))),'.k'); hold off;
    box off; axis('tight'); 
    set(gca,'FontSize', fsz, 'LineWidth', alw); ylim([-15 0])
    set(gca,'xticklabel','','FontSize', fsz, 'LineWidth', alw); 

elseif k==k2
    axes(ha(5)),plot((1:N)/fs,log(Xk2(1:N)),'c'); hold on; plot(j(j<N)/fs,log(Xk2(j(j<N))),'.k'); hold off;
    box off; axis('tight'); 
    set(gca,'FontSize', fsz, 'LineWidth', alw); ylim([-15 0])
    xlabel('Time (s)','Interpreter','LaTex','fontsize',fsz)

end



    if k==k1   

        axes(ha(3)),plot(fYk,y,'k'); hold on; plot(fYk(jstar),(y(jstar)),'*r'); hold off;
        box off; axis('tight'); 
        set(gca,'xticklabel','','FontSize', fsz, 'LineWidth', alw); ylim([-15 0])
        set(gca,'yticklabel','')
   elseif k==k2

        axes(ha(6)),plot(fYk,y,'k'); hold on; plot(fYk(jstar),(y(jstar)),'*r'); hold off;
        box off; axis('tight'); 
        set(gca,'xticklabel','','FontSize', fsz, 'LineWidth', alw); ylim([-15 0])
        set(gca,'yticklabel',''); 
        xlabel('Density','Interpreter','LaTex','fontsize',fsz)
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%



return;



% % Scrip to plot
plot(y,fYk);hold on;
plot([alpha alpha],[0 max(fYk)],'r'); hold off;

% plot(xi,Pxn,'.-');hold on;
% % plot(xi(indPx),Px(indPx),'ob'); 
% % plot(xi(inddPx),Pxn(inddPx),'ob'); 
% plot(xi,Dmx,'.-k');
% % plot(xi(ind),candidate,'.-g');
% % % plot(xi,fx,'.k');
% % % plot(xi(index),val,'*c');
% plot(xi(optindex),Pxn(optindex),'r*');
% % plot(xi(nxl),Px(nxl),'ro');
% % plot(xi(nxr),Px(nxr),'ro');
% % plot(xi(p25),Px(p25),'ro');
% % plot(xi(p75),Px(p75),'ro');
% % plot(xil,Pxl,'g');
% % plot(xir,Pxr,'b');
% % % plot(xi(1:end-1),5*diff(Px),'k');
% hold off; grid on;
% % % title( [num2str( varl ) '  ' num2str(varr)] );
% % % title( num2str( max(varl,varr)));
% % title( [num2str( nmin ) '  ' num2str(nimax)] );
% title( [num2str(score1) '  ' num2str(score2) '  ' num2str(score3)  '  ' num2str(fval)]);% input('con');
% % 
% % score1 = length(indPx)/10;  if score1==0, score1=100;end 
% % score2 = length(inddPx)/40; if length(inddPx)==2, score2=inf;end %for normal density, 2 inflection
% 
%     
% %do only indPx is not empty
% if ~isempty(indPx)
%     d=zeros(length(indPx),1);
%     for i=1:length(indPx) 
%         i1= indPxmax<indPx(i);
%         i2= indPxmax>indPx(i);
%         P1 = max(Pxn(indPxmax(i1)));
%         P2 = max(Pxn(indPxmax(i2)));
%         % To measure how the two density is sepharated, we measure percentage of overlaping
%         % by computing ratio between the Px at the local minimal and the Px
%         % at the local maximum of the best of the left and the right and
%         % take the biggest one.
%         d(i) = max( Pxn(indPx(i))/P1, Pxn(indPx(i))/P2 ); 
%     end
%     
%     d = d + Dmx(indPx);
%     [foverlap indd] = min(d);
%     optindex = indPx(indd);    
%     th=exp(xi(optindex));
%     index = indmax( x2(indmax)>th );
%     
%     fval=fcom+foverlap;
%     
% elseif length(inddPx)>2
%     [foverlap indd]=min(abs(dPx(inddPx)) + Dmx(inddPx)');
%     
%     optindex = inddPx(indd);
%     th=exp(xi(optindex));
%     index = indmax( x2(indmax)>th ); 
%     
%     fval=fcom+foverlap;
% else
%     fval=inf;        
%     index = [];
% end