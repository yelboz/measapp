

%clear;clc;
%load('C:\Documents and Settings\Menachem\My Documents\MATLAB\MenMatlab\Devices\Devices.mat')

load('Devices.mat')
 clc;
 
 % Closing & opening the relevant devices

fclose(Oxford);
fclose(KEITH2000);


fopen(Oxford);
fopen(KEITH2000);

%Taking start time of measurment
%start_time_of_measurment=clock;

 % Defining keithley voltmeter to measure voltage
query(KEITH2000, 'MEAsure:VOLTage?') ;

 query(Oxford,'C3');
 fprintf(Oxford,'Q6');
 

 % Allocating memory for the different parameters of measurments
 L=zeros(300000,1)*NaN;  
 Time=L;  
 Mag_field=L;  

SR=L;
Temp=L;

%query(Oxford,'C 3');

% Defining the DC field rate of change, in Oe/Sec
%SweepRates=10;
%NSweepRates=4;
%SweepRateChangeTimes=[10.,5.,10.];

% Defining the maximum allowed DC field
%maxfield=900;
% iteration = 1;
Temperature = 5.0;

SweepRate=20;

 rate=strcat('S',num2str(SweepRate*60/1509.65)); 
            query(Oxford,rate);
            %query(Oxford,rate);
             query(Oxford,'A 0');

%FileID1 = fopen('C:\\val\\Dstart.txt');

%fscanf(FileID1,'%g ',1)/10;
    %SWR = 32;%fscanf(FileID1,'%g ',1);
 maxfield =10000;% fscanf(FileID1,'%g',1);   
 maxfield_cur=(maxfield+150)/1509.65;
 % Initialing values of t0, k 
  %Taking start time of measurment
%fclose(FileID1);
%delete 'C:\\val\\Dstart.txt'

            query(Oxford,'A 0'); % set on hold
            %query(Oxford,'I -.01');%set initial low current
            %query(Oxford,'S 60'); % fast speed rate to reach initial current
            %query(Oxford,'A 1');  
            pause(5);


 Run = 0;
cnt=0;
while ((cnt == 0) || (Run ~= 1000))
    errmsg = 'msg';
    while ~isempty(errmsg)
       [FileID,errmsg] = fopen('C:\\val\\StartOx.txt');
       pause(1);
    end
    [Run,cnt] = fscanf(FileID,'%d ',1);
    %Temp = fscanf(FileID,'%g ',1)/10;
    %Rate = fscanf(FileID,'%g ',1);
    %Timewait=fscanf(FileID,'%g',1);
    fclose(FileID);
end
  pause(2);          %fclose(OFileID);
 k=0;
             % Reading magnetic DC field
             %Mag_field_temp=1509.65*str2double(strrep(query(KEITH2000, 'READ?'),'NDCV',' '))/0.1006;
t0=clock;
          %while k < 4
             % k = k + 1;
             
             
              % Mag_field_temp=1509.65*str2double(strrep(query(KEITH2000, 'READ?'),'NDCV',' '))/0.1006;

                 % Transforming voltage to magnetic DC field
                % Mag_field_temp=1509.65* V_coil(k) /0.2527;
 %                Mag_field(k)=  Mag_field_temp;

                 % Recording time of measurment, frequency & amplitude of AC field,
  %               % sweep-rate of DC field,
                 
                 % SR(k)=SweepRates(CurrentSweepRate);
                 
                 % Temp(k)=Temperature;
                  %pause(1);
                     
             targetcurrent=strcat('I ',num2str(maxfield_cur));
             query(Oxford,targetcurrent);
             
             start_time = etime(clock,t0);
             
              Mag_field_temp=1509.65*str2double(strrep(query(KEITH2000, 'READ?'),'NDCV',' '))/0.1006;
             %Mag_field_temp=1509.65*str2double(strrep(query(KEITH2000, 'READ?'),'NDCV',' '))/0.1006;

%recycle on;
%delete 'C:\\val\\start.txt';
            query(Oxford,'A 1');
                  
            %Starting increasing field while loop of measurments
       
            while  Mag_field_temp < maxfield
                 t2=clock; 
                  k=k+1;
                 

                 
                %Mag_field_temp=1509.65*str2double(strrep(query(KEITH2000, 'READ?'),'NDCV',' '))/0.1006;

                 % Transforming voltage to magnetic DC field
                % Mag_field_temp=1509.65* V_coil(k) /0.2527;
                 Mag_field(k)=  Mag_field_temp;

                 % Recording time of measurment, frequency & amplitude of AC field,
                 % sweep-rate of DC field,
                 time=etime(t2, t0);         
                 Time(k)=time;
                  SR(k)=SweepRate;
                 
                  Temp(k)=Temperature;
                  pause(0.1);
                 
                   Mag_field_temp=1509.65*str2double(strrep(query(KEITH2000, 'READ?'),'NDCV',' '))/0.1006;

            end
            
            
            
            
              targetcurrent=strcat('I ',num2str(-60/1509.65));           
        % targetcurrent=strcat('I ',num2str(0));
            query(Oxford,targetcurrent);
            query(Oxford,'A 1');    
          
        
          % Starting decreasing field while loop of measurments
          while  Mag_field_temp>0
                 k=k+1;
                 t2=clock; 
              
                 % Reading values from all measuring devices
               
                 

                 % Transforming voltage to magnetic DC field
                % Mag_field_temp=1509.65* V_coil(k) /0.2527;
                 Mag_field(k)=  Mag_field_temp;

                 % Recording time of measurment, frequency & amplitude of AC field,
                 % sweep-rate of DC field,
                 Time(k)=etime(t2, t0);
                  SR(k)=SweepRate;
                  
                  Temp(k)=Temperature;
                  pause(0.1);
                  Mag_field_temp=1509.65*str2double(strrep(query(KEITH2000, 'READ?'),'NDCV',' '))/0.1006;

          end
          k = k + 1;
          t2 = clock;

                           Mag_field(k)=  Mag_field_temp;

                 % Recording time of measurment, frequency & amplitude of AC field,
                 % sweep-rate of DC field,
                 Time(k)=etime(t2, t0);
                  SR(k)=SweepRate;
                  
                  Temp(k)=Temperature;
                 
          
          % Drawing graph of all the harmonics measured
          plot(Time,Mag_field);
            title('Mag_field Vs. time');xlabel('time [sec]');ylabel('Mag field [Oe]');
            getframe();

  % Defining the target current to -50 Oersted & actioning the current
           % supplier
          
            
             % Defining the target current to -50 Oersted & actioning the current
              % supplier
%              targetcurrent=strcat('I ',num2str(-50/1509.65));
%              query(Oxford,targetcurrent);
%              query(Oxford,'A 1');
%Saving workspace to file
%save('C:\Documents and Settings\user\My Documents\MATLAB\MenMatlab\Data\Dhakal\MatrNov2014\SLG4d10.mat');
%F=[Time,freq,Vpp,Temp,Mag_field,AmpH1,PhaH1,AmpH2,PhaH2,AmpH3,PhaH3];
%M=F(1:k,:);
M=[Time(1:k),Temp(1:k),Mag_field(1:k),SR(1:k)];
csvwrite('C:\D\Projects\Avalanches\May2016\OxfordData\NNb1.dat',M);
% Setting current to 0 and actioning current supplier
% 
 query(Oxford,'S10');
 targetcurrent=strcat('I','0');
 query(Oxford,targetcurrent);
 query(Oxford,'A1');
% iteration = iteration + 1;

