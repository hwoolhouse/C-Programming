function varargout = GUI(varargin)

    % GUI MATLAB code for GUI.fig
    %      GUI, by itself, creates a new GUI or raises the existing
    %      singleton*.
    %
    %      H = GUI returns the handle to a new GUI or the handle to
    %      the existing singleton*.
    %
    %      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in GUI.M with the given input arguments.
    %
    %      GUI('Property','Value',...) creates a new GUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before GUI_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    
    % Edit the above text to modify the response to help GUI
    
    % Last Modified by GUIDE v2.5 07-Nov-2017 18:55:49
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @GUI_OpeningFcn, ...
        'gui_OutputFcn',  @GUI_OutputFcn, ...
        'gui_LayoutFcn',  [] , ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
    
    
    % --- Executes just before GUI is made visible.

function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to GUI (see VARARGIN)
    
    % Choose default command line output for GUI
    handles.output = hObject;
    
    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    
    % --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
    
    %-------------------------------------------------------------------------
    
    % All default auto generated stuff above - don't edit
    
    
    
function initialiseArrays(sampleNumber)
    
    % sampleNumber = getappdata(0,'sampleNumber')
    global timeData
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng
    global pitchRate
    global rollRate
    global yawRate
    
    %Arrays initialised for X, Y and Z Data, Roll, Pitch and Yaw Angle and
    %rate
    
    timeData = zeros(1,sampleNumber);
    xData = zeros(1,sampleNumber);
    yData = zeros(1,sampleNumber);
    zData = zeros(1,sampleNumber);
    pitchAng = zeros(1,sampleNumber);
    rollAng = zeros(1,sampleNumber);
    yawAng = zeros(1,sampleNumber);
    pitchRate = zeros(1,sampleNumber);
    rollRate = zeros(1,sampleNumber);
    yawRate = zeros(1,sampleNumber);
    
    
function saveParams_Callback(hObject, eventdata, handles)
    
    N = getappdata(0,'sampleNumber');
    T = getappdata(0,'sampleTime');
    
    mbedDrive = getappdata(0,'mbedDrive');
    
    try
        if(T<=0)
            throw(MException('settings:SmpleTme:negative','Sample time has been set less or equal to 0'))
        else
            if (T>10)
                throw(MException('settings:SmpleTme:big','Sample time has been set greater 10'))
            end
        end
        if(N<=0)
            throw(MException('settings:SmpleNo:negative','Sample Number set less than or equal to 0'))
        else
            if isreal(N)==0 || rem(N,1)~=0
                throw(MException('settings:SmpleNo:nonint','sample Number has been set as non real or non integer'))
            end
        end
        filename = strcat(mbedDrive,':\settings.txt');
        settingsFile = fopen(filename,'w');
        fprintf(settingsFile,'%d %f',N,T);
        fclose(settingsFile);
    catch ME
        if strcmp(ME.identifier,'MATLAB:FileIO:InvalidFid')
            msgbox({'Unable to save to mbed settings file due to invalid file location','please make sure you have  got the Mbed plugged in and set to the correct drive in Mbed settings'},'Error','error')
        end
        if strcmp(ME.identifier,'MATLAB:fopen:InvalidCharacter')
            msgbox({'Unable to save to mbed settings file due to invalid character or empty setting for MBED drive','please make sure you have set the correctly set the mbed drive under mbed settings to a single letter that the mbed drive is in'},'Error','error')
        end
        if strcmp(ME.identifier,'settings:SmpleTme:negative')
            msgbox({'Sample time cannot be less than or equal to 0','please change the value and try again'},'Error','error')
        end
        if strcmp(ME.identifier,'settings:SmpleTme:big')
            msgbox({'Sample time cannot be greater than 10','please change the value and try again'},'Error','error')
        end
        if strcmp(ME.identifier,'settings:SmpleNo:negative')
            msgbox({'Sample Number cannot be less than or equal to 0','please change the value and try again'},'Error','error')
        end
        if strcmp(ME.identifier,'settings:SmpleNo:nonint')
            msgbox({'Sample number must be a real Integer','please change the value and try again'},'Error','error')
        end
        return
    end
    
    
