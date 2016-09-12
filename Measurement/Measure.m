function info=Measure(data,gui)
    % creates the vector of measured data
    
    % checks if there are no measured properties
    bb=data.MeasuredNames;
    if length(bb)==1
        if cellfun('isempty',bb)
            info=-999;
            return;
        end
    end
    info=zeros([1,length(data.MeasuredNames)]);
    for i=1:length(data.MeasuredNames)
        s = data.MeasuredNames{i};
        pos = strfind(s,'#');
        if isempty(pos)
            repeat = 1;
        else
            repeat = str2double(s(pos+1:end));
            s = s(1:pos-1);
        end
        info(i)=0;
        
        for j=1:repeat
            temp = MeasureThis(data,gui,s);
            info(i) = info(i) + temp/repeat ;
        end
        
    end    
end 