function DoubleTimeStepEdit(src,~,data_object,gui_object)
    % change the outer sweep time step

    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    tf=IsInputNumber(src,0);
    if tf
        timestep=get(src,'string');
        timestep=str2double(timestep);
        data.DoubleTimeStep=timestep;
    else
        data.DoubleTimeStep=1;
    end
    
    % update data object
    guidata(data_object,data);
end