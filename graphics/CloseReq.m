function CloseReq( src,~,data_object,gui_object)
    % closes application
    
    % get structs from objects
    
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % Construct a questdlg with three options
    choice = questdlg('Are you sure you want to exit', ...
        'Quit', ...
        'yes','no','no');
    
    % Handle response
    switch choice
        
        % case of yes - delete timers, close instruments and application
        case 'yes'
            stop([data.CommandTimer,data.MainTimer]);
            delete([data.CommandTimer,data.MainTimer]);
            EndRun(data_object,gui_object);
            
            % Close duck (EndRun won't be able to do it)
            all=1:length(data.Instruments);
            if any(data.Connected)
                for i=all(data.Connected==1)
                    obj=GetInst(data,gui,data.Instruments{i}{1});
                    if strcmp(data.Instruments{i}{1},'duck')
                        fclose(obj);
                    end
                end
            end
            %Remove Duck Global Vars
            %global bool is_duck_running_AC;
            %global bool did_duck_fopen;
            clearvars -global did_duck_fopen is_duck_running_AC;
    
            
            delete(src);
        case 'no'
    end
end