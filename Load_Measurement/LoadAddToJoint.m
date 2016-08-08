function LoadAddToJoint( ~,~,data_object,gui_object)
    % adds plot to list of joint plot
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % get the plot data and update the table
    lineObj = findobj(gui.LoadViewAxes, 'type', 'line');
    xdata = get(lineObj, 'XData');
    ydata = get(lineObj, 'YData');
    gui.JoinData{gui.JointIndex}={xdata,ydata};
    gui.JointIndex=gui.JointIndex+1;
    list=get(gui.LoadJointTable,'rowname');
    a=strsplit(gui.loadfilestr,'\');
    newstr=a{end};
    list=[list;{newstr}];
    set(gui.LoadJointTable,'rowname',list);
    set(gui.LoadJointTable,'data',false(numel(list),1));
    
    % update data and gui objects
    guidata(data_object,data);
    guidata(gui_object,gui);
end