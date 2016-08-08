function et=EstimateTime(data,num_steps)
    %
    
    timestep=data.TimeStep;
    et=3*timestep+(num_steps-1)*timestep;
end