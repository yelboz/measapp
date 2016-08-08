function LittlePlot(Axes,Title,X,Y,xlab,ylab,lineprop)
    % plots X-Y on Axes, with a title,labels and line properties
    
    if length(lineprop)>1
        plot(Axes,X,Y,lineprop{:});
    else
        plot(Axes,X,Y,lineprop);
    end
    title(Axes,Title,'fontsize',14);
    xlim(Axes,'auto');
    xlabel(Axes,xlab,'fontsize',12);
    ylim(Axes,'auto');
    ylabel(Axes,ylab,'fontsize',12);
end