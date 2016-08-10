function EndRun(data_object,gui_object)
    % closes instruments and returns buttons
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % close instruments
    all=1:length(data.Instruments);
    if any(data.Connected)
        for i=all(data.Connected==1)
            obj=GetInst(data,gui,data.Instruments{i}{1});
            status=get(obj,'status');
            disp(data.SweepedNames)
            if strcmp(data.Instruments{i}{1},'duck')
                if regexp(data.MeasuredNames{1}, 'ADC')
                    fclose(obj);
                end
            elseif strcmp(status,'open')
                fclose(obj);
            end
        end
    end
    
    % adjust buttons
    set(gui.ShowInstrumentsButton,'Enable','on');
    set(gui.EditMeasure,'Enable','on');
    set(gui.GoButton,'Enable','on');
    set(gui.CheckContinue,'value',0)
    
    set(gui.TextFileName1,'FontSize',10);
    set(gui.TextFileName1,'ForegroundColor','black');
    set(gui.TextFileName1,'string','will save to: ');
    tt=IndexSave(data,gui);
    s=strsplit(tt,'\');
    s=s(end);
    set(gui.TextFileName2,'string',s)
    
    % update flag and data object
    data.StopNow=0;
    data.CommandOk{1}=1;
    data.runningmeas=0;
    guidata(data_object,data);
end