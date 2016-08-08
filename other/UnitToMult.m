function mult=UnitToMult(Unit)
    % gives back correct multiplication
    
    if regexp(Unit,'µ')
        mult=1e-6;
    elseif regexp(Unit,'m')
        mult=1e-3;
    else
        mult=1;
    end
end