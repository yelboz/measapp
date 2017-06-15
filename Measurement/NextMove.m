function NextMove(data_object,gui_object,Sweepedthing,NM)
    % takes the sweeped instrument to the next step of the vector
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    instname=Sweepedthing{1}{1};
    obj=GetInst(data,gui,instname);
    property=Sweepedthing{1}{2};
    if regexp(instname,'keithley')
        %% keithley 2400
        switch property
            case 'dcv'
                % graudual movement of voltage
                GoToVolt(obj,NM);
            case 'dcc'
                fprintf(obj,[':SOUR:CURR:LEV ',num2str(NM)]);
        end
    elseif regexp(instname,'lockin')
        %% lockin
        switch property
            case 'acv'
                fprintf(obj,['SLVL ',num2str(NM)]);
            case 'freq'
                fprintf(obj,['FREQ ',num2str(NM)]);
            case 'auxdcv1'
                fprintf(obj,['AUXV 1,',num2str(NM)]);
            case 'auxdcv2'
                fprintf(obj,['AUXV 2,',num2str(NM)]);
            case 'auxdcv3'
                fprintf(obj,['AUXV 3,',num2str(NM)]);
            case 'auxdcv4'
                fprintf(obj,['AUXV 4,',num2str(NM)]);
        end
    elseif regexp(instname,'lakes336')
        %% lakes336
        switch property
            case 'setp1'
                fprintf(obj,['SETP 1,',num2str(NM)]);
            case 'setp2'
                fprintf(obj,['SETP 2,',num2str(NM)]);
        end
    elseif regexp(instname,'magnet')
        %% magnet
        data.magnetsweepflag=1;
        switch property
            
            % sets the high limit, sweeps to it and waits for the current
            % to reach the target
            case 'field'
                fprintf(obj,['ULIM ',num2str(10*NM)]);
                fprintf(obj,'SWEEP UP');
                
                % set flags for zero current and update data object
                data.mflag{1}=2;
                target=10*NM;
                guidata(data_object,data);
                
                j=PsHtrIfMagnetThere(data_object,gui_object,obj,target,false);
                while ~j
                    data=guidata(data_object);
                    if data.StopNow
                        return;
                    end
                    j=PsHtrIfMagnetThere(data_object,gui_object,obj,target,false);
                    pause(2);
                end
                
                % update flag and data object
                data.mflag{1}=0;
                guidata(data_object,data);
                
            % moves field in persistent current mode:
            % begin actions assuming current is zero and persistent heater
            % is off.
            case 'perfield'
                
                % return current to persistent current level
                fprintf(obj,'SWEEP UP FAST');
                
                % change flags for heater activation, and update data
                % object
                data.mflag{1}=1;
                data.mflag{2}='on';
                guidata(data_object,data);
                pause(1);
                
                % wait and check for current to reach desired level
                fprintf(obj,'IMAG?');
                f=scanstr(obj);
                f=f{1};
                si=regexp(f,'kG');
                f=f(1:si-1);
                target=str2double(f);
                
                % true if current is at target
                j=PsHtrIfMagnetThere(data_object,gui_object,obj,target,true);
                while ~j
                    data=guidata(data_object);
                    if data.StopNow
                        return;
                    end
                    j=PsHtrIfMagnetThere(data_object,gui_object,obj,target,true);
                    pause(2);
                end
                
                % after turning heater on field is moved
                fprintf(obj,['ULIM ',num2str(NM)]); % was 10 * NM
                pause(2);
                fprintf(obj,'SWEEP UP');
                
                % set flags for heater deactivation  and update data
                % object
                data.mflag{1}=1;
                data.mflag{2}='off';
                guidata(data_object,data);
                target=NM;
                
                j=PsHtrIfMagnetThere(data_object,gui_object,obj,target,true);
                while ~j
                    data=guidata(data_object);
                    if data.StopNow
                        return;
                    end
                    j=PsHtrIfMagnetThere(data_object,gui_object,obj,target,true);
                    pause(2);
                end
                
                % after target field has reached and the heater is off, the
                % current is taken to zero. measurement will continue after
                % current checks to be at zero
                fprintf(obj,'SWEEP ZERO FAST');
                
                % set flags for zero current and update data object
                data.mflag{1}=2;
                target=0;
                guidata(data_object,data);
                
                j=PsHtrIfMagnetThere(data_object,gui_object,obj,target,false);
                while ~j
                    data=guidata(data_object);
                    if data.StopNow
                        return;
                    end
                    j=PsHtrIfMagnetThere(data_object,gui_object,obj,target,false);
                    pause(2);
                end
                
                % update flag and data object
                data.mflag{1}=0;
                guidata(data_object,data);
        end
    elseif regexp(instname,'caen')
        %% caen
        if regexp(property,'dcv')
            chan=property(4);
            query(obj,['$BD:0,CMD:SET,CH:',chan,',PAR:VSET,VAL:',num2str(NM)]);                                
        end
    elseif regexp(instname,'duck')
        global bool is_duck_running_AC;
        if regexp(property, 'DC\d')
            if is_duck_running_AC
                fclose(obj);
                fopen(obj);
                fgets(obj);
                is_duck_running_AC = false;
            end
            port = property(3);
            data = sprintf('SET,%s,%s',port,num2str(NM));
            fprintf(obj,'%s\r', data);  
            output = fgets(obj)
        elseif regexp(property, 'AC\dAC')
            if is_duck_running_AC
                port = propert(3);
                data = sprintf('AC %s:%s', num2str(sqrt(2)*NM), port);
                fprintf(obj,'%s\r', data);
            else
                throw(MException('','Cannot change AC voltage without a running AC+DC port'))
            end
        elseif regexp(property, 'AC\dDC')
            if is_duck_running_AC
                port = property(3);
                data = sprintf('DC %s:%s', num2str(NM), port);
                fprintf(obj,'%s\r', data);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
            else
                throw(MException('','Cannot change DC voltage without a running AC+DC port'))
            end
        end
    elseif regexp(instname,'AMI')
        %% AMI magnet
        switch property
            case 'field'
                eps=0.005;
                fprintf(obj,['CONF:FIELD:TARG ',num2str(NM)]);
                fprintf(obj,'RAMP');
                out=query(obj,'FIELD:MAG?');
                meas=str2num(out);
                while abs(NM-meas)>eps
                    data=guidata(data_object);
                    out=query(obj,'FIELD:MAG?');
                    meas=str2num(out);
                    pause(2);
                end
        end
    end
end