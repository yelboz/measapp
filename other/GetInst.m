function obj=GetInst(data,gui,Instname)
    % gives back matlab instrument object from name
    obj='';
    
    % comparing with names from the instrument list
    for i=1:length(data.Instruments)
        if strcmp(Instname,data.Instruments{i}{1})
            obj=data.(Instname);
        end
    end
end