function data = CreateData()
    % Create the shared data-structure

    % setting source folder for data files
    sourcepath=pwd;
    
    % loading instrument list (contains names, addresses, parameters)
    instruments=load(fullfile(sourcepath,'instruments.mat'));
    instruments=instruments.instruments;
    
    %% creating timers
    % timer used to input commands
    CommandTimer=timer('ExecutionMode', 'FixedRate', ...
    'Period', 3);
    % timer used by record and magnet
    MainTimer=timer('ExecutionMode', 'FixedRate', ...
    'Period', 1);

    %% initializing parameters
    
    % flag for magnet- 
    % first cell: 0=no field movement, 1=movement with change in pshtr (persistent current heater),
    % 2=movement without pshtr change
    % second cell: 'on'/'off' for the pshtr change
    % third cell: number of positive checks for pshtr change (3 are needed)
    mflag={0,'',0}; %
    
    % flag for CommandTimer-
    % first cell: enabling new command input
    % second cell: string of command
    CommandOk={1,-1};
    
    % flag for record measurements
    % first cell: starting time (clock)
    % second cell: index for time data vector
    % third cell: length of recording
    time={0,1,-1};

    % for magnet debugging purposes - contains magnet readings
    evilmatrix={};   

    % building data structure for global work
    data = struct( ...
        'currentdirectory', 'C:\', ...
        'component', 'comp', ...
        'filename', 'C:\comp-0001', ...
        'TimeStep', 1, ... %steps for sweep/move
        'DoubleTimeStep', 1, ... %steps between sweeplines
        'DoubleSweepMode', 1, ... %set direction of sweeping
        'Instruments', {instruments}, ...
        'MeasuredNames', '', ... %list of measured properties
        'SweepedNames', '',... %list of sweeped properties
        'StopNow', 0,... %flag for stopping measurements
        'CommandTimer',CommandTimer,...
        'MainTimer',MainTimer,...
        'CommandOk',{CommandOk},...
        'tp',1,...%timer period
        'time',{time},...
        'mflag',{mflag},...
        'recordflag',0,...
        'batchflag',0,...
        'runningmeas',0,...
        'sourcepath',sourcepath,...
        'batchpath','',...
        'liveplots',1,...
        'Connected',zeros(size(instruments,1),1),...
        'mesdata',[],...
        'evilcounter',2,...
        'bigevilcounter',0,...
        'evilmatrix', {evilmatrix});
    
    %% creating all instrument objects - checks if the instrument is connected to the computer, only connected instruments are added
    for i=1:length(instruments)
        %obj=CreateInstrument(instruments{i});
        try
            obj=CreateInstrument(instruments{i});
            fopen(obj);
            data.Connected(i)=1;
            data.(instruments{i}{1})=obj; 
            fclose(obj);
            
        catch EXP
            warning(EXP.message)
            data.Connected(i)=0;
        end
    end
end