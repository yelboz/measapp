function GoButtonCallback(~,~,data_object,gui_object)
    % callback for running a command
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % update flag and data object
    data.StopNow=0;
    data.CommandOk{2}=strtrim(get(gui.EditCommand, 'string' ));
    guidata(data_object,data);
end