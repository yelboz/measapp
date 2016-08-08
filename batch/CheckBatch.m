function [bool,nl]=CheckBatch(b)
    % checks if the batch file is written correctly and returns the
    % number of line with error
    
    fid=fopen(b);
    bool=true;
    tline = fgets(fid);
    nl=0;
    numline=1;
    
    % check each line and return number of line with error
    while ischar(tline)&&bool
        bool=IsCommandGood(tline);
        if ~bool
            nl=numline;
        end
        tline = fgets(fid);
        numline=numline+1;
    end
    fclose(fid);
end