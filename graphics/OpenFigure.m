function OpenFigure(~,~,data_object,gui_object)
    % open matlab figure with current plot
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % open new figure and copies graph
    fig=figure;
    ax2=axes('Parent',fig);
    copyobj(allchild(gui.ViewAxes1),ax2);
end