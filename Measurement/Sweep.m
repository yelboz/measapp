function Sweep(data_object,gui_object,SweepedStuff)
    % runs the sweep operation for one sweeped instrument
    % creating sweep vector
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % to do - monitor time
%     tic
    
    % create sweep vector
    S=linspace(SweepedStuff{1}{2},SweepedStuff{1}{3},SweepedStuff{1}{4});
%     EstimateTime(data,SweepedStuff{1}{4})
    
    % there and back mode
    switch data.DoubleSweepMode
        case 2
            S=[S,fliplr(S)];
    end
    
    % set starting index - changes if measurement continues
    if get(gui.CheckContinue,'Value')
        sp=length(data.mesdata.data);
    else
        sp=0;
    end
    
    % load the data mat file
    load(data.filename);
    
    % first iteration separated for a bigger time step
    i=1;
    
    % moves the sweeped instrument to the next point
    NextMove(data_object,gui_object,SweepedStuff{1},S(i));
    pause(data.TimeStep);
    
    % measure instruments and store data
    mesdata.data(i+sp,:)=[S(i),Measure(data,gui)];
    
    % live plot
    UpdateGraph(data,gui,mesdata.data);
    
    % save every step to avoid data loss
    save(data.filename,'mesdata');
    
    % loop on sweep vector
    for i=2:length(S)
        
        % update each step
        data=guidata(data_object);
        gui=guidata(gui_object);
        
        %  checks if stop button was pressed
        if ~data.StopNow
            NextMove(data_object,gui_object,SweepedStuff{1},S(i));
            
            % check stop button after movement
            if data.StopNow
                break
            end
            pause(data.TimeStep);
            mesdata.data(i+sp,:)=[S(i),Measure(data,gui)];
           
            UpdateGraph(data,gui,mesdata.data);
            save(data.filename,'mesdata');
        else
            % breaks if stop button pressed
            break
        end
    end
    
    % update data object
    data.mesdata=mesdata;
    guidata(data_object,data);
    
%     toc
end