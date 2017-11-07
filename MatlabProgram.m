function MatlabProgram
    %Set default values
    sampleRate=0.1;
    sampleNumber=50;
    writeParams(sampleRate,sampleNumber);
    radConv = 180/pi;
    
    [timeData,xData,yData,zData,pitchAng,rollAng,yawAng,pitchVel,rollVel,yawVel,pitchAcc,rollAcc,yawAcc]=initialiseArrays(sampleNumber);
    
    %Menu function/GUI to be inserted
    exit_flag=0;
    while(exit_flag==0)
        userInput=input('Choose');
        switch(userInput)
            case 1
                [sampleNumber, sampleRate, dataSet] = loadDataFromFile;
                if isempty(dataSet)
                    [timeData,xData,yData,zData,pitchAng,rollAng,yawAng]=dataCapture(timeData,xData,yData,zData,pitchAng,rollAng,yawAng,sampleNumber,sampleRate);
                else
                    [timeData,xData,yData,zData,pitchAng,rollAng,yawAng]=dataSetUpload(sampleNumber,sampleRate,dataSet);
                    
                end
                5
            case 2
                
                [sampleRate, sampleNumber]=parameters(sampleRate, sampleNumber); %Settings changing subprogram
                if(sNumChange==1)
                    [timeData,xData,yData,zData,pitchAng,rollAng,yawAng,pitchVel,rollVel,yawVel,pitchAcc,rollAcc,yawAcc]=initialiseArrays(sampleNumber);
                end
                
            case 3
                [timeData,xData,yData,zData,pitchAng,rollAng,yawAng]=dataCapture(timeData,xData,yData,zData,pitchAng,rollAng,yawAng,sampleNumber,sampleRate);
            case 4
                saveDataToFile(timeData,xData,yData,zData)
            case 5
                plot_time_graph(timeData,xData,yData,zData,pitchAng,rollAng, sampleRate, sampleNumber)
            otherwise
                fprintf('Please choose 1-5');
        end
    end%Graphing
    %Statistics
    %Load and save data
    %Array dataSet holds loaded data
    %If dataSet is not empty, use that
    %Comparison
    %Exit
    
end

function [timeData,xData,yData,zData,pitchAng,rollAng,yawAng,pitchVel,rollVel,yawVel,pitchAcc,rollAcc,yawAcc]=initialiseArrays(sampleNumber)
    timeData = zeros(1,sampleNumber); %Initialise empty arrays with set dimensions so don't resize each loop
    xData = zeros(1,sampleNumber);
    yData = zeros(1,sampleNumber);
    zData = zeros(1,sampleNumber);
    pitchAng = zeros(1,sampleNumber);
    rollAng = zeros(1,sampleNumber);
    yawAng = zeros(1,sampleNumber);
    pitchVel = zeros(1,sampleNumber);
    rollVel = zeros(1,sampleNumber);
    yawVel = zeros(1,sampleNumber);
    pitchAcc = zeros(1,sampleNumber);
    rollAcc = zeros(1,sampleNumber);
    yawAcc = zeros(1,sampleNumber);
    %Arrays initialised for X, Y and Z Data, Roll, Pitch and Yaw Angle,
    %Velocity and Acceleration
end

%Parameters function to be made obsolete by GUI
function [sampleRate, sampleNumber, sNumChange]= parameters(sampleRate, sampleNumber)
    sNumChange=0;
    exitFlag = 0;
    while (exitFlag==0)
        fprintf('Parameter settings\n');
        fprintf('1. Print current parameters\n');
        fprintf('2. Change parameters\n');
        fprintf('3. Exit\n');
        userInputP1=input('Please select:');
        switch (userInputP1)
             case 1
                fprintf('Current Parameters:\n');
                fprintf('Sample Rate in seconds: %f\n', sampleRate);
                fprintf('Number of samples: %d\n', sampleNumber);
                
            case 2
                exitFlag2 = 0;
                while (exitFlag2==0)
                    fprintf('Change Parameters\n');
                    fprintf('1. Sample Rate in seconds\n');
                    fprintf('2. Sample Number\n');
                    fprintf('3. Exit\n');
                    userInputP2 = input('Please select:');
                    switch(userInputP2)
                        case 1
                            userInputP3 = abs(input('What is the new Sample Rate in seconds?'));
                            if(userInputP3>0)
                                sampleRate = userInputP3;
                                writeParams(sampleRate,SampleNumber);
                                fprintf('The new sample rate is %f s\n', sampleRate);
                            else
                                fprintf('New value must be greater than 0\n');
                            end
                            
                        case 2
                            userInputP4 = abs(input('What is the new number of samples?'));
                            if(userInputP4>0)
                                sampleNumber = userInputP4;
                                writeParams;
                                %If sampleNumber is changed then arrays must be
                                %reset to new size so sNumChange is set to 1,
                                %then arrays are reset in main function
                                sNumChange=1;
                                fprintf('The new number of samples is %d \n', sampleNumber);
                            else
                                fprintf('New value must be greater than 0\n');
                            end
                            
                        case 3
                            fprintf('Returning to main menu...\n');
                            exitFlag2=1;
                            
                        otherwise
                            fprintf('Invalid choice - please select again.\n');
                            
                    end
                end
            case 3
                fprintf('Returning to main menu...\n');
                exitFlag=1;
                
            otherwise
                fprintf('Invalid choice - please select again.\n');
        end
    end