function [sampleNumber, sampleTime]= getSettings
    
    try
        mbedDrive = getappdata(0,'mbedDrive');
        
        filename=strcat(mbedDrive,':\settings.txt');
        settingsFile = fopen(filename,'r') ;
        settingsArray=fscanf(settingsFile,'%d%f');
        
        sampleNumber=settingsArray(1);
        sampleTime=settingsArray(2);
        fclose(settingsFile);
        
    catch ME
        if strcmp(ME.identifier,'MATLAB:FileIO:InvalidFid')
            msgbox({'Unable to save to mbed settings file due to invalid file location','please make sure you have  got the Mbed plugged in and set to the correct drive in Mbed settings', 'please ensure you have saved the sampling parameters'},'Error','error')
        end
        if strcmp(ME.identifier,'MATLAB:fopen:InvalidCharacter')
            msgbox({'Unable to save to mbed settings file due to invalid character or empty setting for MBED drive','please make sure you have set the correctly set the mbed drive under mbed settings to a single letter that the mbed drive is in'},'Error','error')
        end
    end
    
    
function captureData_Callback(hObject, eventdata, handles)
    
    set(handles.captureData,'string','Press MBED Button');
    drawnow
    
    global timeData
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng
    try
        [sampleNumber, sampleTime]= getSettings;
    catch ME
        if strcmp(ME.identifier,'MATLAB:unassignedOutputs')
            msgbox({'Unable to read mbed settings file' ,'Data capture aborted','Ensure you have correctly saved both mbed and sampling settings and try again'},'Error','error');
            %return
        end
    end
    
    checkArray(sampleNumber);
    
    comPort = getappdata(0,'comPort');
    
    try
        s = serial(strcat('COM',comPort));
        fopen(s);
    catch ME
        if strcmp(ME.identifier,'MATLAB:serial:fopen:opfailed')
            msgbox({'Unable to connect to MBED serial port - Data capture aborted','Ensure you have connected the Mbed and set it to the correct port in settings, restart matlab and try again'},'Error','error');
            %return
        end
    end
    
    i=1;
    radConv = 180/pi;
    try
        while (i<=sampleNumber)
            x = str2num(fscanf(s));
            if(i==1)
                set(handles.captureData,'string','Data Capture has begun');
                drawnow
            end
            xData(i) = x;
            y = str2num(fscanf(s));
            yData(i) = y;
            z = str2num(fscanf(s));
            zData(i) = z;
            pitchAng(i) = atan2(y,sqrt(z^2+x^2))*radConv; % Y angle pitch
            rollAng(i) = atan2(x,sqrt(z^2+y^2))*radConv; % X angle roll
            yawAng(i) = atan2(z,sqrt(x^2+y^2))*radConv; % Z angle yaw
            timeData(i)=i*sampleTime;
            i=i+1;
        end
    catch ME
        if strcmp(ME.identifier,'MATLAB:serial:fscanf:opfailed')
            msgbox({'Unable to collect readings - Data capture aborted','Ensure the Mbed is still connected and try again'},'Error','error');
            return
            fclose(s);
        end
        
    end
    fclose(s);
    rateCalculations;
    set(handles.captureData,'string','Data Captured!');
    pause(4)
    set(handles.captureData,'string','Capture Data');
    
    
