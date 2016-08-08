function Refresh(~,~,data_object,gui_object)
    % initializes flags and closes instruments
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % set flags and updatae data object
    data.CommandOk{1}=1;
    data.CommandOk{2}=-1;
    data.recordflag=0;
    data.batchflag=0;
    data.runningmeas=0;
    data.StopNow=0;
    
    guidata(data_object,data);
    
    % start command timer if it was stopped
    tr=get(data.CommandTimer,'Running');
    if strcmp(tr,'off')
        start(data.CommandTimer);
    end
    
    % close instruments and set buttons
    EndRun(data_object,gui_object);
end