function RunBatch( ~,~,data_object,gui_object)
    % runs the batch file

    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % update the flag and data object
    if isfield(data,'batchpath')
        data.fid=fopen(data.batchpath);
        data.batchflag=1;
        data.CommandOk{1}= 1;
        data.StopNow=0;
    else
        errordlg('no file loaded');
        return
    end
    %%%%% magnet debugging
    data.bigevilcounter=0;
    %%%%%
    
    guidata(data_object,data);
end