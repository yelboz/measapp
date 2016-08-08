function LoadMeasurement(~,~,data_object,gui_object)
    % load ameasurement to observe
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % load last used path
    g=load(fullfile(data.sourcepath,'lastfolders.mat'));
    lastfolders=g.lastfolders;
    lastpath=lastfolders.loadfolder;
    
    % choose file and save new path
    [FileName,PathName]=uigetfile(fullfile(lastpath,'*.mat'));
    if FileName==0
        errordlg('no file chosen');
        return
    end
    lastfolders.loadfolder=PathName;
    save(fullfile(data.sourcepath,'lastfolders.mat'),'lastfolders');

    % load data file
    gui.loadfilestr=strcat(PathName,FileName);
    m=load(gui.loadfilestr);
    dataversion=m.mesdata.data_version;
    date=m.mesdata.measurement_time;
    sweeped=m.mesdata.sweeped;
    measured=m.mesdata.measured;
    comments=m.mesdata.comments;
    gui.dataload=m.mesdata.data;
    
    % load data to matlab workspace
    assignin('base','data',gui.dataload);
    
    % set buttons
    sizes=[sweeped,measured];

    set(gui.LoadFileText,'String',gui.loadfilestr);
    set(gui.LoadDataVersion,'String',dataversion);
    set(gui.LoadDate,'String',date);
    set(gui.LoadComments,'String',comments);
    set(gui.LoadListChooseX,'String',sizes);
    set(gui.LoadListChooseY,'String',sizes);
    set(gui.LoadListChooseX,'Value',1);
    set(gui.LoadListChooseY,'Value',1);
    
    % update data and gui objects
    guidata(data_object,data);
    guidata(gui_object,gui);
    
    % update the plot
    LoadUpdateGraph(0,0,data_object,gui_object);
end