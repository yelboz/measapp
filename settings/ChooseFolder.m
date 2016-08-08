function ChooseFolder(~,~,data_object,gui_object)
    % obtain save folder

    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % loading last used folder
    g=load(fullfile(data.sourcepath,'lastfolders.mat'));
    lastfolders=g.lastfolders;
    lastpath=lastfolders.savefolder;
    currdir=uigetdir(lastpath);

    % checks that a folder was chosen
    if currdir==0
        errordlg('no folder chosen');
        return
    else
        data.currentdirectory=currdir;
        lastfolders.savefolder=currdir;
        save(fullfile(data.sourcepath,'lastfolders.mat'),'lastfolders');
    end

    % showing updated folder/file
    set(gui.EditChooseFolder,'string',data.currentdirectory);

    % getting correct file name (with index)
    tt=IndexSave(data);
    s=strsplit(tt,'\');
    data.filename=tt;
    s=s(end);
    set(gui.TextFileName2,'string',s);
    
    % update data object
    guidata(data_object,data);
end