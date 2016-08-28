function bool=IsCommandGood(line)
    % checks if the command is legal
    
    bool=true;
    
    % loop on connected instruments and create a list of legal entries
    % accordingly
%     all=1:length(data.Instruments);
%     count=0;
%     if any(data.Connected)
%         for i=all(data.Connected==1)
%             name=data.Instruments{i}{1};
%             props=data.Instruments{i}{4};
%             for j=1:length(props)
%                 count=count+1;
%                 possiblesweep{count}=[name,'.',props{j}];
%             end         
%         end
%     end
    
    splitcom=strsplit(strtrim(line));
    if ~isempty(splitcom{1})
        switch splitcom{1}
            case 'set'
                %% set
                if length(splitcom)<3
                    bool=false;
                    return;
                end    
                a=strsplit(splitcom{2},'.');
                instname=a{1};
                prop=a{2};
                if regexp(instname,'keithley')
                    if ~((strcmp(prop,'dcv')||strcmp(prop,'dcc'))...
                            &&~(isnan(str2double(splitcom{3})))...
                            &&(length(splitcom)==3)) 
                        bool=false;
                        return;
                    end
                elseif regexp(instname,'lockin')
                    if ~((strcmp(prop,'acv')||strcmp(prop,'freq')...
                            ||strcmp(prop,'auxdcv1')||strcmp(prop,'auxdcv2')...
                            ||strcmp(prop,'auxdcv3')||strcmp(prop,'auxdcv4'))...
                            &&~(isnan(str2double(splitcom{3})))...
                            &&(length(splitcom)==3)) 
                        bool=false;
                        return;
                    end
                elseif regexp(instname,'magnet')
                    if ~(((length(splitcom)==3)&&((strcmp(prop,'sweep')...
                            &&(strcmp(splitcom{3},'up')||strcmp(splitcom{3},'down')||strcmp(splitcom{3},'zero')))...
                            ||(strcmp(prop,'pshtr')&&(strcmp(splitcom{3},'on')||strcmp(splitcom{3},'off')))...
                            ||(strcmp(prop,'ulim')&&~(isnan(str2double(splitcom{3}))))...
                            ||(strcmp(prop,'llim')&&~(isnan(str2double(splitcom{3}))))))...
                            ||((length(splitcom)==4)&&(strcmp(prop,'sweep')...
                            &&(strcmp(splitcom{3},'up')||strcmp(splitcom{3},'down')||strcmp(splitcom{3},'zero')...
                            &&strcmp(splitcom{4},'fast')))))
                        bool=false;
                        return;
                    end
                elseif regexp(instname,'caen')
                    if ~(strcmp(prop,'dcv0set')||strcmp(prop,'dcv1set')...
                            ||strcmp(prop,'dcv2set')||strcmp(prop,'dcv3set'))
                        bool=false;
                        return;
                    end
                elseif regexp(instname,'duck')
                    if ~(strcmp(prop,'AC0')||strcmp(prop,'AC1')||strcmp(prop,'AC2')...
                                    || strcmp(prop, 'AC') || strcmp(prop, 'DC') || strcmp(prop, 'RF')...
                                    || strcmp(prop,'DC0')||strcmp(prop,'DC1')||strcmp(prop,'DC2')||strcmp(prop,'DC3')...
                                    || strcmp(prop,'AC0AC')|| strcmp(prop,'AC1AC')|| strcmp(prop,'AC2AC')|| strcmp(prop,'AC3AC')...
                                    || strcmp(prop,'AC0DC')|| strcmp(prop,'AC1DC')|| strcmp(prop,'AC2DC')|| strcmp(prop,'AC3DC'))
                        bool=false;
                        return;
                    end
                else
                    bool=false;
                    return;
                end
            case 'sweep'
                %% sweep
                if length(splitcom)<5
                    bool=false;
                    return;
                end 
                a=strsplit(splitcom{2},'.');
                instname=a{1};
                prop=a{2};
                if (isnan(str2double(splitcom{3}))||isnan(str2double(splitcom{4}))...
                    ||isnan(str2double(splitcom{5}))||~isequal(fix(str2double(splitcom{5})),str2double(splitcom{5}))) 
                    bool=false;
                    return;
                end
                if regexp(instname,'keithley')
                    if ~(strcmp(prop,'dcv')||strcmp(prop,'dcc'))
                        bool=false;
                        return;
                    end
                elseif regexp(instname,'lockin')
                    if ~(strcmp(prop,'acv')||strcmp(prop,'freq')...
                            ||strcmp(prop,'auxdcv1')||strcmp(prop,'auxdcv2')...
                            ||strcmp(prop,'auxdcv3')||strcmp(prop,'auxdcv4'))
                        bool=false;
                        return;
                    end
                elseif regexp(instname,'magnet')
                    if ~(strcmp(prop,'field')||strcmp(prop,'perfield'))
                        bool=false;
                        return;
                    end
                elseif regexp(instname,'caen')
                    if ~(strcmp(prop,'dcv0set')||strcmp(prop,'dcv1set')...
                            ||strcmp(prop,'dcv2set')||strcmp(prop,'dcv3set'))
                        bool=false;
                        return;
                    end
                elseif regexp(instname,'duck')
                    if ~(strcmp(prop,'AC0')||strcmp(prop,'AC1')||strcmp(prop,'AC2')...
                                    ||strcmp(prop,'RF') || strcmp(prop, 'AC') || strcmp(prop, 'DC')...
                                    || strcmp(prop,'DC0')||strcmp(prop,'DC1')||strcmp(prop,'DC2')||strcmp(prop,'DC3')...
                                    || strcmp(prop,'AC0AC')|| strcmp(prop,'AC2AC')|| strcmp(prop,'AC2AC')|| strcmp(prop,'AC3AC')...
                                    || strcmp(prop,'AC0DC')|| strcmp(prop,'AC1DC')|| strcmp(prop,'AC2DC')|| strcmp(prop,'AC3DC'))
                        bool=false;
                        return;
                    end
                else
                    bool=false;
                    return;
                end
                switch length(splitcom)
                    case 5
                    case 9
                        a=strsplit(splitcom{6},'.');
                        instname2=a{1};
                        prop2=a{2};
                        if (isnan(str2double(splitcom{7}))||isnan(str2double(splitcom{8}))...
                            ||isnan(str2double(splitcom{9}))||~isequal(fix(str2double(splitcom{9})),str2double(splitcom{9}))) 
                            bool=false;
                            return;
                        end
                        if regexp(instname2,'keithley')
                            if ~(strcmp(prop2,'dcv')||strcmp(prop2,'dcc'))
                                bool=false;
                                return;
                            end
                        elseif regexp(instname2,'lockin')
                            if ~(strcmp(prop2,'acv')||strcmp(prop2,'freq')...
                                    ||strcmp(prop2,'auxdcv1')||strcmp(prop2,'auxdcv2')...
                                    ||strcmp(prop2,'auxdcv3')||strcmp(prop2,'auxdcv4'))
                                bool=false;
                                return;
                            end
                        elseif regexp(instname2,'magnet')
                            if ~(strcmp(prop2,'field')||strcmp(prop2,'perfield'))
                                bool=false;
                                return;
                            end
                        elseif regexp(instname2,'caen')
                            if ~(strcmp(prop,'dcv0set')||strcmp(prop,'dcv1set')...
                                    ||strcmp(prop,'dcv2set')||strcmp(prop,'dcv3set'))
                                bool=false;
                                return;
                            end
                        elseif regexp(instname2,'duck')
                            if ~(strcmp(prop,'AC0')||strcmp(prop,'AC1')||strcmp(prop,'AC2')||strcmp(prop,'AC3')...
                                    ||strcmp(prop,'RF') || strcmp(prop, 'AC') || strcmp(prop, 'DC')...
                                    || strcmp(prop,'DC0')||strcmp(prop,'DC1')||strcmp(prop,'DC2')||strcmp(prop,'DC3')...
                                    || strcmp(prop,'AC0AC')|| strcmp(prop,'AC2AC')|| strcmp(prop,'AC2AC')|| strcmp(prop,'AC3AC')...
                                    || strcmp(prop,'AC0DC')|| strcmp(prop,'AC1DC')|| strcmp(prop,'AC2DC')|| strcmp(prop,'AC3DC'))
                                bool=false;
                                return;
                            end
                        else
                            bool=false;
                            return;
                        end
                    otherwise
                        bool=false;
                        return;
                end
            case 'move'
                %% move
                if length(splitcom)~=5
                    bool=false;
                    return;
                end 
                a=strsplit(splitcom{2},'.');
                instname=a{1};
                prop=a{2};
                if (isnan(str2double(splitcom{3}))||isnan(str2double(splitcom{4}))...
                    ||isnan(str2double(splitcom{5}))||~isequal(fix(str2double(splitcom{5})),str2double(splitcom{5}))) 
                    bool=false;
                    return;
                end
                if regexp(instname,'keithley')
                    if ~(strcmp(prop,'dcv')||strcmp(prop,'dcc'))
                        bool=false;
                        return;
                    end
                elseif regexp(instname,'lockin')
                    if ~(strcmp(prop,'acv')||strcmp(prop,'freq')...
                            ||strcmp(prop,'auxdcv1')||strcmp(prop,'auxdcv2')...
                            ||strcmp(prop,'auxdcv3')||strcmp(prop,'auxdcv4'))
                        bool=false;
                        return;
                    end
                elseif regexp(instname,'magnet')
                    if ~(strcmp(prop,'field')||strcmp(prop,'perfield'))
                        bool=false;
                        return;
                    end
                    
                else
                    bool=false;
                    return;
                end
            case 'record'
                %% record
                if ~((length(splitcom)==1)||((length(splitcom)==2)&&~isnan(str2double(splitcom{2})))...
                        ||((length(splitcom)==3)&&~isnan(str2double(splitcom{2}))&&~isnan(str2double(splitcom{3}))))
                    bool=false;
                    return;
                end
            case '@'
                %% @
            case 'check'
                %% check
            case 'stoprecord'
                %% stoprecord
                if length(splitcom)~=1
                    bool=false;
                    return;
                end
            case 'continuelast'
                %% 
                if length(splitcom)~=1
                    bool=false;
                    return;
                end
            otherwise
                bool=false;
                return;
        end
    end
end