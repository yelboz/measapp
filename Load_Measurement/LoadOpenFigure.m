function LoadOpenFigure(~,~,gui)
    % opens new figure and copies graph
    
    fig=figure;
    ax2=axes('Parent',fig);
    copyobj(allchild(gui.LoadViewAxes),ax2);
end