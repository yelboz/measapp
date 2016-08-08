function LoadOpenJointFigure(~,~,data_object,gui_object)
    % opens figure and plots all selected lines

    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % plot the checked lines
    checks=get(gui.LoadJointTable,'data');
    % changing colors
    color=hsv(sum(checks));
    fig=figure;
    ax=axes('Parent',fig);
    ci=1;
    xlab=GetStrFromPop(gui.LoadListChooseX);
    ylab=GetStrFromPop(gui.LoadListChooseY);
    for i=2:length(checks)
        if checks(i)
            LittlePlot(ax,[ylab,' VS. ',xlab],gui.JoinData{i-1}{1},gui.JoinData{i-1}{2},xlab,ylab,{'','color',color(ci,:)});
            ci=ci+1;
            hold on
        end
    end
end