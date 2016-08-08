function YAxisChange(~,~,data_object,gui_object)
    % update plots according to axis change

    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);

    m=load(data.filename);
    UpdateGraph(data,gui,m.mesdata.data);
end