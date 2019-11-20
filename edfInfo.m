function handles=edfInfo(FileName)

%http://www.edfplus.info/specs/edf.html

fid = fopen (FileName);

handles.FileInfo.Version = char(fread(fid,[1 8],'uint8'));

handles.FileInfo.LocalPatientID = char(fread(fid,[1 80],'uint8'));

handles.FileInfo.LocalRecordID = char(fread(fid,[1 80],'uint8'));

handles.FileInfo.StartDate = char(fread(fid,[1 8],'uint8'));

handles.FileInfo.StartTime = char(fread(fid,[1 8],'uint8'));

handles.FileInfo.HeaderNumBytes = str2num(char(fread(fid,[1 8],'uint8'))); %number of all header

handles.FileInfo.Reserved = char(fread(fid,[1 44],'uint8'));

handles.FileInfo.NumberDataRecord = str2num(char(fread(fid,[1 8],'uint8'))); %number of blocks, each block last DataRecordDuration second

handles.FileInfo.DataRecordDuration = str2num(char(fread(fid,[1 8],'uint8'))); %length of each block, in second

handles.FileInfo.SignalNumbers = str2num(char(fread(fid,[1 4],'uint8'))); %number of signals, or channels

ns = handles.FileInfo.SignalNumbers;

handles.ChInfo.Labels = char(fread(fid,[16 ns],'uint8')'); %name of channels

handles.ChInfo.TransType = char(fread(fid,[80 ns],'uint8')');

handles.ChInfo.PhyDim = char(fread(fid,[8 ns],'uint8')');

handles.ChInfo.PhyMin = str2num(char(fread(fid,[8 ns],'uint8')'));

handles.ChInfo.PhyMax = str2num(char(fread(fid,[8 ns],'uint8')'));

handles.ChInfo.DiMin = str2num(char(fread(fid,[8 ns],'uint8')'));

handles.ChInfo.DiMax = str2num(char(fread(fid,[8 ns],'uint8')'));

handles.ChInfo.PreFiltering = char(fread(fid,[80 ns],'uint8')');

handles.ChInfo.nr  = str2num(char(fread(fid,[8 ns],'uint8')')); 
%number of sample in each data record
%if duration is 0.5 and number of sample is 100, then the sampling rate is
%200

handles.ChInfo.Reserved = char(fread(fid,[32 ns],'uint8')');

fclose(fid);