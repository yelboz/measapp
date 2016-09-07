function MeasApp()
    % create global structures.
    % gui holds graphic objects, data holds instruments and parameters
    % gui and data are transferred between functions as objects (data_object,gui_object)
    
    % run from core folder and add relevant functions to path
    parentpath = cd(cd('..'));
    addpath(genpath(parentpath));
    
    % create data and gui structs and objects
    data_object=figure('Visible','Off');
    data = CreateData();
    guidata(data_object,data);
    gui_object=figure('Visible','Off');
    gui = CreateInterface(data_object);
    guidata(gui_object,gui);
    
    % set various callbacks
    set_callbacks(data_object,gui_object);

    % starts the timer
    start(data.CommandTimer);
     
end