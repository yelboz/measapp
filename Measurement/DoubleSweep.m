function DoubleSweep(data_object,gui_object,SweepedStuff)
    % runs the sweep operation for two sweeped instrument
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    % load the data mat file
    load(data.filename);
    
    mode3=0;
    
    % creating the sweep vectors
    S1=linspace(SweepedStuff{1}{2},SweepedStuff{1}{3},SweepedStuff{1}{4});
    S2=linspace(SweepedStuff{2}{2},SweepedStuff{2}{3},SweepedStuff{2}{4});
    switch data.DoubleSweepMode
        case 2
            S2=[S2,fliplr(S2)];
        case 3
            mode3=1;
    end

    % set starting index - changes if measurement continues
    if get(gui.CheckContinue,'Value')
        sp=length(data.mesdata.data);
    else
        sp=0;
    end
    
    % loop on outer sweep vector
    for i=1:length(S1)
        data=guidata(data_object);
        gui=guidata(gui_object);
        
        % checks if stop button was pressed
        if ~data.StopNow
            NextMove(data_object,gui_object,SweepedStuff{1},S1(i));
            if data.StopNow
                break
            end
            
            % first iteration separated for a bigger time step
            j=1;

            % moves the sweeped instrument to the next point
            NextMove(data_object,gui_object,SweepedStuff{2},S2(j));
            pause(data.DoubleTimeStep);

            % measure instruments and store data
            mesdata.data(length(S2)*(i+sp-1)+1,:)=[S1(i),S2(j),Measure(data,gui)];
%           used to be: (wrong indexing)
%           mesdata.data(i+sp,:)=[S1(i),S2(j),Measure(data,gui)];


            % live plot
            UpdateGraph(data,gui,mesdata.data);

            % save every step to avoid data loss
            save(data.filename,'mesdata');
            
            % loop on inner sweep vector
            for j=2:length(S2)
                data=guidata(data_object);
                gui=guidata(gui_object);
                if ~data.StopNow
                    NextMove(data_object,gui_object,SweepedStuff{2},S2(j));
                    if data.StopNow
                        break
                    end
                    pause(data.TimeStep);
                    mesdata.data(length(S2)*(i+sp-1)+j,:)=[S1(i),S2(j),Measure(data,gui)];
                    UpdateGraph(data,gui,mesdata.data);
                    save(data.filename,'mesdata')
                else
                    % breaks if stop button pressed
                    break
                end
            end
            
            %[Use this when the outer loop is magnetic field and the innerloop is the gate voltage and you want the measurement at each magnetic field to begin at the first gate voltage value (say -20 V )]
            % devidas - return to initial value of inner loop
            if i<length(S1)
                NextMove(data_object,gui_object,SweepedStuff{2},S2(1));
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % flips inner sweep vector
            if mode3
                S2=fliplr(S2);
            end
        else
            % breaks if stop button pressed
            break
        end
    end
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % devidas - take gate voltage (inner loop) to zero at end of measurement
    NextMove(data_object,gui_object,SweepedStuff{2},0);
    pause(3);
    %END HERE
    
       %[Use this when the outer loop is the gate voltage and you want the keithley to go back to zero after sweeping from -20 V to 20 V]
            % devidas - take gate voltage (outer loop) to zero at end of measurement
%     NextMove(data_object,gui_object,SweepedStuff{1},0);
%     pause(3);
    %END HERE
    
    % update data object
    data.mesdata=mesdata;
    guidata(data_object,data);
end 