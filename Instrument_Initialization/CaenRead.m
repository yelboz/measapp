function outcell = CaenRead(obj)
%CAENREAD Reads Parameters from CAEN N1470
%   The function saves in output the follwing parameters, in a [1,13] cell
%   array:

%   {1} Control ('Remote'/'Local')
%   {2} Polarity
%   {3} Monitored Output Voltage (V)
%   {4} Monitored Output Current (uA)
%   {5} Power (-1: Error, 0: Off, 1: On)
%   {6} Status (' '/'Up'/'Down'/'MaxV'/'Disabled'/'Kill'/'Interlock'/
%           Other status code as bit string (see more below)
%   {7} Maximum Allowed Voltage (V)
%   {8} Ramp Up Rate (V/sec)
%   {9} Ramp Down Rate (V/sec)
%   {10} Time permitted before Trip
%   {11} Power Down Method (1: Kill, 2:Ramp)
%   {12} Set Voltage (Device will be set to this value when On)
%   {13} Current Limit (uA)
%
%
%   Explanation for Status Bit Code (6)
%   ----------------------------------------
%   | Bit | Function                       |
%   ----------------------------------------
%   | 0   | 0: Off, 1: ON                  |
%   | 1   | 1: Ramp UP                     |
%   | 2   | 1: Ramp DOWN                   |
%   | 3   | 1: IMON >= ISET                |
%   | 4   | 1: VMON > VSET + 250 V         |
%   | 5   | 1: VMON < VSET - 250 V         |
%   | 6   | 1: VOUT in MAXV protection     |
%   | 7   | 1: Ch OFF via TRIP             |
%   | 8   | 1: Power Max                   |
%   | 9   | 1:  TEMP > 105°C               |
%   | 10  | 1: On REMOTE but Switched OFF  |
%   | 11  | 1: Ch in KILL via front panel  |
%   | 12  | 1: Ch in INTERLOCK via f.p.    |
%   | 13  | 1: Calibration Error           |
%   | 14  | -                              |
%   | 15  | -                              |
%   --------------------------------------

%Open object for reading
status=get(obj,'status');
if strcmp(status,'closed')
    fopen(obj);
end

%Control
cntrl=strsplit(query(obj,'$BD:0,CMD:MON,PAR:BDCTR'),':');
cntrl=cntrl(length(cntrl));
%Polarity
pol=strsplit(query(obj,'$BD:0,CMD:MON,CH:4,PAR:POL'),{':',';',char(13)});
l=length(pol);
pol=pol(l-4:l-1);
%Monitored Voltage
vmon=strsplit(query(obj,'$BD:0,CMD:MON,CH:4,PAR:VMON'),{':',';',char(13)});
l=length(vmon);
vmon=vmon(l-4:l-1);
%Monitored Current
imon=strsplit(query(obj,'$BD:0,CMD:MON,CH:4,PAR:IMON'),{':',';',char(13)});
l=length(imon);
imon=imon(l-4:l-1);
%Status
bit=strsplit(query(obj,'$BD:0,CMD:MON,CH:4,PAR:STAT'),{':',';',char(13)}); %get decimal representation of status
l=length(bit);
bit=bit(l-4:l-1);
%Maximum Voltage
maxv=strsplit(query(obj,'$BD:0,CMD:MON,CH:4,PAR:MAXV'),{':',';',char(13)});
l=length(maxv);
maxv=maxv(l-4:l-1);
%Ramp Up Rate
rup=strsplit(query(obj,'$BD:0,CMD:MON,CH:4,PAR:RUP'),{':',';',char(13)});
l=length(rup);
rup=rup(l-4:l-1);
%Ramp Down Rate
rdown=strsplit(query(obj,'$BD:0,CMD:MON,CH:4,PAR:RDW'),{':',';',char(13)});
l=length(rdown);
rdown=rdown(l-4:l-1);
%Trip Time
trip=strsplit(query(obj,'$BD:0,CMD:MON,CH:4,PAR:TRIP'),{':',';',char(13)});
l=length(trip);
trip=trip(l-4:l-1);
%Power Down Method
out=strsplit(query(obj,'$BD:0,CMD:MON,CH:4,PAR:PDWN'),{':',';',char(13)});
l=length(out);
out=out(l-4:l-1);
% Set Voltage (for when channel is on)
vset=strsplit(query(obj,'$BD:0,CMD:MON,CH:4,PAR:VSET'),{':',';',char(13)});
l=length(vset);
vset=vset(l-4:l-1);
% Current Limit (uA)
iset=strsplit(query(obj,'$BD:0,CMD:MON,CH:4,PAR:ISET'),{':',';',char(13)});
l=length(iset);
iset=iset(l-4:l-1);

% Regularizing Data
bitstr=zeros([4,1]);
power=zeros([4,1]);
stat=cell([4,1]);
for i=1:4
    vmon{i}=sprintf('%4.1f',str2double(vmon{i}));
    vset{i}=sprintf('%4.1f',str2double(vset{i}));
    trip{i}=sprintf('%4.1f',str2double(trip{i}));
    imon{i}=sprintf('%4.2f',str2double(imon{i}));
    iset{i}=sprintf('%4.2f',str2double(iset{i}));
    maxv{i}=sprintf('%i',str2double(maxv{i}));
    rup{i}=sprintf('%i',str2double(rup{i}));
    rdown{i}=sprintf('%i',str2double(rdown{i}));
    % Power and Status
    bitstr(i)=str2double(bit{i});  % Get status string in number form
    switch bitstr(i)
        case 0                  %0000000000000000
            stat{i}=' ';
        case 1                  %0000000000000001
            stat{i}=' ';
            power(i)=1;
        case 3                  %0000000000000011
            stat{i}='Up';
            power(i)=1;
        case 5                  %0000000000000101
            stat{i}='Down';
            power(i)=1;
        case 97                 %0000000001100001
            stat{i}='MaxV';
            power(i)=1;
        case 1024               %0000010000000000
            stat{i}='Disabled';
            power(i)=-1;
        case 2048               %0000100000000000
            stat{i}='Kill';
            power(i)=-1;
        case 4096               %0001000000000000
            stat{i}='Interlock';
            power(i)=-1;
        otherwise
            stat{i}=[dec2bin(bitstr(i),16),' (Manual 3.4.3.1)' ];
            power(i)=-1;
    end
    pdown=strcmpi(out,'ramp');
end

outcell={cntrl,pol,vmon,imon,power,stat,maxv,rup,rdown,trip,pdown,vset,iset};

fclose(obj);
end

