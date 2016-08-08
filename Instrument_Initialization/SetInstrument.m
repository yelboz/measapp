function SetInstrument(~,~,data_object,gui_object,type)
    % sets the instrument with user chosen settings
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % set by type of instrument
    if regexp(type,'keithley')
        %% keithley 2400
        
        % acquire settings from gui
        source=GetStrFromPop(gui.SourcePopup);
        measure=GetStrFromPop(gui.MeasurePopup);
        sourcerange=GetStrFromPop(gui.SourceRangePopup);
        sourcerange=strsplit(sourcerange);
        sourcerangemult=UnitToMult(sourcerange{1,2});
        sourcerange=str2double(sourcerange{1,1})*sourcerangemult;
        measurerange=GetStrFromPop(gui.MeasureRangePopup);
        measurerange=strsplit(measurerange);
        measurerangemult=UnitToMult(measurerange{1,2});
        measurerange=str2double(measurerange{1,1})*measurerangemult;
        compmult=UnitToMult(GetStrFromPop(gui.MeasureCompUnitPopup));
        measurecompliance=str2double(get(gui.MeasureCompEdit,'string'))*compmult;
        stepmult=UnitToMult(GetStrFromPop(gui.VoltageStepUnitPopup));
        step=str2double(get(gui.VoltageStepEdit,'string'))*stepmult;
        set_stepmult=UnitToMult(GetStrFromPop(gui.VoltageSetStepUnitPopup));
        set_step=str2double(get(gui.VoltageSetStepEdit,'string'))*set_stepmult;
        fourwire=GetStrFromPop(gui.FourWirePopup);
        gotozero=get(gui.GoToZeroPopup,'value')-1;

        obj=GetInst(data,gui,gui.inst);
        status=get(obj,'status');
        if strcmp(status,'closed')
            fopen(obj);
        end

        switch source
            case 'VOLT'
                fprintf(obj,':SOUR:FUNC VOLT');
                prot='CURR';
            case 'CURR'
                fprintf(obj,':SOUR:FUNC CURR');
                prot='VOLT';
        end

        fprintf(obj,[':SOUR:',source,':MODE FIX']);
        fprintf(obj,[':SOUR:',source,':RANG:AUTO OFF']);
        fprintf(obj,[':SOUR:',source,':RANG ',num2str(sourcerange)]);

        switch measure
            case 'VOLT'
                fprintf(obj,':CONF:VOLT');
            case 'CURR'
                fprintf(obj,':CONF:CURR');
        end

        fprintf(obj,[':SENS:',prot,':RANG:AUTO OFF']);
        fprintf(obj,[':SENS:',prot,':PROT ',num2str(measurecompliance)]);
        fprintf(obj,[':SENS:',prot,':RANG ',num2str(measurerange)]);
        fprintf(obj,[':SENS:',prot,':PROT ',num2str(measurecompliance)]);

        switch fourwire
            case 'on'                                        
                fprintf(obj,':SYST:RSEN ON');
            case 'off'                                        
                fprintf(obj,':SYST:RSEN OFF');
        end
        
        % save the new metadata
        metadata={source,...
            sourcerange,...
            measure,...
            measurecompliance,...
            measurerange,...
            step,...
            set_step,...
            fourwire,...
            gotozero};
        obj.userdata{1}=metadata;

        fprintf(obj,':OUTP ON');
    elseif regexp(type,'dmm')
        %% keithley 2000
        measure=GetStrFromPop(gui.MeasurePopup);
        measurerange=GetStrFromPop(gui.MeasureRangePopup);
        measurerange=strsplit(measurerange);
        measurerangemult=UnitToMult(measurerange{1,2});
        measurerange=str2double(measurerange{1,1})*measurerangemult;
        obj=GetInst(data,gui,gui.inst);

        status=get(obj,'status');
        if strcmp(status,'closed')
            fopen(obj);
        end

        switch measure
            case 'Voltage'
                fprintf(obj,':SENS:FUNC "VOLT"');
                meas='VOLT';
            case 'Current'
                fprintf(obj,':SENS:FUNC "CURR"');
                meas='CURR';
        end

        fprintf(obj,[':SENS:',meas,':RANG:AUTO OFF']);
        fprintf(obj,[':SENS:',meas,':RANG ',num2str(measurerange)]);

        metadata={measure,...
            measurerange};
        obj.userdata{1}=metadata;
    elseif regexp(gui.inst,'lockin')
        %% lockin
        inp=get(gui.InputPopup, 'Value')-1;
        sens=get(gui.SensetivityPopup, 'Value')-1;
        tconst=get(gui.TimeConstPopup, 'Value')-1;
        slope=get(gui.SlopePopup, 'Value')-1;
        couple=get(gui.CouplingPopup, 'Value')-1;
        ground=get(gui.GroundPopup, 'Value')-1;
        filter=get(gui.FilterPopup, 'Value')-1;
        reserve=get(gui.ReservePopup, 'Value')-1;

        obj=GetInst(data,gui,gui.inst);

        status=get(obj,'status');
        if strcmp(status,'closed')
            fopen(obj);
        end
        fprintf(obj,['SENS ',num2str(sens)]);%choose sensitivity
        fprintf(obj,['ISRC ',num2str(inp)]);%choose input
        fprintf(obj,['OFLT ',num2str(tconst)]);%choose time const
        fprintf(obj,['OFSL ',num2str(slope)]);
        fprintf(obj,['ICPL ',num2str(couple)]);
        fprintf(obj,['IGND ',num2str(ground)]);
        fprintf(obj,['ILIN ',num2str(filter)]);
        fprintf(obj,['RMOD ',num2str(reserve)]);

        metadata={sens,...
            inp,...
            tconst,...
            slope,...
            couple,...
            ground,...
            filter,...
            reserve,...
            obj.userdata{1}{9},...
            obj.userdata{1}{10}};
        obj.userdata{1}=metadata;
    elseif regexp(gui.inst,'amplifier')
        %% amplifier
        sens=str2double(GetStrFromPop(gui.Amps2VoltPopup));
        if get(gui.Amps2VoltCheck,'value')
            connected=GetStrFromPop(gui.ConnectedToPopup);
        else
            connected='not connected';
        end
        metadata={sens,...
            connected};
        data.amplifier.userdata{1}=metadata;
    elseif regexp(gui.inst,'magnet')
        %% magnet
        range1=str2double(get(gui.FirstFinish, 'String'));
        range2=str2double(get(gui.SecondFinish, 'String'));
        range3=str2double(get(gui.ThirdFinish, 'String'));
        range4=str2double(get(gui.FourthFinish, 'String'));
        range5=str2double(get(gui.FifthFinish, 'String'));
        rate1=str2double(get(gui.FirstRate, 'String'));
        rate2=str2double(get(gui.SecondRate, 'String'));
        rate3=str2double(get(gui.ThirdRate, 'String'));
        rate4=str2double(get(gui.FourthRate, 'String'));
        rate5=str2double(get(gui.FifthRate, 'String'));
        rate6=str2double(get(gui.FastRate, 'String'));
        hilimit=str2double(get(gui.HiLimit, 'String'));
        lolimit=str2double(get(gui.LoLimit, 'String'));
        vlimit=str2double(get(gui.VLimit, 'String'));

        obj=GetInst(data,gui,gui.inst);        
        status=get(obj,'status');
        if strcmp(status,'closed')
            fopen(obj);
        end

        fprintf(obj,['RANGE 0 ',num2str(range1)]);
        fprintf(obj,['RANGE 1 ',num2str(range2)]);
        fprintf(obj,['RANGE 2 ',num2str(range3)]);
        fprintf(obj,['RANGE 3 ',num2str(range4)]);
        fprintf(obj,['RANGE 4 ',num2str(range5)]); 
        fprintf(obj,['RANGE 3 ',num2str(range4)]);
        fprintf(obj,['RANGE 2 ',num2str(range3)]);
        fprintf(obj,['RANGE 1 ',num2str(range2)]);
        fprintf(obj,['RANGE 0 ',num2str(range1)]);
        fprintf(obj,['RATE 0 ',num2str(rate1)]);
        fprintf(obj,['RATE 1 ',num2str(rate2)]);
        fprintf(obj,['RATE 2 ',num2str(rate3)]);
        fprintf(obj,['RATE 3 ',num2str(rate4)]);
        fprintf(obj,['RATE 4 ',num2str(rate5)]);
        fprintf(obj,['RATE 5 ',num2str(rate6)]);
        fprintf(obj,['ULIM ',num2str(hilimit)]);
        fprintf(obj,['LLIM ',num2str(lolimit)]);
        fprintf(obj,['VLIM ',num2str(vlimit)]);

        metadata={range1,...
            range2,...
            range3,...
            range4,...
            range5,...
            rate1,...
            rate2,...
            rate3,...
            rate4,...
            rate5,...
            rate6,...
            hilimit,...
            lolimit,...
            vlimit};
        obj.userdata{1}=metadata;
    elseif regexp(gui.inst,'caen')
        %% caen
        %initialize cells
        c=cell([4,1]);
        ch_status=c;
        max_voltage=c;
        ramp_up=c;
        ramp_down=c;
        trip=c;
        power_down=c;
        iset=c;
        
        for i=1:4
            ch_status{i}=GetStrFromPop(gui.StatusPopup{i});
            max_voltage{i}=get(gui.MaxVoltEdit{i},'string');
            ramp_up{i}=get(gui.RampUpEdit{i},'string');
            ramp_down{i}=get(gui.RampDownEdit{i},'string');
            trip{i}=get(gui.TripEdit{i},'string');
            power_down{i}=GetStrFromPop(gui.PowerDownPopup{i});
            iset{i}=get(gui.LimCurrEdit{i},'string');
        end
        
        obj=GetInst(data,gui,gui.inst);
        status=get(obj,'status');
        if strcmp(status,'closed')
            fopen(obj);
        end
        
        for i=1:4
            channel=int2str(i-1);
            query(obj,['$BD:0,CMD:SET,CH:',channel,',PAR:',ch_status{i}]);
            query(obj,['$BD:0,CMD:SET,CH:',channel,',PAR:MAXV,VAL:',max_voltage{i}]);
            query(obj,['$BD:0,CMD:SET,CH:',channel,',PAR:RUP,VAL:',ramp_up{i}]);
            query(obj,['$BD:0,CMD:SET,CH:',channel,',PAR:RDW,VAL:',ramp_down{i}]);
            query(obj,['$BD:0,CMD:SET,CH:',channel,',PAR:TRIP,VAL:',trip{i}]);
            query(obj,['$BD:0,CMD:SET,CH:',channel,',PAR:PDWN,VAL:',power_down{i}]);
        end
        
    end
    pause(0.1);
    
    % query metadata and close objects
    load(fullfile(data.sourcepath,'lastmeta.mat'));
%     instrumentsmetadata_new=cell([1,length(data.Instruments)]);
    all_inst=1:length(data.Instruments);
    for i=all_inst(data.Connected>0)
        name=data.Instruments{i}{1};
        InstObj=GetInst(data,gui,name);
        if strcmp(name,'caen')
            fclose(InstObj);
            break
        end
        QueryMeta(data,gui,name);
        instrumentsmetadata{i}=[data.Instruments{i}{1},InstObj.userdata{1}];
        try
            fclose(InstObj);
        catch
        end
    end
    
    %saving last maetadata file for next initiation
    save(fullfile(data.sourcepath,'lastmeta.mat'),'instrumentsmetadata')
    
    % update data and gui objects and close window
    guidata(data_object,data);
    guidata(gui_object,gui);
    delete(gui.instrumentsetWindow);
end