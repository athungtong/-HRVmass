function handles=loadRfile(handles)

    % load R time from any txt or xls file 
    if strcmp(xlsfinfo(handles.EDFfullfile),'Microsoft Excel Spreadsheet')
        if ismac
            errdlg('Cannot import excel file in mac machine');
            handles.R_time=[];
            return;
        end
        handles.R_time=xlsread(handles.EDFfullfile);
    else        
        temp = importdata(handles.EDFfullfile);
        if isstruct(temp) % if file contain header
            handles.R_time=temp.data;
        else
            handles.R_time=temp;
        end
    end
    
    %check if data is numeric array
    if ~isnumeric(handles.R_time) || ~isvector(handles.R_time) || isscalar(handles.R_time)
        errordlg({['Error loading file ' handles.EDFfullfile],'R time must be a row or column vector of number.'},'Incompattible data format!');
        handles.R_time=[];
        return;
    end
        
    % check if time data is increasing
    if sum(diff(handles.R_time)<0)>0
        errordlg({['Error loading file ' handles.EDFfullfile],'R time values must be monotonically increasing'},'Incompattible data format!');
        handles.R_time=[];
        return;
    end
    
    %transpost to be a column vector if needed
    if size(handles.R_time,1)<size(handles.R_time,2),handles.R_time=handles.R_time';end
