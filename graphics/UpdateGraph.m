function UpdateGraph(data,gui,meida)
    % updates all live figures according to axes choice and new data
    
    % loop on all open figures
    for i=data.liveplots
        
        % get axis handle
        ax=gui.(['ViewAxes',num2str(i)]);
        
        if ishandle(ax)
            
            % get relevant info and update the plot
            xlist=gui.(['ListChooseX',num2str(i)]);
            ylist=gui.(['ListChooseY',num2str(i)]);
            cla(ax);
            witchx=get(xlist,'Value');
            witchy=get(ylist,'Value');
            s=size(meida);
            
            % if present value is bigger then number of options then equals
            % 1
            if (witchx>s(2))||(witchy>s(2))
                set(xlist,'Value',1);
                set(ylist,'Value',1);
            end
            xlab=GetStrFromPop(xlist);
            ylab=GetStrFromPop(ylist);
            
            % plot with specifications
            LittlePlot(ax,[ylab,' VS. ',xlab],meida(:,witchx),meida(:,witchy),xlab,ylab,'');
        end
    end
end