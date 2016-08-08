function str=GetStrFromPop(popup)
    % gives the current string of a popup
    
    s=get(popup,'string');
    v=get(popup,'value');
    str=s{v};
end