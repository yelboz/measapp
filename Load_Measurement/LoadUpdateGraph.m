function LoadUpdateGraph(~,~,data_object,gui_object)
    % updates the load menu graph
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % updates graph according to axes choice and new data
    cla(gui.LoadViewAxes);
    witchx=get(gui.LoadListChooseX,'Value');
    witchy=get(gui.LoadListChooseY,'Value');
    meida=gui.dataload;
    s=size(meida);
    if (witchx>s(2))||(witchy>s(2))
        set(gui.LoadListChooseX,'Value',1);
        set(gui.LoadListChooseY,'Value',1);
    end
    xlab=GetStrFromPop(gui.LoadListChooseX);
    ylab=GetStrFromPop(gui.LoadListChooseY);
    LittlePlot(gui.LoadViewAxes,[ylab,' VS. ',xlab],meida(:,witchx),meida(:,witchy),xlab,ylab,'');
end