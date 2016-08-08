function AddComment(~,~,data_object,gui_object)
    % adds comment to the last saved file
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % load last saved file, update and save
    load(data.filename);
    mesdata.comments{end+1}=get(gui.EditComment,'string');
    save(data.filename,'mesdata');
end