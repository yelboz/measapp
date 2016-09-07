function CaenStop(~,~,gui,obj,n)
    %CAENSTOP shuts down channel n
    
    query(obj,['$BD:0,CMD:SET,CH:',n,',PAR:VSET,VAL:0']);
    delete(gui.CaenStopWindow)
    gui.CaenStopBool = 0;
    guidata(gui_object,gui);
    
end