function plotData_Callback(hObject, eventdata, handles)
    N = getappdata(0,'sampleNumber'); %retrieve the sample number as inputted by the user
    T = getappdata(0,'sampleTime'); %retrieve the sample time as inputted by the user

    set(handles.dataTable,'visible','off');
    
    global timeData
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng
    global pitchRate
    global rollRate
    global yawRate
    
    L = T*N;
    Fs = 1/T;
    xfft = fft(xData);
    yfft = fft(yData);
    zfft = fft(zData);
    
    plotxfft = abs(xfft/L);
    plotyfft = abs(yfft/L);
    plotzfft = abs(zfft/L);
    
    setappdata(0,'rollFFT',plotxfft);
    setappdata(0,'pitchFFT',plotyfft);
    setappdata(0,'yawFFT',plotzfft);
    
    freqData = (0:length(xfft)-1)*T/length(xfft);
    
    a = get(handles.xyzGroup,'SelectedObject');
    ang = get(a,'tag');
    
    dom = get(handles.timeGroup,'SelectedObject');
    domain = get(dom,'tag');
    
    show3d = get(handles.show3d,'value'); %get value if user has selected the graph to be 3D
    
    a2 = get(handles.panel3D,'SelectedObject'); %get the value of the buttons pressed by user in relation to x, y and z angles
    ang2 = get(a2,'tag'); %add pertinent angle as user has selected
    
    
    if domain == 'timeDomain' %if the time domain has been selected...
        domArr = timeData %set the domain array to be the time array
        domName = 'Time'; %set the domain name to be "Time"
        
        if strcmp(ang,'dispRoll') %if the roll angle has been selected...
            angArr = rollAng; %set the angle array to be the roll angle array
            name = 'Roll'; %set the data name to be "Roll"
        else
            if strcmp(ang,'dispPitch') %if the pitch angle has been selected...
                angArr = pitchAng; %set the angle array to be the pitch angle array
                name = 'Pitch'; %set the data name to be "Pitch"
            else
                if strcmp(ang,'dispYaw') %if the yaw angle has been selected...
                    angArr = yawAng; %set the angle array to be the yaw angle array
                    name = 'Yaw'; %set the data name to be "Yaw"
                end
            end
        end
        
    else
        if domain == 'freqDomain'
            domArr = freqData;
            domName = ' Frequency';
            titleType = ' Amplitude Spectrum';
            
            if strcmp(ang,'dispRoll')
                angArr = plotxfft;
                name = 'Roll';
            else

                if strcmp(ang,'dispPitch') %if the pitch angle has been selected...
                    angArr = plotyfft; %set the angle array to be the y fft angle array
                    name = 'Pitch'; %set the data name to be "Pitch"
                else
                    if strcmp(ang,'dispYaw') %if the yaw angle has been selected...
                        angArr = plotzfft; %set the angle array to be the z fft angle array
                        name = 'Yaw'; %set the data name to be "Yaw"
                    end
                end
            end
        end
    end
    
    if show3d == 0  %if the graph is set to be 2D/not 3D
        %plot the graph of the set domain and the set angle data, titled in relation to both
        plot2d(domArr,angArr,strcat(name,' Angle Against ',domName),domName,strcat(name,' Angle'));
        
    else  %if the graph is set to be 3D
        
        if domain == 'timeDomain'  %if the time domain has been selected...
            domArr = timeData; %set the domain array to be the time array
            domName = 'Time'; %set the domain name to be "Time"
            if strcmp(ang2,'roll3d') %if the roll angle has been selected as the 2nd angle...
                angArr2 = rollAng; %set the 2nd angle array to be the roll angle array
                name = 'Roll'; %set the data name to be "Roll"
            else
                if strcmp(ang2,'pitch3d') %if the pitch angle has been selected as the 2nd angle...
                    angArr2 = pitchAng; %set the 2nd angle array to be the pitch angle array
                    name = 'Pitch'; %set the data name to be "Pitch"
                else
                    if strcmp(ang2,'yaw3d') %if the yaw angle has been selected as the 2nd angle...
                        angArr2 = yawAng; %set the 2nd angle array to be the yaw angle array
                        name = 'Yaw'; %set the data name to be "Yaw"
                    end
                end

            end
            
        else
            if domain == 'freqDomain' %if the frequency domain has been selected...
                domArr = freqData; %set the domain array to be the frequency array
                domName = 'Frequency'; %set the domain name to be "Frequency"
                if strcmp(ang2,'roll3d') %if the roll angle has been selected as the 2nd angle...
                    angArr2 = plotxfft; %set the 2nd angle array to be the x fft angle array
                    name = 'Roll'; %set the data name to be "Roll"
                else
                    if strcmp(ang2,'pitch3d') %if the pitch angle has been selected as the 2nd angle...
                        angArr2 = plotyfft; %set the 2nd angle array to be the y fft angle array
                        name = 'Pitch'; %set the data name to be "Pitch"
                    else
                        if strcmp(ang2,'yaw3d') %if the yaw angle has been selected as the 2nd angle...
                            angArr2 = plotzfft; %set the 2nd angle array to be the z fft angle array
                            name = 'Yaw'; %set the data name to be "Yaw"
                        end
                    end
                end
            end
        end

        %plot the 3D graph of the domain array against the two angle arrays as set, and titled accordingly
        plot3d(domArr,angArr,angArr2,strcat(name,' Angle Against ',domName),domName,strcat(name,' Angle'),'zlbl');
        
    end
    
    
    
    
    
    %function to plot in 2D, having been given data to plot, the title, and the names of the data to plot
