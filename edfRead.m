function [Data handles]=edfRead(FileName)
% function edfRead(FileName) read entire edf file 'FileName'. Data is cell
% containing each data set in column vector. handles is the info of the
% file

handles = edfInfo(FileName);
%preparing to load ECG data
fid=fopen(FileName,'r');

% % pre-allocation the variable
Data=[];
for i=1:handles.FileInfo.SignalNumbers
    Data{i}=zeros(handles.FileInfo.NumberDataRecord*handles.ChInfo.nr(i),1);
    w(i)=handles.ChInfo.nr(i);
end
numSkipHeaderByte=handles.FileInfo.HeaderNumBytes; %header byte
fseek(fid,numSkipHeaderByte,-1);
for i=1 : handles.FileInfo.NumberDataRecord
    for j=1:handles.FileInfo.SignalNumbers
        Data{j}(w(j)*(i-1)+(1:w(j)))=fread(fid,[w(j) 1],'int16');
    end
end

fclose(fid);

% scale the data to the physical dimension

for j=1:handles.FileInfo.SignalNumbers
Data{j} =(Data{j}-handles.ChInfo.DiMin(j))/(handles.ChInfo.DiMax(j)-handles.ChInfo.DiMin(j)) *...
    (handles.ChInfo.PhyMax(j)-handles.ChInfo.PhyMin(j))+handles.ChInfo.PhyMin(j);
end