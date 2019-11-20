 
function saveResults(foutname,Results)

    % Save .mat file
    filename=[foutname '_HRVmass.mat'];    
    save(filename,'Results');
    if Results.set.save.savexls
        savexls(foutname,Results);
    end
    
    if Results.set.save.savetxt
        savetxt(foutname,Results);
    end

end

function savetxt(foutname,Results)
    % Save Results in .xls format    
    filename=[foutname '_HRVmass.txt'];

    %This will always replace existing file
    fid=fopen(filename,'w');

    % Save basic info
    YN = [{'NO'},{'Yes'}];
    fprintf(fid,'%s\t','Filename'); fprintf(fid,'%s\r\n',Results.rawfilename);
    if strcmp(Results.set.ifileopt,'ECG')==1
%         fprintf(fid,'%s\t','Sampling frequency'); fprintf(fid,'%s\r\n',num2str(Results.fileinfo.samplingfreq));
        fprintf(fid,'%s\t','ECG channel'); fprintf(fid,'%s\r\n',Results.set.ecgch.chnum);

        fprintf(fid,'%s\t','Detrended'); fprintf(fid,'%s\r\n',YN{Results.param.filter.detrend+1});
        fprintf(fid,'%s\t','Notch filter (Hz)'); 
        if ~isempty(Results.param.filter.notch)
            fprintf(fid,'%s\r\n',num2str(Results.param.filter.notch));
        else
            fprintf(fid,'%s\r\n','off');
        end
                
        fprintf(fid,'%s\t','High pass filter-low cut off (Hz)'); 
        if ~isempty(Results.param.filter.highpass)
               fprintf(fid,'%s\r\n',num2str(Results.param.filter.highpass));
        else
            fprintf(fid,'%s\r\n','off');
        end
        
        fprintf(fid,'%s\t','Low pass filter-high cut off (Hz)'); 
        if ~isempty(Results.param.filter.lowpass)
            fprintf(fid,'%s\r\n',num2str(Results.param.filter.lowpass)); 
        else
            fprintf(fid,'%s\r\n','off');
        end        
    end
    
    fprintf(fid,'%s\t','Epoch length (minute)'); fprintf(fid,'%s\r\n',num2str(Results.param.hrv.epochsize));
    fprintf(fid,'%s\t','Exclude abnormal beats'); fprintf(fid,'%s\r\n',YN{Results.set.preprocess.artifact+1});
    if Results.set.preprocess.artifact   
        fprintf(fid,'%s\t','maxHR (beat/min)'); fprintf(fid,'%s\r\n',num2str(Results.param.preprocess.maxhr));
        fprintf(fid,'%s\t','minHR (beat/min)'); fprintf(fid,'%s\r\n',num2str(Results.param.preprocess.minhr));
        fprintf(fid,'%s\t','maxdHR (beat/min)'); fprintf(fid,'%s\r\n',num2str(Results.param.preprocess.maxdhr));
    end
    fprintf(fid,'%s\t','Delay for Poincare (sample)'); fprintf(fid,'%s\r\n',num2str(Results.param.hrv.pctau));

    lowF = ['[' num2str(Results.param.hrv.lowerLF) '  ' num2str(Results.param.hrv.higherLF) ']'];
    highF = ['[' num2str(Results.param.hrv.lowerHF) '  ' num2str(Results.param.hrv.higherHF) ']'];
    
    fprintf(fid,'%s\t','Lomb low frequency range  (Hz)'); fprintf(fid,'%s\r\n',lowF);
    fprintf(fid,'%s\t','Lomb high frequency range (Hz)'); fprintf(fid,'%s\r\n',highF);
       
    % Save HRV
    fprintf(fid,'\r\n');
    fprintf(fid,'%s\t','Time (min)');
    for i=1:size(Results.hrv.Labels,2)
        fprintf(fid,'%s\t',Results.hrv.Labels{i});
    end
    fprintf(fid,'\r\n');
    fprintmatrix(fid,[Results.hrv.time/60 Results.hrv.Value]);
    
    % Save RR time and RR interval
    fprintf(fid,'\r\n');
    fprintf(fid,'%s\t','R_time (s)');
    fprintf(fid,'%s\r\n','RR_interval (s)');
    fprintmatrix(fid,[Results.RRinfo.R_time Results.RRinfo.RR_interval]);
    
    
