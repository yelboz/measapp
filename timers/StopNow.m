function StopNow(~,~,data_object,gui_object)
    % activates the stop flag
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % update flags and data object
    data.StopNow=1;
    data.batchflag=0;
    data.mflag{1}=0;
    data.time{3}=-1;
    data.recordflag=0;
    data.runningmeas=0;
    guidata(data_object,data);
end