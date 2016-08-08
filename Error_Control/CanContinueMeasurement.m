function canit=CanContinueMeasurement(data)
    % checks if same properties are measured
    
    canit=true;
    prev=data.mesdata;
    if ~isequaln(prev.measured,data.MeasuredNames)
        canit=false;
        errordlg(['can''t continue measurement - fix measured properties:',prev.measured],'Problem');
    end
end