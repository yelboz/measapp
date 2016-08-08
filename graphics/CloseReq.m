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
            delete(src);
        case 'no'
    end
end