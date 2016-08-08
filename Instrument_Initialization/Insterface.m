function Insterface(src,~,data,gui)
    % changes interface according to chosen instrument
    
    % get list of connected instruments indices
    all_inst=1:length(data.Instruments);
    connected_inst=all_inst(data.Connected==1);
    
    v=get(src,'value');
    if ~isempty(connected_inst)
        set(gui.InterfaceDescriptionText,'string',data.Instruments{connected_inst(v)}{2});
        set(gui.AdressDescriptionText,'string',data.Instruments{connected_inst(v)}{3});
        set(gui.DeviceMeasureList,'string',data.Instruments{connected_inst(v)}{4});
        set(gui.DeviceSweepList,'string',data.Instruments{connected_inst(v)}{5});
    end
end