end

function writeParams(sampleRate, sampleNumber)
    try
    fileID = fopen('E:\settings.txt','w');
    fprintf(fileID,'%d %f', sampleNumber, sampleRate);
    fclose(fileID);
    catch
        h=msgbox('Unable to write to mbed settings file, please check mbed connected as drive E:,containing a file called settings.txt and try again','Error','error');
    end    
end

function [timeData,xData,yData,zData,pitchAng,rollAng,yawAng]=dataCapture(timeData,xData,yData,zData,pitchAng,rollAng,yawAng,sampleNumber,sampleRate)
    
    try
        s = serial('COM4');
        fopen(s);
        fprintf("Press the reset button on the mbed to begin data capture\n");
    catch
        msgbox('Unable to connect to mbed, please check mbed is using COM4, restart matlab and try again','Error','error');
        return;
    end
    i=1;
    radConv = 180/pi;
    while (i<sampleNumber)
        x = str2num(fscanf(s));
        if(i==1)
            fprintf("Data capture has begun, please wait...\n");
        end
        xData(i) = x;
        y = str2num(fscanf(s));
        yData(i) = y;
        z = str2num(fscanf(s));
        zData(i) = z;
        pitchAng(i) = atan2((y),(sqrt(((z)^2)+((x)^2))*(radConv))); % Y angle pitch
        rollAng(i) = atan2((x),(sqrt(((z)^2)+((y)^2))*(radConv))) ;% X angle roll
        yawAng(i) = atan2((z),(sqrt(((x)^2)+((y)^2))*(radConv))) ;% Z angle yaw
        timeData(i)=i*sampleRate;
        i=i+1;
        
    end
    fclose(s)
    [pitchVel, rollVel, yawVel, pitchAcc, rollAcc, yawAcc] = velAccCalculations(sampleNumber, pitchAng, rollAng, yawAng);
    fprintf("Data Capture completed!\n");
end

function [timeData,xData,yData,zData,pitchAng,rollAng,yawAng]=dataSetUpload(sampleNumber,SampleRate,dataSet);
    i=1;
    radConv = 180/pi;
    while i<sampleNumber
        timeData(i)=dataSet(i,1);
        xData(i)= dataSet(i,2);
        yData(i)= dataSet(i,3);
        zData(i)= dataSet(i,4);
        pitchAng(i) = atan2((yData(i)),(sqrt(((zData(i))^2)+((xData(i))^2)))*(radConv)); % Y angle pitch
        rollAng(i) = atan2((xData(i)),(sqrt(((zData(i))^2)+((yData(i))^2)))*(radConv)); % X angle roll
        yawAng(i) = atan2((zData(i)),(sqrt(((xData(i))^2)+((yData(i))^2)))*(radConv)); % Z angle yaw
        i=i+1;
    end
    [pitchVel, rollVel, yawVel, pitchAcc, rollAcc, yawAcc] = velAccCalculations(sampleNumber, pitchAng, rollAng, yawAng);
end

function saveDataToFile(timeData,xData,yData,zData)
    T = table(timeData.',xData.',yData.',zData.','VariableNames',{'Time','Raw_X_Values','Raw_Y_Values','Raw_Z_Values'});
    [file,path,FilterIndex] = uiputfile('*.csv','Save Table As: ');
    if(FilterIndex~=0)
        writetable(T,strcat(path,file));
        fprintf('Table saved as %s%s\n',path,file);
    else
        disp('Table not saved')
    end
end

function [sampleNumber, sampleRate, dataSet] = loadDataFromFile
    fileTitleInput=input('Please input the name of the data set you wish to load: ');
    ending = '.csv';
    fileTitle = strcat(fileTitleInput,ending);
    T1 = readtable(fileTitle);
    dataSet = table2array(T1)
    sampleNumber = height(T1);
    sampleRate = dataSet(2,1)-dataSet(1,1)
