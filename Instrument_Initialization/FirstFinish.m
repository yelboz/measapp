function FirstFinish(src,~,data,gui)
    % changes the starting point for the next rate in the magnet
    % settings
    
    tf=IsInputNumber(src,0);
    if tf
        set(gui.SecondStart,'String',get(src,'String'));
    else
        set(gui.FirstFinish,'String',get(gui.SecondStart,'String'));
    end
end