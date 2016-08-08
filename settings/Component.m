function Component(src,~,data_object,gui_object)
    % changes component in the filename

    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);

    data.component=get(src,'string');

    % getting correct file name (with index)
    tt=IndexSave(data);
    data.filename=tt;
    s=strsplit(tt,'\');
    s=s(end);
    
    % showing updated file name
    set(gui.TextFileName2,'string',s)
    
    % update data object
    guidata(data_object,data);
end