end

function plot_time_graph(t,x,y,z,tiltx,tilty,T, N)
    %t = timeData; %time data
    %x = xData; %Roll data (X)
    %y = yData; %Pitch data (Y)
    %z = zData; %Yaw data (Z)
    %tilty = atan((y)/(sqrt((z^2)+(x^2)))*(radConv)); % Y angle pitch
    %tiltx = atan((x)/(sqrt((z^2)+(y^2)))*(radConv)); % X angle roll
    Fs = 1/T; %Sampling frequency
    %T = 1/Fs;  % Sampling period
    L = T*N ;  % Length of signal, depending on a setting??
    %t = (0:L)*T; %time vector
    xfft = fft(x);
    yfft = fft(y);
    
    f = Fs*(0:(L/2))/L;
    Py2 = abs(yfft/L);
    Py1 = Py2(1:L/2+1);
    Py1(2:end-1) = 2*Py1(2:end-1);
    Px2 = abs(xfft/L);
    Px1 = Px2(1:L/2+1);
    Px1(2:end-1) = 2*Px1(2:end-1);
    exit_flag = 0;
    while (exit_flag == 0)
        fprintf('\n\nDisplay graphs of Data\n\n');
        fprintf('1. Display in Time Domain\n');
        fprintf('2. Display in Frequency Domain\n');
        fprintf('3. Analyse Data\n');
        fprintf('4. Close Program\n');
        choice = input('Please select: ');
        switch (choice)
            case {1}
                fprintf('Display graphs in Time Domain\n\n');
                fprintf('1. To display Roll Angle input: 1 \n');
                fprintf('2. To display Pitch Angle input: 2 \n');
                j = input('Please enter 1 or 2: ');
            switch j
                case 1
                    plot(t,tiltx); % X axis is time, Y axis is roll angle
                     title('Roll angle against Time');
                     xlabel('Time');
                     ylabel('Roll Angle');
                     grid on;
                case 2                    
                     plot(t,tilty); % X axis is time, Y axis is pitch angle
                     title('Pitch angle against Time');
                     xlabel('Time');
                     ylabel('Pitch Angle');
                     grid on;
                otherwise
                    disp('Invalid entry, please try again');
            end
            case {2}
                fprintf('Display graphs in Frequency Domain\n\n');
                fprintf('1. To display Roll Angle input: 1 \n');
                fprintf('2. To display Roll Angle input: 2 \n');
                j = input('Please enter 1 or 2: ');
            switch j
                case 1
                    x_axis = Px1;
                    plot_frequency_graphs;
                case 2
                    x_axis = Py1;
                    plot_frequency_graphs;
                otherwise
                    disp('Invalid entry, please try again');
            end            
            case {3}
            fprintf('Analyse data in: \n\n');
            fprintf('Time domain, Pitch: 1 \n');
            fprintf('Time domain, Roll: 2 \n');
            fprintf('Frequency domain, Pitch: 3 \n'); 
            fprintf('Frequency domain, Roll: 4 \n');
            j = input('Please enter 1, 2, 3, or 4: ');
            switch j
                case 1
                    k = tiltx;
                    analyse_data;
                    fprintf('\nPitch:\nMaximum: %f\nMinimum: %f\nAverage: %f\nPeak-to-Peak: %f\nMax Frequency: %f\n',maxValue,minValue,avgValue,PtoP,maxfValue);
                case 2
                    k = tilty;
                    analyse_data;
                    fprintf('\nPitch\nMaximum: %f\nMinimum: %f\nAverage: %f\nPeak-to-Peak: %f\nMax Frequency: %f\n',maxValue,minValue,avgValue,PtoP,maxfValue);
                case 3
                    k = Px1 ;
                    analyse_data;
                    fprintf('\nPitch\nMaximum: %f\nMinimum: %f\nAverage: %f\nPeak-to-Peak: %f\nMax Frequency: %f\n',maxValue,minValue,avgValue,PtoP,maxfValue);
                case 4
                    k = Py1 ;
                    analyse_data;
                    fprintf('\nPitch\nMaximum: %f\nMinimum: %f\nAverage: %f\nPeak-to-Peak: %f\nMax Frequency: %f\n',maxValue,minValue,avgValue,PtoP,maxfValue);
            end
            case {4}
                exit_flag = 1;
            otherwise
                disp('Invalid entry, please try again');
        end
    end
    disp('Program finished.');
    function analyse_data
          maxValue = max(k);
          minValue = min(k);
          avgValue = mean(k);
          PtoP = peak2peak(k)
          maxfValue = max(f);
     end
     function plot_frequency_graphs
          plot(f,x_axis);
          title('Amplitude Spectrum against Frequency');
          xlabel('Frequency (Hz)');
          ylabel('Amplitude Spectrum');
          grid on;
     end
