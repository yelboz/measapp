function CommandTimerCallback(src,~,data_object,gui_object)
    % runs the command if all terms are met, checks every 3 seconds
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % try is here for catching error location
    try
        
        % check command flag and if STOP was pressed
        if (data.CommandOk{1})&&(~data.StopNow)
            
            % check if batch is run
            if data.batchflag
                data.CommandOk{2}=fgets(data.fid);
                
                % check if end of batch file
                if data.CommandOk{2}==-1
                    msgbox('end of batch!','Notice');
                    fclose(data.fid);
                    
                    % update flag and data objcet
                    data.batchflag=0;
                    data.CommandOk{1}= -1;
                    guidata(data_object,data);
                end
            end
            if ischar(data.CommandOk{2})
                if ~isempty(strtrim(data.CommandOk{2}))
                    
                    % check if command is legal
                    if ~IsCommandGood(data.CommandOk{2})
                        warndlg('Not a legal command!','Error!');
                        % update flag
                        data.CommandOk{2}=-1;

                        % update data object
                        guidata(data_object,data);
                        return;
                    end
                    set(gui.GoButton,'Enable','off');

                    % update flag
                    data.CommandOk{1}=0;

                    % update data object
                    guidata(data_object,data);

                    % run the command
                    Command(data_object,gui_object,data.CommandOk{2});
                end
            end
        end
    catch err
        
        % show error with location
        errordlg({'script error:';err.message;['function: ',num2str(err.stack(1).name)];['line: ',num2str(err.stack(1).line)]},'Error!');
        
        % stop timer and refresh program
        stop(src);
        Refresh();
    end
end