function plot2d (xAxis,yAxis,grphTitle,xLbl,yLbl)
    
    plot(xAxis,yAxis); % X axis is domain, Y axis is selected angle
    title(grphTitle); %title as specified
    xlabel(xLbl); %label the x axis with the specified domain
    ylabel(yLbl); %label the y axis with the specified angle
    grid on; %display the grid
    
    %function to plot in Â£D, having been given data to plot, the title, and the names of the data to plot
function plot3d (xAxis,yAxis,zAxis,grphTitle,xLbl,yLbl,zLbl)
    
    plot3(xAxis,yAxis,zAxis); % X axis is domain, Y axis is selected angle, Z axis is 2nd selected angle
    title(grphTitle); %title as specified
    xlabel(xLbl); %label the x axis with the specified domain
    ylabel(yLbl); %label the y axis with the specified angle
    zlabel(zLbl); %label the z axis with the 2nd specified angle
    grid on; %display the grid
    
    
function timeDomain_Callback(hObject, eventdata, handles) %time domain radio button
    
function freqDomain_Callback(hObject, eventdata, handles) %frequency domain radio button
    
function dispRoll_Callback(hObject, eventdata, handles) %roll angle radio button
    
function dispPitch_Callback(hObject, eventdata, handles) %pitch angle radio button
    
function dispYaw_Callback(hObject, eventdata, handles) %yaw angle radio button
    
 
%function to save data to file
function saveData_Callback(hObject, eventdata, handles)

global timeData %initialise global data arrays
global xData
global yData
global zData
%create table with time, raw x, y and z data
T = table(timeData.',xData.',yData.',zData.','VariableNames',{'Time','Raw_X_Values','Raw_Y_Values','Raw_Z_Values'});
[file,path,FilterIndex] = uiputfile('*.csv','Save Table As: '); %save dialog box for user input, to save as a .csv
if(FilterIndex~=0) %if cancel is not pressed...
    writetable(T,strcat(path,file)); %write table to specified location as a .csv file
    fprintf('Table saved as %s%s\n',path,file); %print that file has been saved and where
else %if cancel is pressed...
    disp('Table not saved') %display that table has not been saved
end


%function to load data from file
function loadData_Callback(hObject, eventdata, handles)


[file,path,FilterIndex] = uigetfile('*.csv','Load: '); %open file selection window to load a .csv file
if(FilterIndex==0) %if the cancel button is pressed...
    msgbox('Loading data cancelled by user','Cancelled','warn'); %display message saying loading has been cancelled
    return;
end
T1 = readtable(strcat(path,file)); %read data from .csv file as specified into a table
dataSet = table2array(T1); %convert table into array
sampleNumber = height(T1); %calculate sample number from number of entries in array height
sampleTime = dataSet(2,1)-dataSet(1,1); %calculate sample time from difference in first two time entries

global timeData %initialise global arrays
global xData
global yData
global zData
global pitchAng
global rollAng
global yawAng
checkArray(sampleNumber); %check that arrays don't need to be resized
i=1; %initialise loop iteration variable
radConv = 180/pi; %variable for converting between radians and degrees
while i<sampleNumber %specify loop to iterate through
    timeData(i)=dataSet(i,1); %read each row and column and set as an indexed point in the data arrays
    xData(i)= dataSet(i,2);
    yData(i)= dataSet(i,3);
    zData(i)= dataSet(i,4);
    pitchAng(i) = atan2(yData(i),sqrt(zData(i)^2+xData(i)^2))*radConv; % Y angle pitch calculation
    rollAng(i) = atan2(xData(i),sqrt(zData(i)^2+yData(i)^2))*radConv; % X angle roll calculation
    yawAng(i) = atan2(zData(i),sqrt(xData(i)^2+yData(i)^2))*radConv; % Z angle roll calculation
    i=i+1; %increase size of index to loop through next set of data
end

%function to check if arrays need to be resized
function checkArray(sampleNumber)
global timeData; %initialise global array
created = exist('timeData', 'var'); %check if the timeData array exists
arraySize = length(timeData); %get the length of the timeData array

if (created == 0) %if the timeData array does not exist...
    initialiseArrays(sampleNumber); %initialise arrays
else
    if(arraySize~=sampleNumber) %if the size of the array does not equal the number of samples
        initialiseArrays(sampleNumber); %initialise arrays
    end
end




%function for the sample number setting
function sampleNumber_Callback(hObject, eventdata, handles)

