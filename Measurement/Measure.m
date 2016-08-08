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
        info(i)=MeasureThis(data,gui,data.MeasuredNames{i});
    end    
end 