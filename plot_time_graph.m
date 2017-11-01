function plot_time_graph
pi = 3.14159265;
t = time; %time data 
x = datax; %Roll data (X)
y = datay; %Pitch data (Y)
z = dataz; %Yaw data (Z)
tilty = atan((y)/(sqrt((z^2)+(x^2)))*(180/pi)); % Y angle pitch
tiltx = atan((x)/(sqrt((z^2)+(y^2)))*(180/pi)); % X angle roll
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
   
    
