function filename=IndexSave(data,gui,mesdata)
    % saving data with running counter
    
    % acquiring current save directory
    files=dir(data.currentdirectory);
    count=0;
    
    % looping through all the files
    for i=1:numel(files)
        
        % checking for similar component names
        if (regexpi(files(i).name,data.component))
            name=files(i).name;
            serial=str2double(name(length(data.component)+2:end-4));
            
            % getting number of files with component name
            if serial>count
                count=serial;
            end
        end
    end
    numb=num2str(count+1);
    d='0000';
    l=length(numb);
    filename=[data.currentdirectory,'\',data.component,'-',d(1:4-l),numb];
    
    % saving with new index
    if nargin==3
        save(filename,'mesdata');
    end
end