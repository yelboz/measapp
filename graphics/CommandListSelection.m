function CommandListSelection(src,~,data_object,gui_object)
    % diplayes the selected command from dropdown list

    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    command = get( src, 'string');
    value= get( src, 'value');
    set(gui.EditCommand,'string',command{value});
end