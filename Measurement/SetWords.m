function SetWords(data_object,gui_object,obj,splitcom)
    % setting an instrument parameter
    
    % get structs from objects
    data=guidata(data_object);
    
    a=strsplit(splitcom{2},'.');
    instname=a{1};
    property=a{2};

    % checking which instrument to set
    if regexp(instname,'keithley')
        %% keithley 2400
        type='keithley';
        
        % get instrument state
        nowfuncs=CheckInstStatus(obj,type);
        switch property
            case 'dcv'
                
                % move keithley voltage with minimum step considiration
                GoToVolt(obj,str2double(splitcom{3}),nowfuncs{1}{2},1);
                
                obj.userdata{2}=str2double(splitcom{3});
            case 'dcc'
                fprintf(obj,[':SOUR:CURR:LEV ',splitcom{3}]);
                obj.userdata{2}=str2double(splitcom{3});
            case 'returntozero'
                switch splitcom{3}
                    case 'on'                                        
                        obj.userdata{3}=1;
                    case 'off'                                        
                        obj.userdata{3}=0;
                    otherwise
                        errordlg('not a legal command');
                end
            otherwise
                errordlg('not a legal command');
        end 
    elseif regexp(instname,'lockin')
        %% lockin
        switch property
            case 'acv'
                fprintf(obj,['SLVL ',splitcom{3}]);%set voltage
            case 'freq'
                fprintf(obj,['FREQ ',splitcom{3}]);%set frequency
            case 'auxdcv1'
                fprintf(obj,['AUXV 1,',splitcom{3}]);
            case 'auxdcv2'
                fprintf(obj,['AUXV 2,',splitcom{3}]);
            case 'auxdcv3'
                fprintf(obj,['AUXV 3,',splitcom{3}]);
            case 'auxdcv4'
                fprintf(obj,['AUXV 4,',splitcom{3}]);
            otherwise
                errordlg('not a legal command');
        end
    elseif regexp(instname,'magnet')
        %% magnet
        switch property
            
            % for moving field to limits\zero
            case 'sweep'
                comm=splitcom{3};
                
                % check if sweep is fast
                if length(splitcom)==4
                    comm=[splitcom{3},' ',splitcom{4}];
                end
                fprintf(obj,['SWEEP ',comm]);
                
                % if magnet goes to zero fast, the program will pause until
                % the magnet has reached zero
                if strcmp(comm,'zero fast')
                    
                    % update flags and data object
                    data.runningmeas=1;
                    data.mflag{1}=2;
                    guidata(data_object,data);
                    
                    % start timer - timer will wait for magnet to reach
                    % zero
                    t_run=get(data.MainTimer,running);
                    if ~t_run
                        start(data.MainTimer);
                    end
                end
                
            % for changing the persistent heater state
            case 'pshtr'
                
                % debugging for magnet
                data.evilcounter=2;
                data.bigevilcounter=data.bigevilcounter+1;
                assignin('base','evil',data.evilmatrix)
                
                % update flags and data object
                data.runningmeas=1;
                data.mflag{1}=1;
                comm=splitcom{3};
                data.evilmatrix{1,data.bigevilcounter}=comm;
                data.mflag{2}=comm;
                guidata(data_object,data);
                
                % start timer - timer will wait for magnet to reach
                % correct field
                t_run=get(data.MainTimer,running);
                if ~t_run
                    start(data.MainTimer);
                end
                
            % change the high limit field
            case 'ulim'
                
                % update metadata
                obj.userdata{1}{12}=str2double(splitcom{3});
                comm=num2str(10*str2double(splitcom{3}));
                fprintf(obj,['ULIM ',comm]);
                
            % change the low limit field
            case 'llim'
                
                % update metadata
                obj.userdata{1}{13}=str2double(splitcom{3});
                comm=num2str(10*str2double(splitcom{3}));
                fprintf(obj,['LLIM ',comm]);
            otherwise
                errordlg('not a legal command');
        end
    elseif regexp(instname,'caen')
        %%caen
        if regexp(property,'dcv')
            chan=property(4);
            query(obj,['$BD:0,CMD:SET,CH:',chan,',PAR:VSET,VAL:',num2str(splitcom{3})]);
            OpenCaenStop(data_object,gui_object,obj,chan)
        end
    elseif regexp(instname,'duck')
        %duck
        global bool is_duck_running_AC;
        if regexp(property,'DC\d') %DC0 ... DC3                
            if is_duck_running_AC
                fclose(obj);
                fopen(obj);
                fgets(obj);
                is_duck_running_AC = false;
            end
            
            port = property(3);
            data = sprintf('SET,%s,%s',port,num2str(splitcom{3}))
            fprintf(obj,'%s\r', data);  
            output = fgets(obj)
            
        elseif strcmp(property,'AC') %AC0 ... AC3
            is_duck_running_AC = true;
            %Restart arduino and get the '\n' online signal
            fclose(obj);
            fopen(obj);
            out = fgets(obj);           
            data = sprintf('SINE,%s,%s',...
            num2str(splitcom{3}),num2str(splitcom{4}))
            fprintf(obj,'%s\r', data);  
            output = fgets(obj)
        elseif regexp(property,'AC\dAC')
            if is_duck_running_AC
                data = sprintf('AC %s:%s', num2str(str2double(splitcom{3}) * sqrt(2)),property(3))
                fprintf(obj,'%s\r', data);
            else
                throw(MException('','Cannot change AC voltage without a running AC+DC port'))
            end
            
        elseif regexp(property,'AC\dDC')
            if is_duck_running_AC
                data = sprintf('DC %s:%s', splitcom{3}, property(3))
                fprintf(obj,'%s\r', data);
            else
                throw(MException('','Cannot change DC voltage without a running AC+DC port'))
            end
        end
    pause(pi);
end