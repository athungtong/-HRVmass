function handles=checkoverwrite(handles,filename)
%%
    [selectedButton handles.dlgshown] = uigetpref(...
        'savefile',...             % Group
        'isoverwite',...           % Preference
        'Overwrite?',...                    % Window title
        {'Same file name already exists'
         ''
         'Do you want to replace it?'
         ''
         filename},...
        {'Overwrite','Do not overwrite'},...        % Values and button strings
         'ExtraOptions','Stop',...             % Additional button
         'DefaultButton','Stop',...             % Default choice
         'CheckboxString','Do not show this dialog again');           
%%
    switch selectedButton
        case 'overwrite'  % Open a Save dialog (without testing if saved before)
            handles.isoverwrite=1;
            handles.canceled=0;
        case 'do not overwrite'                % Close the figure without saving it
           handles.isoverwrite=0;
           handles.canceled=0;
        case 'stop'               % Do not close the figure
           handles.isoverwrite=0;
           handles.canceled=1;
    end
