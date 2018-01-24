function QueryMeta(data,gui,name)
    % querys instrument for all relevant meta data
    % and opens the instrument for work
    
    obj=GetInst(data,gui,name);
    status=get(obj,'status');
    if strcmp(status,'closed')
        fopen(obj);
    end
    
    % check type of instrument
    if regexp(name,'keithley')
        %% keithley 2400
        fprintf(obj,':SOUR:FUNC?');
        source=scanstr(obj);
        source=source{1};
        fprintf(obj,[':SOUR:',source,':RANG?']);
        srange=scanstr(obj);
        srange=srange{1};
        fprintf(obj,':SENS:FUNC?');
        measure=scanstr(obj);
        measure=measure{end};
        measure=measure(2:5);
        fprintf(obj,[':SENS:',measure,':PROT?']);
        mcomp=scanstr(obj);
        mcomp=mcomp{1};
        fprintf(obj,[':SENS:',measure,':RANG?']);
        mrange=scanstr(obj);
        mrange=mrange{1};
        metadata={source,...
            srange,...
            measure,...
            mcomp,...
            mrange};
        for i=1:5
            obj.userdata{1}{i}=metadata{i};
        end
    elseif regexp(name,'dmm')
        %% keithley 2000
        measure=query(obj,':SENS:FUNC?');
        measure=measure(2:5);
        mrange= str2double(query(obj,[':SENS:',measure,':RANG?']));
        metadata={measure,...
            mrange};
        obj.userdata{1}=metadata;
    elseif regexp(name,'lockin')
        %% lockin
        fprintf(obj,'SENS?');
        sens = scanstr(obj);
        sens=sens{1};
        fprintf(obj,'ISRC?');
        inp = scanstr(obj);
        inp=inp{1};
        fprintf(obj,'OFLT?');
        tconst=scanstr(obj);
        tconst=tconst{1};
        fprintf(obj,'OFSL?');
        slope=scanstr(obj);
        slope=slope{1};
        fprintf(obj,'ICPL?');
        couple=scanstr(obj);
        couple=couple{1};
        fprintf(obj,'IGND?');
        ground=scanstr(obj);
        ground=ground{1};
        fprintf(obj,'ILIN?');
        filter=scanstr(obj);
        filter=filter{1};
        fprintf(obj,'RMOD?');
        reserve=scanstr(obj);
        reserve=reserve{1};
        fprintf(obj,'SLVL?');
        voltage=scanstr(obj);
        voltage=voltage{1};
        fprintf(obj,'FREQ?');
        frequency=scanstr(obj);
        frequency=frequency{1};
        metadata={sens,...
            inp,...
            tconst,...
            slope,...
            couple,...
            ground,...
            filter,...
            reserve,...
            voltage,...
            frequency};
        obj.userdata{1}=metadata;
    elseif regexp(name,'lakes336')
        % lakes336
        obj.userdata{1}='';
    elseif regexp(name,'magnet')
        % magnet
        fprintf(obj,'RANGE? 0');
        range1=scanstr(obj);
        range1=range1{1};
        fprintf(obj,'RANGE? 1');
        range2=scanstr(obj);
        range2=range2{1};
        fprintf(obj,'RANGE? 2');
        range3=scanstr(obj);
        range3=range3{1};
        fprintf(obj,'RANGE? 3');
        range4=scanstr(obj);
        range4=range4{1};
        fprintf(obj,'RANGE? 4');
        range5=scanstr(obj);
        range5=range5{1};
        fprintf(obj,'RATE? 0');
        rate1=scanstr(obj);
        rate1=rate1{1};
        fprintf(obj,'RATE? 1');
        rate2=scanstr(obj);
        rate2=rate2{1};
        fprintf(obj,'RATE? 2');
        rate3=scanstr(obj);
        rate3=rate3{1};
        fprintf(obj,'RATE? 3');
        rate4=scanstr(obj);
        rate4=rate4{1};
        fprintf(obj,'RATE? 4');
        rate5=scanstr(obj);
        rate5=rate5{1};
        fprintf(obj,'RATE? 5');
        rate6=scanstr(obj);
        rate6=rate6{1};
        fprintf(obj,'ULIM?');
        hilimit=scanstr(obj);
        hilimit=hilimit{1};
        si=regexp(hilimit,'kG');
        hilimit=hilimit(1:si-1);
        hilimit=str2double(hilimit)/10;
        fprintf(obj,'LLIM?');
        lolimit=scanstr(obj);
        lolimit=lolimit{1};
        si=regexp(lolimit,'kG');
        lolimit=lolimit(1:si-1);
        lolimit=str2double(lolimit);
        fprintf(obj,'VLIM?');
        vlimit=scanstr(obj);
        vlimit=vlimit{1};
        si=regexp(vlimit,'V');
        vlimit=vlimit(1:si-1);
        vlimit=str2double(vlimit);
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
    elseif regexp(name,'AMI')
        % AMI magnet
        scanstr(obj);
        scanstr(obj);
        obj.userdata{1}='';
    end
end