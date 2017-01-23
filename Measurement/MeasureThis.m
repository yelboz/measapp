function meas=MeasureThis(data,gui,Property)
    % returns the specific measurement value
    
    meas=-99999;
    ss=strsplit(Property,'.');
    instname=ss{1};
    size=ss{2};
    
    % allows bluefors temperature to be measured from the log
    if ~strcmp(instname,'bluefors')
        obj=GetInst(data,gui,instname);
    end
    
    % measure by type
    if regexp(instname,'keithley')
        %% keithley 2400
        fprintf(obj,':READ?');
        keitdata=scanstr(obj);
        switch size
            case 'dcv'
                meas=keitdata{1};
            case 'dcc'
                meas=keitdata{2};
            case 'diptemp'
                meas=LakeTemp(keitdata{1});
        end
    elseif regexp(instname,'dmm')
        %% keithley 2000
        switch size
            case 'dcv'
                meas=str2double(query(obj,':DATA:FRES?'));
            case 'dcc'
                meas=str2double(query(obj,':DATA:FRES?'));
            case 'ndcv'
                meas=-str2double(query(obj,':DATA:FRES?'));
            case 'ndcc'
                meas=-str2double(query(obj,':DATA:FRES?'));
        end

    elseif regexp(instname,'lockin')
        %% lockin
        fprintf(obj,'SNAP?1,2,3,4');
        lockindata = scanstr(obj);
        switch size
            case 'nx'
                meas=-lockindata{1};
            case 'x'
                meas=lockindata{1};
            case 'y'
                meas=lockindata{2};
            case 'r'
                meas=lockindata{3};
            case 'phase'
                meas=lockindata{4};
        end
    elseif regexp(instname,'lakes336')
        %% lakes336
        switch size
            case 'ctemp'
                fprintf(obj,'KRDG? C');
                Sam1 = scanstr(obj);
                meas=Sam1{1};
            case 'htemp'
                fprintf(obj,'KRDG? H');
                Sam1 = scanstr(obj);
                meas=Sam1{1};
            case 'btemp'
                fprintf(obj,'KRDG? B');
                Sam1 = scanstr(obj);
                meas=Sam1{1};   
        end
    elseif regexp(instname,'magnet')
        %% magnet
        switch size
            case 'field'
                fprintf(obj,'IMAG?');
                d=scanstr(obj);
                d=d{1};
                si=regexp(d,'kG');
                d=d(1:(si-1));
                
                % convertsion to Tesla
                meas=0.1*str2double(d);
        end
    elseif regexp(instname,'bluefors')
        %% bluefors
            bluefores_dir='C:\Users\user\Google Drive\Steinberg Lab\BlueFors\Log';
            d=dir(bluefores_dir);
             [~,dx]=sort([d.datenum]);
            newest = d(dx(end)).name;
            log_dir=fullfile(bluefores_dir,newest);
            d=dir(log_dir);
            ind=size(end);
            codename=['CH',ind,' T'];
            for i=1:numel(d)
                if (regexpi(d(i).name,codename))
                    filename=fullfile(log_dir,d(i).name);
                    text = fileread(filename);
                    sep=strsplit(text,',');
                    meas=str2double(sep{end});
                end
            end
    elseif regexp(instname,'caen')
        %% caen
        if regexp(size,'dcv')
            chan=size(4);
            out=query(obj,['$BD:0,CMD:MON,CH:',chan,',PAR:VMON']);
            out=strsplit(out,':');
            meas=str2double(out(length(out)));
        elseif regexp(size,'dcc')
            chan=size(4);
            out=query(obj,['$BD:0,CMD:MON,CH:',chan,',PAR:IMON']);
            out=strsplit(out,':');
            meas=str2double(out(length(out)));
        end
    elseif regexp(instname,'duck')
        %% DUCK
        global bool is_duck_running_AC
        if is_duck_running_AC
        else 
            if regexp(size,'ADC')
                port=size(4);
                data = sprintf('GET_ADC,%s',port)
                fprintf(obj,'%s\r', data)
                meas = str2num(fgets(obj))
            end
        end
        
       
    end
end