function [x trend]=detrendECG(x)
% detrend the ecg
[c1,l1] = wavedec(x,8,'db7');
trend=wrcoef('a',c1,l1,'db7',8);
x=x-trend;


% h=fdesign.highpass('Fst,Fp,Ast,Ap',0.01,0.02,60,1);
% 
% % h=fdesign.highpass('Fp,Fst,Ap,Ast',0.05,0.2,1,60);
% d=design(h,'equiripple'); %Lowpass FIR filte
% x = filtfilt(d.Numerator,1,x); %zero-phase filtering
