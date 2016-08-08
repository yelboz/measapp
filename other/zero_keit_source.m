function zero_keit_source(keit,source,src_lvl)
    % taking keithley to zero voltage/current
    
    if strcmp(source,'VOLT')
        GoToVolt(keit,0); %Voltage goes to zero gradually
        pause(1);
    else
        fprintf(keit,':SOUR:CURR:LEV 0');
    end
end