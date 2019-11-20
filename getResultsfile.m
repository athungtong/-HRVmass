function  handles=getResultsfile(handles)

    % manage folder to save result
    handles.ResultsPath=handles.set.save.outPath;
    if ~isdir(handles.ResultsPath)
        mkdir(handles.ResultsPath)
    end 
    
    % manage file name to save result
    [~, handles.foutname]=fileparts(handles.EDFfullfile);
%     if ~strcmp(handles.set.save.fnameCHopt,'')
%         handles.foutname=[handles.foutname '_' handles.set.save.fnameCHopt];
%     end
    
    if ~strcmp(handles.set.save.fnameopt,'')
        handles.foutname=[handles.foutname '_' handles.set.save.fnameopt];
    end   
    
    % Save Results in .mat format 
    filename=fullfile(handles.ResultsPath,[handles.foutname '_HRVmass.mat']);
    
    fid=fopen(filename);
    if fid ~= -1
        fclose(fid); 
        handles=checkoverwrite(handles,filename);
        if ~handles.isoverwrite
            text=[filename ' was not processed'];
            fprintf(handles.logfid,'%s\r',text); 
        else
            delete(filename); 
        end  
    else
        handles.isoverwrite=1;
    end 
