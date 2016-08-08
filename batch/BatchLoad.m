function BatchLoad( ~,~,data_object,gui_object)
    % loads the batch file

    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % load from last used path
    g=load(fullfile(data.sourcepath,'lastfolders.mat'));
    lastfolders=g.lastfolders;
    lastpath=lastfolders.batchfolder;
    [FileName,PathName]=uigetfile(fullfile(lastpath,'*.txt'));
    if FileName==0
        errordlg('no file chosen');
        return
    end
    
    % update last used path
    lastfolders.batchfolder=PathName;
    save(fullfile(data.sourcepath,'lastfolders.mat'),'lastfolders');
    
    % check if batch is legal
    filestr=strcat(PathName,FileName);
    [boolbatch,nl]=CheckBatch(filestr);
    if boolbatch
        
        % allow to run batch file and make it pop up
        data.batchpath=filestr;
        set(gui.RunBatchMenuItem,'Enable','on');
        winopen(filestr)
        msgbox('Batch file is legal to run!','Batch');
    else
        
        % announce error with location
        set(gui.RunBatchMenuItem,'Enable','off');
        system(['start ',filestr])
        errordlg(['problem in batch file - line number: ',num2str(nl)]);
    end
    
    % update data object
    guidata(data_object,data);
end