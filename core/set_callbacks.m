function set_callbacks(data_object,gui_object)
    % set various callback
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % set callbacks wiht data and gui objects as input
    set(data.CommandTimer,'TimerFcn', {@CommandTimerCallback,data_object,gui_object});
    set(data.MainTimer,'TimerFcn', {@MainTimerCallback,data_object,gui_object});
    set(gui.Window,'CloseRequestFcn',{@CloseReq,data_object,gui_object});
    uimenu( gui.FileMenu, 'Label', 'Load Measurement', 'Callback', {@LoadMeasurementMenu,data_object,gui_object} );
    uimenu( gui.FileMenu, 'Label', 'Load Batch', 'Callback', {@BatchLoad,data_object,gui_object});
    gui.RunBatchMenuItem=uimenu( gui.FileMenu, 'Label', 'Run Batch','Enable','off','Callback', {@RunBatch,data_object,gui_object} );
    
    % update gui object
    guidata(gui_object,gui)
    
    set(gui.ShowInstrumentsButton,'Callback', {@InstrumentSelectMenu,data_object,gui_object});
    set(gui.RefreshButton,'Callback', {@Refresh,data_object,gui_object});
    set(gui.EditMeasure,'Callback', {@MeasureList,data_object,gui_object});
    set(gui.EditTimeStep,'Callback', {@TimeStepEdit,data_object,gui_object});
    set(gui.EditDoubleTimeStep,'Callback', {@DoubleTimeStepEdit,data_object,gui_object});
    set(gui.ListDoubleSweepMode,'Callback', {@DoubleSweepMode,data_object,gui_object});
    set(gui.ChooseFolder,'Callback', {@ChooseFolder,data_object,gui_object});
    set(gui.EditComponent,'Callback', {@Component,data_object,gui_object});
    set(gui.AddComment,'Callback', {@AddComment,data_object,gui_object});
    set(gui.ListCommand,'Callback', {@CommandListSelection,data_object,gui_object});
    set(gui.CheckContinue,'CallBack', {@CheckContinueCallback,data_object,gui_object});
    set(gui.GoButton,'Callback', {@GoButtonCallback,data_object,gui_object});
    set(gui.StopButton,'Callback', {@StopNow,data_object,gui_object});
    set(gui.AddLivePlotButton,'Callback', {@AddLivePlot,data_object,gui_object});
    set(gui.ListChooseX1,'Callback', {@XAxisChange,data_object,gui_object});
    set(gui.ListChooseY1,'Callback', {@YAxisChange,data_object,gui_object});
    uimenu(gui.graphmenu,'Label','open in figure','Callback',{@OpenFigure,data_object,gui_object});
    uimenu(gui.graphmenu,'Label','open derivative in figure','Callback',{@OpenDeriv,data_object,gui_object});
    
    
    %Keyboard Shortcuts
    
    
end