function ThirdFinish(src,~,data,gui)
    % changes the starting point for the next rate in the magnet
    % settings
    
    tf=IsInputNumber(src,0);
    if tf
        set(gui.FourthStart,'String',get(src,'String'));
    else
        set(gui.ThirdFinish,'String',get(gui.FourthStart,'String'));
    end
end