function Command(data_object,gui_object,str)
    % gets command from command line or batch file
    % and executes
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % update flag and data object
    data.CommandOk{2}=-1;
    guidata(data_object,data);
    
    % display comment
    command=strtrim(str);
    disp(command);
    set(gui.EditCommand, 'string',command);

    % separate command to words
    splitcom=strsplit(command);
    splitcom=splitcom(~cellfun('isempty',splitcom));

    % check type of command
    switch splitcom{1}
        
        % used to write Matlab commands
        case '@'
            %% @
            eval(command(3:end));
            
        % for code checking porpuses
        case 'check'
            %% check
            
        % for instrument setting
        case 'set'
            %% set
            % get instrument object
            a=strsplit(splitcom{2},'.');
            instname=a{1};
            obj=GetInst(data,gui,instname);
            
            % open instrument communication and change setting
            status=get(obj,'status');
            if strcmp(status,'closed')
                fopen(obj);
            end
            SetWords(data_object,gui_object,obj,splitcom);
        
        % for instrument sweep measurement
        case 'sweep'
            %% sweep
            % update flag and data object
            data.runningmeas=1;
            guidata(data_object,data);
            
            % preparing for measurement
            SweepedStuff=StartRun(data_object,gui_object,splitcom);
            
            l=length(SweepedStuff); 
            if l==1
                Sweep(data_object,gui_object,SweepedStuff);
            elseif l==2
                DoubleSweep(data_object,gui_object,SweepedStuff);
            end
            
            % update data object
            data=guidata(data_object);
            data.runningmeas=0;
            guidata(data_object,data);
            
        % command for stopping record. used in batch files
        case 'stoprecord'
            %% stoprecord
            data.recordflag=0;
            
            % update data object
            guidata(data_object,data);
            
        % command for continuing measurement. used in batch files
        case 'continuelast'
            %% continuelast
            set(gui.CheckContinue,'Value',1);
            CheckContinueCallback(0,0,data_object,gui_object);
        
        %measures at constant time steps
        case 'record'
            %% record
            % update flag and data object
            data.runningmeas=1;
            data.recordflag=1;
            
            % set timer time unit. 1 is default, number after record
            % decides time step
            switch length(splitcom)
                case 1
                    data.tp=1;
                case 2
                    data.tp=str2double(splitcom{2});
                case 3
                    data.tp=str2double(splitcom{2});
                    data.time{3}=str2double(splitcom{3});
            end
            set(data.MainTimer,'Period',data.tp);
            guidata(data_object,data);
            
            % create data file
            [~,matfile]=StartRun(data_object,gui_object,splitcom);
            data=guidata(data_object);
            data.mesdata=matfile;
            
            % restart time for new measurements
            if ~get(gui.CheckContinue,'Value')
                data.time{2}=1;
                data.time{1}=clock;
            end
            
            % update data object
            guidata(data_object,data);
            start(data.MainTimer);
            
        % sweeps instrument without measuring
        case 'move'
            %% move
            data.runningmeas=1;
            MoveThis(data_object,gui_object,splitcom);
            data.runningmeas=0;
        otherwise
            errordlg('not a legal command');
    end


    % adding command to list of commands
    current_entries = cellstr(get(gui.ListCommand, 'String'));
    current_entries{end+1} = command;
    set(gui.ListCommand, 'String', current_entries);
    
    % update data object
    data=guidata(data_object);
    guidata(data_object,data);
    
    % close instruments if allowed
    if data.runningmeas==0
        EndRun(data_object,gui_object);
    end
end