end

function [pitchVel, rollVel, yawVel, pitchAcc, rollAcc, yawAcc] = velAccCalculations(sampleNumber, pitchAng, rollAng, yawAng)
    i = 1;
    N = sampleNumber;
    
    while (i<N)
        if(i==1)
            pitchVel(i)=0;
            rollVel(i)=0;
            yawVel(i)=0;
        else
            
            pitchVel(i) = pitchAng(i-1)-pitchAng(i);
            rollVel(i) = rollAng(i-1)-rollAng(i);
            yawVel(i) = yawAng(i-1)-yawAng(i);
        end
        i=i+1;
    end
    i=1;
    while (i<N-1)
        pitchAcc(i)= pitchVel(i)-pitchVel(i+1);
        rollAcc(i)= rollVel(i)-rollVel(i+1);
        yawAcc(i)= yawVel(i)-yawVel(i+1);
        i=i+1;
    end
end

function []timeStatistics
i=0;
while i<sampleNumber
    absSumPitchAng = absSumPitchAng+abs(pitchAng(i));
    absSumRollAng = absSumRollAng+abs(rollAng(i));
    absSumYawAng = absSumYawAng+abs(yawAng(i));
    absSumPitchVel = absSumPitchVel+abs(pitchVel(i));
    absSumRollVel = absSumRollVel+abs(rollVel(i));
    absSumYawVel = absSumYawVel+abs(yawVel(i));
    absSumPitchAcc = absSumPitchAcc+abs(pitchAcc(i));
    absSumRollAcc = absSumRollAcc+abs(rollAcc(i));
    absSumYawAcc = absSumYawAcc+abs(yawAcc(i));
    sumSquaredPitchAng = sumSquaredPitchAng+(PitchAng(i))^2;
    sumSquaredRollAng = sumSquaredRollAng+(RollAng(i))^2;
    sumSquaredYawAng = sumSquaredYawAng+(YawAng(i))^2;
    sumSquaredPitchVel = sumSquaredPitchVel+(PitchVel(i))^2;
    sumSquaredRollVel = sumSquaredRollVel+(RollVel(i))^2;
    sumSquaredYawVel = sumSquaredYawVel+(YawVel(i))^2;
    sumSquaredPitchAcc = sumSquaredPitchAcc+(PitchAcc(i))^2;
    sumSquaredRollAcc = sumSquaredRollAcc+(RollAcc(i))^2;
    sumSquaredYawAcc = sumSquaredYawAcc+(YawAcc(i))^2;
    
    i=i+1;
end

meanPitchAng = mean(pitchAng);
meanRollAng = mean(rollAng);
meanYawAng = mean(yawAng);
meanPitchVel = mean(pitchVel);
meanRollVel = mean(rollVel);
meanYawVel = mean(yawVel);
meanPitchAcc = mean(pitchAcc);
meanRollAcc = mean(rollAcc);
meanYawAcc = mean(yawAcc);

absMeanPitchAng = absSumPitchAng/sampleNumber;
absMeanRollAng = absSumRollAng/sampleNumber;
absMeanYawAng = absSumYawAng/sampleNumber;
absMeanPitchVel = absSumPitchVel/sampleNumber;
absMeanRollVel = absSumRollVel/sampleNumber;
absMeanYawVel = absSumYawVelsampleNumber;
absMeanPitchAcc = absSumPitchAcc/sampleNumber;
absMeanRollAcc = absSumRollAcc/sampleNumber;
absMeanYawAcc = absSumYawAcc/sampleNumber;

rMSPitchAng = sqrt(sumSquaredPitchAng/sampleNumber);
rMSRollAng = sqrt(sumSquaredRollAng/sampleNumber);
rMSYawAng = sqrt(sumSquaredYawAng/sampleNumber);
rMSPitchVel = sqrt(sumSquaredPitchVel/sampleNumber);
rMSRollVel = sqrt(sumSquaredRollVel/sampleNumber);
rMSYawVel = sqrt(sumSquaredYawVelsampleNumber);
rMSPitchAcc = sqrt(sumSquaredPitchAcc/sampleNumber);
rMSRollAcc = sqrt(sumSquaredRollAcc/sampleNumber);
rMSYawAcc = sqrt(sumSquaredYawAcc/sampleNumber);


end
