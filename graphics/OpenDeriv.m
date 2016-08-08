function OpenDeriv(~,~,data_object,gui_object)
    % open matlab figure with current plot's derivative

    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % opens new figure ,calculates derivative and displays it
    fig=figure;
    ax2=axes('Parent',fig);
    dataObjs = get(gui.ViewAxes1, 'Children');
    xdata = get(dataObjs, 'XData');
    ydata = get(dataObjs, 'YData');
    dx=xdata(end)-xdata(end-1);
    dydx_5=diff(smooth(ydata,5)/dx);
    plot(ax2,xdata(1:(end-1)),dydx_5,'')
end