function GoToVolt(obj,Vf,Vs,set)
    % changing voltage gradually from Vs to Vf
    
    if nargin==2
        Vs=obj.userdata{2};
    end
    
    % choose step according to command
    if nargin==4
        jump=obj.userdata{1}{7};
    else
        jump=obj.userdata{1}{6};
    end
    
    if abs(Vf-Vs)>jump
        if Vf>Vs
            for i=(Vs):jump:Vf 
                fprintf(obj,[':SOUR:VOLT:LEV ',num2str(i)]);
            end
        else
            for i=(Vs):(-jump):Vf
                fprintf(obj,[':SOUR:VOLT:LEV ',num2str(i)]);
            end
        fprintf(obj,[':SOUR:VOLT:LEV ',num2str(Vf)]);
        end
    else
        fprintf(obj,[':SOUR:VOLT:LEV ',num2str(Vf)]);
    end
        fprintf(obj,[':SOUR:VOLT:LEV ',num2str(Vf)]);
    obj.userdata{2}=Vf;
end