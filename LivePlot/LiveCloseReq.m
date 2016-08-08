function LiveCloseReq( src, ~ ,data_object)
    % close live plot
    
    % get structs from objects
    data=guidata(data_object);
    
    % update list of live plots
    data.liveplots=data.liveplots(data.liveplots~=get(src,'UserData'));
    
    % update data obhect and delete figure
    guidata(data_object,data);
    delete(src);
end