%     dlmwrite(filename,[Results.hrv.time/60 Results.hrv.Value...
%         Results.RRinfo.R_time(1:size(Results.hrv.Value,1)) Results.RRinfo.RR_interval(1:size(Results.hrv.Value,1))],...
%         '-append','delimiter',  '\t','coffset',2,'precision', 6);
%     
%     dlmwrite(filename,[Results.RRinfo.R_time(size(Results.hrv.Value,1)+1:end) Results.RRinfo.RR_interval(size(Results.hrv.Value,1)+1:end)],...
%         '-append','delimiter',  '\t','coffset',size(Results.hrv.Labels,2)+3,'precision', 6);
   
        
    fclose(fid);
end

function savexls(foutname,Results)
    % Save Results in .xls format    
    filename=[foutname '_HRVmass.xls'];

    %replace existing file (if found)
    fid=fopen(filename);
    if fid ~= -1, fclose(fid); delete(filename); end   
    
    [state msg]=xlswrite(filename,{'Time (min)'},1,'A1');  
    if state==0
        errordlg(msg.message,'Save file error','replace');
        return;
    end
    if isempty(Results.hrv.time)
        txt={''};
    else
        txt = num2cell(Results.hrv.time/60);
    end
    xlswrite(filename,txt,1,'A2');            
    xlswrite(filename,Results.hrv.Labels,1,'B1'); 
    if isempty(Results.hrv.Value)
            txt={''};
    else
        txt = num2cell(Results.hrv.Value);
    end    
    xlswrite(filename,txt,1,'B2');            
   
    xlswrite(filename,{'R_time (s)'},2,'A1'); 
    if isempty(Results.RRinfo.R_time)
        txt={''};
    else
        txt = num2cell(Results.RRinfo.R_time);
    end    
    xlswrite(filename,txt,2,'A2');  
                
    xlswrite(filename,{'RR_interval (s)'},2,'B1');    
    if isempty(Results.RRinfo.RR_interval)
        txt={''};
    else
        txt = num2cell(Results.RRinfo.RR_interval);
    end 
    xlswrite(filename,txt,2,'B2');            
            
    YN = [{'NO'},{'Yes'}];
    basicinfo = {'Filename', Results.rawfilename};
    xlswrite(filename,basicinfo,3,'A1');
    if strcmp(Results.set.ifileopt,'ECG')==1
        filterinfo={'Sampling frequency',num2str(Results.fileinfo.samplingfreq);...
               'ECG channel',Results.set.ecgch.chnum;...
               'Detrended',YN{Results.param.filter.detrend+1};...
               'Notch filter (Hz)','off';...
               'High pass filter-low cut off (Hz)','off';...
               'Low pass filter-high cut off (Hz)','off'};
        xlswrite(filename,filterinfo,3,'A2');       
        if ~isempty(Results.param.filter.notch)
            xlswrite(filename,{num2str(Results.param.filter.notch)},3,'B5');
        end
        
        if ~isempty(Results.param.filter.highpass)
               xlswrite(filename,{num2str(Results.param.filter.highpass)},3,'B6');
        end
        
        if ~isempty(Results.param.filter.lowpass)
            xlswrite(filename,{num2str(Results.param.filter.lowpass)},3,'B7'); 
        end 
    end    
           
    parameter ={'Epoch length (min)',num2str(Results.param.hrv.epochsize);...
                'Exclude abnormal beats',YN{Results.set.preprocess.artifact+1}};
    xlswrite(filename,parameter,3,'A8');
    if Results.set.preprocess.artifact
        hrinfo = {'maxHR (beat/min)',num2str(Results.param.preprocess.maxhr);...
                'minHR (beat/min)',num2str(Results.param.preprocess.minhr);...
                'maxdHR (beat/min)',num2str(Results.param.preprocess.maxdhr)};
        xlswrite(filename,hrinfo,3,'A10');
    end
                
    lowF = ['[' num2str(Results.param.hrv.lowerLF) '  ' num2str(Results.param.hrv.higherLF) ']'];
    highF = ['[' num2str(Results.param.hrv.lowerHF) '  ' num2str(Results.param.hrv.higherHF) ']'];

    
    parameter={'Delay for Poincare (sample)',num2str(Results.param.hrv.pctau);...               
                'Lomb low frequency range  (Hz)',lowF;...
                'Lomb high frequency range (Hz)',highF};
            
    xlswrite(filename,parameter,3,'A13');
end