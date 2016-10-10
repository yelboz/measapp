function answ=PsHtrIfMagnetThere(data_object,gui_object,obj,targetkg,pshtr)
    % check if current reached target and change the persistent heater
    % status
    
    % get structs from objects
    data=guidata(data_object);
    gui=guidata(gui_object);
    
    answ=false;
    
    % set additional waiting time and sensitivity
    perswait=5;
    eps=0.01;
    fprintf(obj,'IOUT?');
    f=scanstr(obj);
    f=f{1};
    si=regexp(f,'kG');
    f=f(1:si-1);
    f=str2double(f);
    
    %%%%%%%%%%%%%%%%%%%%%% for debugging
%     data.evilmatrix{data.evilcounter,data.bigevilcounter}=f;
%     data.evilcounter=data.evilcounter+1;
    %%%%%%%%%%%%%%%%%%%%%%
    guidata(data_object,data);
    
    % check if current has reached target
    if abs(f-targetkg)<eps
        
        % if there is no heater status change
        if ~pshtr
            answ=true;
        end
        
        % counts level check - 3 are needed to finish check
        data.mflag{3}=data.mflag{3}+1;
        if (data.mflag{3}>2)&&(pshtr)
            pause(perswait);
            fprintf(obj,['PSHTR ',data.mflag{2}]);
            pause(perswait/2);
            data.mflag{3}=0;
            answ=true;
        end
        guidata(data_object,data);
    end
end
