function obj=CreateInstrument(instrument)
    % create instrument object
    
    % gather instrument info
    InstName=instrument{1};
    InstInter=instrument{2};
    InstAddress=str2double(instrument{3});
    
    % create object according to interface type, userdata holds the instrument's
    % metadata
    if strcmp(InstName,'amplifier')
        %% amplifier
        % userdata- {metadata}
        % metadata- ampspervolt,connectedto
        metadata={10^-2,'not connected'};
        obj.userdata={metadata};
        obj.Status='closed';
    else
        if strcmp(InstInter,'GPIB')
            %% GPIB
            obj = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', InstAddress, 'Tag', '');
            
            % Create the GPIB object if it does not exist
            % otherwise use the object that was found.
            if isempty(obj)
                obj = gpib('NI', 0, InstAddress);
            else
                fclose(obj);
                obj = obj(1);
            end

            % Set the property values
            set(obj, 'BoardIndex', 0);
            set(obj, 'ByteOrder', 'littleEndian');
            set(obj, 'BytesAvailableFcn', '');
            set(obj, 'BytesAvailableFcnCount', 48);
            set(obj, 'BytesAvailableFcnMode', 'eosCharCode');
            set(obj, 'CompareBits', 8);
            set(obj, 'EOIMode', 'on');
            set(obj, 'EOSCharCode', 'LF');
            set(obj, 'EOSMode', 'read&write');
            set(obj, 'ErrorFcn', '');
            set(obj, 'InputBufferSize', 2000);
            set(obj, 'Name', ['GPIB0-',num2str(obj.PrimaryAddress)]);
            set(obj, 'OutputBufferSize', 2000);
            set(obj, 'OutputEmptyFcn', '');
            set(obj, 'PrimaryAddress', obj.PrimaryAddress);
            set(obj, 'RecordDetail', 'compact');
            set(obj, 'RecordMode', 'overwrite');
            set(obj, 'RecordName', ['record',num2str(obj.PrimaryAddress),'.txt']);
            set(obj, 'SecondaryAddress', 0);
            set(obj, 'Tag', '');
            set(obj, 'Timeout', 10);
            set(obj, 'TimerFcn', '');
            set(obj, 'TimerPeriod', 1);
            
            % create userdata according to instrument type
            if regexp(InstName,'keithley')
                %% keithley 2400
                %userdata- {metadata,sourcelevel}
                %         metadata- source,...
                %             sourcerange,...
                %             measure,...
                %             measurecompliance,...
                %             measurerange,...
                %             step,...
                %             set_step,...
                %             fourwire,...
                %             gotozero
                metadata={'VOLT',100,'CURR',105e-6,100e-6,0.05,0.05,'off',0};
                obj.userdata={metadata,0};
                % setup the 2400 to generate an SRQ on buffer full and starts with zero
                % voltage
            elseif regexp(InstName,'dmm')
                %% keithley 2000
                %         metadata- measure,...
                %             measurerange,...
                metadata={'VOLT',100};
                obj.userdata={metadata};
            elseif regexp(InstName,'lockin')
                %% lockin
                %         metadata- sens,...
                %             inp,...
                %             tconst,...
                %             slope,...
                %             couple,...
                %             ground,...
                %             filter,...
                %             reserve,...
                %             voltage,...
                %             frequency
                metadata={26,0,8,3,0,0,0,2,0.004,1};
                obj.userdata={metadata};
            elseif regexp(InstName,'lakes336')
                %% lakes336
                obj.userdata={'none'};
            elseif regexp(InstName,'magnet')
                %% magnet
                %         userdata- {metadata}
                %         metadata- range1,...
                %             range2,...
                %             range3,...
                %             range4,...
                %             range5,...
                %             rate1,...
                %             rate2,...
                %             rate3,...
                %             rate4,...
                %             rate5,...
                %             rate6,...
                %             hilimit,...
                %             lolimit,...
                %             vlimit
                metadata={60,80,90,100,120,...
                    0.12,0.08,0.04,0.02,0.005,1,0,-139.994,5};
                obj.userdata={metadata};
            end
        elseif  strcmp(InstInter,'serial')
            %% serial
            port=['COM',num2str(InstAddress)];
            obj = instrfind('Type', 'serial', 'Port', port, 'Status', 'open');
            CloseObj = instrfind('Type', 'serial', 'Port', port, 'Status', 'closed');
            
            % Create the serial object if it does not exist,
            % otherwise use the object that was found (either open or
            % closed)
            if isempty(obj)
                if isempty(CloseObj)
                    obj = serial(port);
                else
                    obj = CloseObj(1);
                end
            else
                fclose(obj);
                obj = obj(1);
            end

            % Set the property values            
            obj.Terminator='CR';
            obj.BaudRate=9600;
            obj.DataBits=8;
            obj.Parity='none';
            obj.StopBits=1;
            obj.FlowControl='software';
        elseif  strcmp(InstInter,'DAC_ADC')
            freq = 115200;
            disp(instrument{3});
            obj = serial(instrument{3}, 'BaudRate', freq);

        end
    end
end