function [SweepedStuff,m]=StartRun(data_object,gui_object,splitcom)
    % setting graphic interface and creating data file
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % set buttons
    set(gui.EditMeasure,'Enable','off');
    set(gui.CheckContinue,'Enable','on');
    set(gui.AddComment,'Enable','on');
    set(gui.ShowInstrumentsButton,'Enable','off');
    set(gui.TextFileName1,'FontSize',16);
    set(gui.TextFileName1,'ForegroundColor','red');
    set(gui.TextFileName1,'string','saving to: ');

    
    % initialize flag
    data.StopNow=0;
    data.SweepedNames={};

    % creating SweepedStuff-cell array with measurement data
    
    % checks if record
    if strcmp(splitcom{1},'record')
        SweepedStuff{1}='time';
        data.SweepedNames{1}='time';
    else
        SweepedStuff=cell([1,(length(splitcom)-1)/4]);
        for j=1:(length(splitcom)-1)/4
            a=strsplit(splitcom{4*j-2},'.');
            instname=a{1};
            size=a{2};    
            SweepedStuff{j}{1}{1}=instname;
            SweepedStuff{j}{1}{2}=size;
            SweepedStuff{j}{2}=str2double(splitcom{4*j-1});
            SweepedStuff{j}{3}=str2double(splitcom{4*j});
            SweepedStuff{j}{4}=str2double(splitcom{4*j+1});
        end
        for i=1:length(SweepedStuff)
            data.SweepedNames{i}=strcat(SweepedStuff{i}{1}{1},'.',SweepedStuff{i}{1}{2});
        end
    end

    % creating x/y axis list of properties
    sizes=[data.SweepedNames,data.MeasuredNames];
    set(gui.ListChooseX1,'string',sizes);
    set(gui.ListChooseY1,'string',sizes);

    % updating metadata before measurement
    load(fullfile(data.sourcepath,'lastmeta.mat'));
    all=1:length(data.Instruments);
    
    % loop on connected instruments
    if any(data.Connected)
        for i=all(data.Connected==1)
            name=data.Instruments{i}{1};
            obj=GetInst(data,gui,name);
            if (strcmp(name,'caen'))
                fopen(obj);
                break
            elseif (strcmp(name, 'duck'))
                global bool is_duck_running_AC;
                %if is_duck_running_AC
                    %Shouldn't fopen if AC is running
                %else
                %    fopen(obj);
                %    fgets(obj);
                %end
               break
            end

            % gather live metadata and store it
            QueryMeta(data,gui,name);
            instrumentsmetadata{i}=[data.Instruments{i}{1},obj.userdata{1}];
        
        end
    end

    % if measurement is continued - last data loaded 
    if get(gui.CheckContinue,'Value')
        m=data.mesdata;
        return
    end

    % building data file and saving
    m=struct(...
        'data_version', 2.1, ...
        'measurement_time',datestr(now), ...
        'sweeped' , {data.SweepedNames}, ...
        'measured',{data.MeasuredNames} , ...
        'metadata',{instrumentsmetadata},...
        'data' , []);

    m.comments{1}=get(gui.EditComment,'string');
    data.filename=IndexSave(data,gui,m);

    % saving last maetadata file for next initiation
    measname=get(gui.EditMeasure,'string');
    measname=mat2str(measname);
    measname = regexprep(measname,'[;[]'' ]',''); %#ok<NASGU>
    save(fullfile(data.sourcepath,'lastmeasured.mat'),'measname')
    save(fullfile(data.sourcepath,'lastmeta.mat'),'instrumentsmetadata')
    
    % update data object
    guidata(data_object,data);
end