function info=CheckInstStatus(obj,type)
    % get instrument's current state
    
    switch type
        case 'keithley'
            %% keithley 2400
            fprintf(obj,':SOUR:FUNC?');
            source=scanstr(obj);
            source=source{1};
            fprintf(obj,[':SOUR:',source,':LEV?']);
            nowvolt=scanstr(obj);
            nowvolt=nowvolt{1};
            source={source,nowvolt};
            fprintf(obj,':SENS:FUNC?');
            measure=scanstr(obj);
            measure=measure{1};
            measure=measure(2:5);
            info={source,measure};
    end
end