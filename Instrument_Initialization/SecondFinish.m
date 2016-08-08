function SecondFinish(src,~,data,gui)
    % changes the starting point for the next rate in the magnet
    % settings
    
    tf=IsInputNumber(src,0);
    if tf
        set(gui.ThirdStart,'String',get(src,'String'));
    else
        set(gui.SecondFinish,'String',get(gui.ThirdStart,'String'));
    end
end