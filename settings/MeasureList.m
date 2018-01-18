function MeasureList(src,~,data_object,gui_object)
    % reads the list of measured instruments

    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % creates the list of measured properties
    set(gui.GoButton,'Enable','on');
    
    % loop on connected instruments and create a list of legal entries
    % accordingly
    all=1:length(data.Instruments);
    count=0;
    if any(data.Connected)
        for i=all(data.Connected==1)
            name=data.Instruments{i}{1};
            props=data.Instruments{i}{4};
            for j=1:length(props)
                count=count+1;
                if ~ischar(props)
                    prop=props{j};
                else
                    prop=props;
                end
                possiblemeasure{count}=[name,'.',prop];
            end         
        end
    end
    
    str=get(src,'string');
    
    % check if input is legal
    str=mat2str(str);
    str = regexprep(str,'[;[]'']','');
    list=strtrim(strsplit(str,','));
    for i=1:length(list)
        ch=false;
        s = list{i};
        pos = strfind(s,'#');
        if isempty(pos)==0
            list{i} = s(1:pos-1);
        end
        for j=1:length(possiblemeasure)
            if strcmp(list{i},possiblemeasure{j})
                ch=true;
            end
        end
        if ~ch
            warndlg(['The ',num2str(i),' entry: ',list{i},' is invalid']);
            set(gui.GoButton,'Enable','off');
        end
    end
    
    % update data struct
    data.MeasuredNames=strtrim(strsplit(str,','));
    
    % update data object
    guidata(data_object,data);
end