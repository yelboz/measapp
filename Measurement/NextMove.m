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
                fprintf(obj,['ULIM ',num2str(10*NM)]);
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
        if regexp(property,'DAC') 
            port=property(4);
            data = sprintf('SET,%s,%s',port, num2str(NM));
            fprintf(obj,'%s\r', data);
            output = fgets(obj);
        elseif regexp(property, 'AC')
            data = sprintf('AC %s', num2str(NM));
            fprintf(obj,'%s\r', data);
        elseif regexp(property, 'DC')
            data = sprintf('DC %s', num2str(NM));
            fprintf(obj,'%s\r', data);
        end
        
    end
    
end