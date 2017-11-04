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
                    [timeData,xData,yData,zData,pitchAng,rollAng,yawAng]=dataCapture(timeData,xData,yData,zData,pitchAng,rollAng,yawAng,sampleNumber);
                else
                    dataSetUpload;
                    
                end
                break
            case 2
                
                [sampleRate, sampleNumber]=parameters(sampleRate, sampleNumber); %Settings changing subprogram
                if(sNumChange==1)
                    [timeData,xData,yData,zData,pitchAng,rollAng,yawAng,pitchVel,rollVel,yawVel,pitchAcc,rollAcc,yawAcc]=initialiseArrays(sampleNumber);
                end
                
            case 3
                [timeData,xData,yData,zData,pitchAng,rollAng,yawAng]=dataCapture(timeData,xData,yData,zData,pitchAng,rollAng,yawAng,sampleNumber);
            case 4
                saveDataToFile(timeData,xData,yData,zData)
            case 5
                plot_time_graphs;
            otherwise
                fprintf("Please choose 1-5");
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
    paramArray = [sampleRate ; sampleNumber];
    fileID = fopen('E:\settings.txt','w');
    fprintf(fileID,"%d %f", sampleNumber, sampleRate);
    fclose(fileID);
end

function [timeData,xData,yData,zData,pitchAng,rollAng,yawAng]=dataCapture(timeData,xData,yData,zData,pitchAng,rollAng,yawAng,sampleNumber)
    s = serial('COM4')
    fopen(s)
    i=1
    radConv = 180/pi;
    while (i<sampleNumber)
        x = str2num(fscanf(s))
        xData(i) = x
        y = str2num(fscanf(s))
        yData(i) = y
        z = str2num(fscanf(s))
        zData(i) = z
        pitchAng(i) = atan2((y),(sqrt(((z)^2)+((x)^2))*(radConv))) % Y angle pitch
        rollAng(i) = atan2((x),(sqrt(((z)^2)+((y)^2))*(radConv))) % X angle roll
        yawAng(i) = atan2((z),(sqrt(((x)^2)+((y)^2))*(radConv))) % Z angle yaw
        i=i+1
    end
    fclose(s)
    [pitchVel, rollVel, yawVel, pitchAcc, rollAcc, yawAcc] = velAccCalculations(sampleNumber, pitchAng, rollAng, yawAng);
end

function dataSetUpload
    i=1;
    while i<sampleNumber
        timeData(i)=dataSet(i,1);
        xData(i)= dataSet(i,2);
        yData(i)= dataSet(i,3);
        zData(i)= dataSet(i,4);
        pitchAng(i) = atan2((yData(i)),(sqrt(((zData(i))^2)+((xData(i))^2)))*(radConv)); % Y angle pitch
        rollAng(i) = atan2((xData(i)),(sqrt(((zData(i))^2)+((yData(i))^2)))*(radConv)); % X angle roll
        yawAng(i) = atan2((zData(i)),(sqrt(((xData(i))^2)+((yData(i))^2)))*(radConv)); % Z angle yaw
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
    T1 = readTable(fileTitle);
    dataSet = tabletoarray(T1);
    sampleNumber = height(dataSet);
    sampleRate = dataSet(2,1)-dataSet(1,1)
end

function plot_time_graph
    t = timeData; %time data
    x = xData; %Roll data (X)
    y = yData; %Pitch data (Y)
    z = zData; %Yaw data (Z)
    tilty = atan((y)/(sqrt((z^2)+(x^2)))*(radConv)); % Y angle pitch
    tiltx = atan((x)/(sqrt((z^2)+(y^2)))*(radConv)); % X angle roll
    Fs = 1000; %Sampling frequency
    T = 1/Fs;  % Sampling period
    L = L ;  % Length of signal, depending on a setting??
    t = (0:L-1)*T; %time vector
    xfft = fft(x);
    yfft = fft(y);
    Py2 = abs(yfft/L);
    Py1 = Py2(1:L/2+1);
    Py1(2:end-1) = 2*Py1(2:end-1);
    Px2 = abs(xfft/L);
    Px1 = Px2(1:L/2+1);
    Px1(2:end-1) = 2*Px1(2:end-1);
    exit_flag = 0;
    while (exit_flag == 0)
        fprintf('Display graphs of Data\n\n');
        fprintf('1. Display in Time Domain\n');
        fprintf('2. Display in Frequency Domain\n');
        fprintf('3. Analyse Data\n');
        fprintf('4. Close Program\n');
        choice = input('Please select: ');
        switch (choice)
            case {1}
                fprintf('Display graphs in Time Domain\n\n');
                fprintf('1. To display Roll Angle input: R \n');
                fprintf('2. To display Pitch Angle input: P \n');
                switch (choice)
                    case {R}
                        plot(t,tiltx,'mx'); % X axis is time, Y axis is roll angle
                        title('Roll angle against Time');
                        xlabel('Time');
                        ylabel('Roll Angle');
                        grid on;
                    case {P}
                        plot(t,tilty,'mx'); % X axis is time, Y axis is pitch angle
                        title('Pitch angle against Time');
                        xlabel('Time');
                        ylabel('Pitch Angle');
                        grid on;
                    otherwise
                        disp('Invalid entry, please try again');
                end
            case {2}
                fprintf('Display graphs in Frequency Domain\n\n');
                fprintf('1. To display Roll Angle input: R \n');
                fprintf('2. To display Roll Angle input: P \n');
                switch (choice)
                    case {R}
                        plot(f,Px1,'mx'); % X axis is time, Y axis is roll angle
                        title('Amplitude Spectrum against Frequency');
                        xlabel('Frequency (Hz)');
                        ylabel('Amplitude Spectrum');
                        grid on;
                    case {P}
                        plot(f,Py1,'mx'); % X axis is time, Y axis is pitch angle
                        title('Amplitude Spectrum against Frequency');
                        xlabel('Frequency (Hz)');
                        ylabel('Amplitude Spectrum');
                        grid on;
                    otherwise
                        disp('Invalid entry, please try again');
                end
            case {3}
                maxValue = max(k);
                minValue = min(k);
                avgValue = mean(k);
                PtoP = peak2peak(k);
                fprintf('Analyse data in: \n\n');
                fprintf('Time domain, Pitch: TP \n');
                fprintf('Time domain, Roll: TR \n');
                fprintf('Frequency domain, Pitch: FP \n');
                fprintf('Frequency domain, Roll: FR \n');
                switch (choice)
                    case {TP}
                        k = tiltx;
                        fprintf('\nPitch\nMaximum: %f\nMinimum: %f\nAverage: %f\nPeak-to-Peak: %f\n',maxValue,minValue,avgValue,PtoP);
                    case {TR}
                        k = tilty;
                        fprintf('\nPitch\nMaximum: %f\nMinimum: %f\nAverage: %f\nPeak-to-Peak: %f\n',maxValue,minValue,avgValue,PtoP);
                    case {FP}
                        k = Px1 ;
                        fprintf('\nPitch\nMaximum: %f\nMinimum: %f\nAverage: %f\nPeak-to-Peak: %f\n',maxValue,minValue,avgValue,PtoP);
                    case {FR}
                        k = Py1 ;
                        fprintf('\nPitch\nMaximum: %f\nMinimum: %f\nAverage: %f\nPeak-to-Peak: %f\n',maxValue,minValue,avgValue,PtoP);
                end
                
            case {4}
                exit_flag = 1;
            otherwise
                disp('Invalid entry, please try again');
        end
    end
    disp('Program finished.');
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
