function MoveThis(data_object,gui_object,command)
    % Moves the instrument (like sweep without measuring and saving)
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % initialize flag
    data.StopNow=0;
    guidata(data_object,data);
    
    a=strsplit(command{2},'.');
    instname=a{1};
    obj=GetInst(data,gui,instname);
    status=get(obj,'status');
    if strcmp(status,'closed')
        fopen(obj);
    end

    size=a{2};    
    SweepedStuff{1}{1}=instname;
    SweepedStuff{1}{2}=size;
    SweepedStuff{2}=str2double(command{3});
    SweepedStuff{3}=str2double(command{4});
    
    % if command is written without starting point (4 words) then starting
    % point is set to be current level
    if length(command)==5
        SweepedStuff{4}=str2double(command{5});
        S=linspace(SweepedStuff{2},SweepedStuff{3},SweepedStuff{4});
    else
        startpoint=MeasureThis(command{2});
        S=linspace(startpoint,SweepedStuff{2},SweepedStuff{3});
    end

    % loop sweep vector
    for i=1:length(S)
        
        % update each step
        data=guidata(data_object);
        
        % checks if stop button was pressed
        if ~data.StopNow
            NextMove(data_object,gui_object,SweepedStuff,S(i)); 
            pause(data.TimeStep);
        else
            % breaks if stop button pressed
            break
        end
    end
    pause(2);
end