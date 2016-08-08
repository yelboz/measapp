function FourthFinish(src,~,data,gui)
    % changes the starting point for the next rate in the magnet
    % settings
    
    tf=IsInputNumber(src,0);
    if tf
        set(gui.FifthStart,'String',get(src,'String'));
    else
        set(gui.FourthFinish,'String',get(gui.FifthStart,'String'));
    end
end