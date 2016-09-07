function OpenCaenStop(data_object,gui_object,obj,n)
    %
    gui=guidata(gui_object);
    if  gui.CaenStopBool == 1
        return
    end
        gui.CaenStopWindow = figure( ...
        'Name', 'CAEN Big Red Stop', ...
        'NumberTitle', 'off', ...
        'MenuBar', 'none', ...
        'Toolbar', 'none', ...
        'Position', [500,50,200,200], ...
        'HandleVisibility', 'off');
    gui.CaenStopBool = 1;
    guidata(gui_object,gui);
    CaenStopLayout = uiextras.VBox( 'Parent', gui.CaenStopWindow, ...
        'Padding', 3, 'Spacing', 3 );
    uicontrol( 'Style', 'text', ...
        'BackgroundColor', [0.941,0.941,0.941], ...
        'Fontsize', 10,...
        'String', ['Push here to drop CAEN channel #',n,' to 0'], ...
        'Parent', CaenStopLayout );
    uicontrol( 'Style', 'PushButton', ...
        'Parent', CaenStopLayout, ...
        'BackgroundColor', [0.848,0.180,0.289], ...
        'FontWeight', 'bold', ...
        'Fontsize', 20, ...
        'String', 'STOP',...
        'Callback',{@CaenStop,gui,obj,n});

    set( CaenStopLayout, 'Sizes', [-1 -5] );

end