sampleNumber = str2num(get(handles.sampleNumber, 'String'));
setappdata(0,'sampleNumber',sampleNumber);
set(handles.sampleNumber, 'String', num2str(sampleNumber));

%function for the sample time setting
function sampleTime_Callback(hObject, eventdata, handles)

sampleTime = str2num(get(handles.sampleTime, 'String'));
setappdata(0,'sampleTime',sampleTime);
set(handles.sampleTime, 'String', num2str(sampleTime));

%function for the mbed settings
function mbedSettings_Callback(hObject, eventdata, handles)
a = get(hObject,'Value');
if a == 1
    set(handles.mbedSettingsPanel,'visible','on');
    set(handles.saveMbed,'visible','on');
    set(hObject,'string','Hide MBED Settings');
else
    set(handles.mbedSettingsPanel,'visible','off');
    set(handles.saveMbed,'visible','off');
    set(hObject,'string','Show MBED Settings');
end

%function for the COM port settings
function comPort_Callback(hObject, eventdata, handles)
comPort = get(handles.comPort,'String');
setappdata(0,'comPort',comPort);

%function for the mbed drive settings
function mbedDrive_Callback(hObject, eventdata, handles)
mbedDrive = (get(handles.mbedDrive,'String'));
setappdata(0,'mbedDrive',mbedDrive);

%function for saving the mbed settings
function saveMbed_Callback(hObject, eventdata, handles)

comPort = getappdata(0,'comPort'); %get the value of the COM port as input
mbedDrive = getappdata(0,'mbedDrive'); %get the value of the mbed drive as input

set(handles.saveMbed,'string','Saved!'); %save mbed drive and COM port settings
pause(2) %delay so user can see it has been saved
set(handles.saveMbed,'string','Save'); %revert to original button


%switch for showing 3D graphs
function show3d_Callback(hObject, eventdata, handles)
a = get(hObject,'Value');
if a == 1
    set(handles.panel3D,'visible','on')
else
    set(handles.panel3D,'visible','off')
end

%function to calculate the rate of angle change
function rateCalculations

sampleNumber = getappdata(0,'sampleNumber'); %get and set the sample number

global rollAng %initialise global arrays
global pitchAng
global yawAng
global pitchRate
global rollRate
global yawRate

i = 1; %iteration loop index

while (i<sampleNumber) %loop through data sets
    if(i==1) %for first entry...
        pitchRate(i)=0; %set all rates to be 0
        rollRate(i)=0;
        yawRate(i)=0;
    else %for all but the first entry...
        pitchRate(i) = pitchAng(i-1)-pitchAng(i); %calculate rates from difference in angles
        rollRate(i) = rollAng(i-1)-rollAng(i);
        yawRate(i) = yawAng(i-1)-yawAng(i);
    end
    i=i+1; %increase loop index
end
i=1; %return loop index to 1


%function for displaying time statistics
function timeStatistics

global pitchAng %initialise global arrays
global rollAng
global yawAng
global pitchRate
global rollRate
global yawRate

sampleNumber = length(pitchAng); %calculate sample number as length of the arrays

maxValueroll = max(rollAng) %calculate maximum roll angle
minValueroll = min(rollAng) %calculate minimum roll angle
PtoProll = peak2peak(rollAng) %calculate peak-to-peak roll angle
maxfValueroll = max(rollAng) %calculate maximum frequency domain roll angle
rmsRoll = rms(rollAng) %calculate root mean squared of roll angle
meanRoll = mean(rollAng) %calculate the mean roll angle
%same calculations repeated for pitch and yaw below
maxValuepitch = max(pitchAng)
minValuepitch = min(pitchAng)
PtoPpitch = peak2peak(pitchAng)
maxfValuepitch = max(pitchAng)
rmsPitch = rms(pitchAng)
meanPitch = mean(pitchAng)

maxValueyaw = max(yawAng)
minValueyaw = min(yawAng)
PtoPyaw = peak2peak(yawAng)
maxfValueyaw = max(yawAng)
rmsYaw = rms(yawAng)
meanYaw = mean(yawAng)
    
    rollFFT = getappdata(0,'rollFFT');
    pitchFFT = getappdata(0,'pitchFFT');
    yawFFT = getappdata(0,'yawFFT');
    
    %_____________________UI Appearance settings_______________________
    

function sampleNumber_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function saveBox_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function loadBox_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function sampleTime_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function mbedDrive_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function comPort_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
