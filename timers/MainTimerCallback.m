function MainTimerCallback(src,~,data_object,gui_object)
    % timer for record and magnet operation
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % try is here for catching error location
    try
        
        % case of timer termination
        if (data.StopNow)||((data.mflag{1}==0)&&(data.recordflag==0))
            
            % stop the timer, update flags and close instruments
            stop(src);
            set(gui.GoButton,'Enable','on');
            guidata(data_object,data);
            EndRun(data_object,gui_object);
        end
        
        % case of record
        if data.recordflag
            %% record
            
            % allow command entry when magnet is not operating, update flag
            % and data object
            if data.mflag{1}==0
                data.CommandOk{1}=1;
                guidata(data_object,data);
                set(gui.GoButton,'Enable','on');
            end
            
            % calculates time since the beginning and measures instrument
            time=etime(clock,data.time{1});
            if data.time{3}>0
                if time>data.time{3}
                    % update data object
                    data.recordflag=0;
                    data.time{3}=-1;
                    guidata(data_object,data);
                    return;
                end
            end
            
            data.mesdata.data(data.time{2},:)=[time,Measure(data,gui)];
            
            % advencing index
            data.time{2}=data.time{2}+1;
            
            % saving data each step
            mesdata=data.mesdata;
            save(data.filename,'mesdata');
            
            % update live plot and data object
            UpdateGraph(data,gui,mesdata.data);
            guidata(data_object,data);
            
        end
        %% magnet
        
        % for persistent heater changes
        if data.mflag{1}==1
            obj=data.magnet;
            
            % decide target field according to activation/deactivation of
            % the heater
            switch data.mflag{2}
                
                % case of activation - target field is current magnet field
                case 'on'
                    fprintf(obj,'IMAG?');
                    f=scanstr(obj);
                    f=f{1};
                    si=regexp(f,'kG');
                    f=f(1:si-1);
                    target=str2double(f);
                    
                % case of deactivation - target field is last set high
                % limit
                case 'off'
                    target=obj.userdata{1}{12};
            end
            
            % check if current has reached desired level
            check1=PsHtrIfMagnetThere(data_object,gui_object,obj,target,true);
            if check1
                
                % update flag and data object
                data.mflag{1}=0;
                data.CommandOk{1}=1;
                guidata(data_object,data);
                set(gui.GoButton,'Enable','on');
            end
        
        % for sweep zero fast - waits until zero field is reached
        elseif data.mflag{1}==2
            obj=data.magnet;
            
            % check if zero field was reached
            target=0;
            check1=PsHtrIfMagnetThere(obj,target,false);
            if check1
                
                % update flag and data object
                data.mflag{1}=0;
                data.CommandOk{1}=1;
                guidata(data_object,data);
                set(gui.GoButton,'Enable','on');
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