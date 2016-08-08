function DoubleSweepMode(src,~,data_object,gui_object)
    % sets the way the loop runs on measurement vector
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    data.DoubleSweepMode=get(src,'value');
    
    % update data object
    guidata(data_object,data);
end