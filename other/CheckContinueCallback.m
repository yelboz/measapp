function CheckContinueCallback(src,~,data_object,gui_object)
    % checks if measurement can be continued
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % make action according to selection
    check=get(src,'Value');
    switch check
        case 1
            
            % checks if continuation is possible
            can=CanContinueMeasurement(data);
            
            % display measurement name
            if can
                
                % display last filename
                s=strsplit(data.filename,'\');
                s=s(end);
                set(gui.TextFileName2,'String',s);
                helpdlg(['Measurement will be added to last file!';...
                    'make sure you do the same sweep/record!'],'Notice!');
                set(gui.EditMeasure,'Enable','off');
            else
                
                % display next file to be saved
                set(src,'Value',0);
                tt=IndexSave(data,gui);
                s=strsplit(tt,'\');
                s=s(end);
                set(gui.TextFileName2,'String',s);
            end
        case 0
            tt=IndexSave(data,gui);
            s=strsplit(tt,'\');
            s=s(end);
            set(gui.TextFileName2,'String',s);
            set(gui.EditMeasure,'Enable','on');
    end
    
    % update data object
    guidata(data_object,data);
end