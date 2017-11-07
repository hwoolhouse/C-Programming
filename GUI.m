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


function [sampleNumber, sampleTime]= getSettings(mbedDrive) 
           
    mbedDrive = getappdata(0,'mbedDrive');
            try 
            filename=strcat(mbedDrive,':\settings.txt'); 
            settingsFile = fopen(filename,'r'); 
            catch 
                msgbox({'Could not access the settings file in the MBED', 'Please ensure the MBED is plugged in and set to the correct drive in MBED Settings'},'Error', 'error') 
            end 
            sampleNumber=fscanf(settingsFile,'%s'); 
            sampleTime=fscanf(settingsFile,'%s'); 
            fclose(settingsFile); 

    
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
    
sampleNumber = getappdata(0,'sampleNumber');
sampleTime = getappdata(0,'sampleTime');

checkArray(sampleNumber);

comPort = getappdata(0,'comPort');

    try
        s = serial(strcat('COM',comPort));
        fopen(s);
    catch
        msgbox('Unable to connect to the MBED - please check the MBED is using the correct COM port in MBED Settings, restart matlab and try again','Error','error');
    end    
    
i=1;
radConv = 180/pi;
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
        pitchAng(i) = atan2(y,sqrt(z^2+x^2))*radConv % Y angle pitch
        rollAng(i) = atan2(x,sqrt(z^2+y^2))*radConv % X angle roll
        yawAng(i) = atan2(z,sqrt(x^2+y^2))*radConv % Z angle yaw
        timeData(i)=i*sampleTime;
        i=i+1;
    end
fclose(s);
rateCalculations;
set(handles.captureData,'string','Data Captured!');
pause(4)
set(handles.captureData,'string','Ready to Capture Data');


function plotData_Callback(hObject, eventdata, handles)

    N = getappdata(0,'sampleNumber'); %retrieve the sample number as inputted by the user
    T = getappdata(0,'sampleTime'); %retrieve the sample time as inputted by the user
    
    global timeData %initialise global arrays so they can be plotted
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng
    global pitchRate
    global rollRate
    global yawRate
    
    L = T*N; %set variable L to be sample time divided by the number of samples
    Fs = 1/T; %set the sampling frequency to be the inverse of the sample time
    xfft = fft(xData); %perform the fast fourier transform (fft) of the x Data array
    yfft = fft(yData); %perform fft of y Data array
    zfft = fft(zData); %perform fft of z Data array
    
    plotxfft = abs(xfft/L); %set the data to be graphed as the absolute of the X fft data divided by L
    plotyfft = abs(yfft/L); %set the data to be graphed as the absolute of the Y fft data divided by L
    plotzfft = abs(zfft/L); %set the data to be graphed as the absolute of the Z fft data divided by L
    
    freqData = (0:length(xfft)-1)*T/length(xfft); %populate the frequency data arrau
    
    a = get(handles.xyzGroup,'SelectedObject'); %get the value of the buttons pressed by user in relation to x, y and z angles
    ang = get(a,'tag'); %add pertinent angle as user has selected
    
    dom = get(handles.timeGroup,'SelectedObject'); %get the value of the buttons pressed by user in relation to domain
    domain = get(dom,'tag'); %add pertinent domain as user has selected
    
    axes(handles.axes); %add to axes
    
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
        if domain == 'freqDomain' %if the frequency domain has been selected...
            domArr = freqData; %set the domain array to be the frequency array
            domName = 'Frequency'; %set the domain name to be "Frequency"
            if strcmp(ang,'dispRoll') %if the roll angle has been selected...
                angArr = plotxfft; %set the angle array to be the x fft angle array
                name = 'Roll'; %set the data name to be "Roll"
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
                     
%function to plot in £D, having been given data to plot, the title, and the names of the data to plot                     
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

    global timeData
    global xData
    global yData
    global zData
    
T = table(timeData.',xData.',yData.',zData.','VariableNames',{'Time','Raw_X_Values','Raw_Y_Values','Raw_Z_Values'});
    [file,path,FilterIndex] = uiputfile('*.csv','Save Table As: ');
    if(FilterIndex~=0)
        writetable(T,strcat(path,file));
        fprintf('Table saved as %s%s\n',path,file);
    else
        disp('Table not saved')
    end
    
    
    
function loadData_Callback(hObject, eventdata, handles)

    
    [file,path,FilterIndex] = uigetfile('*.csv','Load: ');
    if(FilterIndex==0)
        msgbox('Loading data cancelled by user','Cancelled','warn');
        return;
    end
    T1 = readtable(strcat(path,file));
    dataSet = table2array(T1);
    sampleNumber = height(T1);
    sampleTime = dataSet(2,1)-dataSet(1,1);

    global timeData
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng
    checkArray(sampleNumber);
    i=1;
    radConv = 180/pi;
    while i<sampleNumber
        timeData(i)=dataSet(i,1);
        xData(i)= dataSet(i,2);
        yData(i)= dataSet(i,3);
        zData(i)= dataSet(i,4);
        pitchAng(i) = atan2(yData(i),sqrt(zData(i)^2+xData(i)^2))*radConv; % Y angle pitch
        rollAng(i) = atan2(xData(i),sqrt(zData(i)^2+yData(i)^2))*radConv; % X angle roll
        yawAng(i) = atan2(zData(i),sqrt(xData(i)^2+yData(i)^2))*radConv; % Z angle roll
        i=i+1;
    end
    
    function checkArray(sampleNumber)
        global timeData;
        created = exist('timeData', 'var');
        arraySize = length(timeData);
        
        if (created == 0)
            initialiseArrays(sampleNumber);
        else
            if(arraySize~=sampleNumber)
                initialiseArrays(sampleNumber);
            end
        end
    
    



function sampleNumber_Callback(hObject, eventdata, handles)

sampleNumber = str2num(get(handles.sampleNumber, 'String'));
setappdata(0,'sampleNumber',sampleNumber);
set(handles.sampleNumber, 'String', num2str(sampleNumber));


function sampleTime_Callback(hObject, eventdata, handles)

sampleTime = str2num(get(handles.sampleTime, 'String'));
setappdata(0,'sampleTime',sampleTime);
set(handles.sampleTime, 'String', num2str(sampleTime));


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

function comPort_Callback(hObject, eventdata, handles)
    comPort = get(handles.comPort,'String');
    setappdata(0,'comPort',comPort);

function mbedDrive_Callback(hObject, eventdata, handles)
    mbedDrive = (get(handles.mbedDrive,'String'));
    setappdata(0,'mbedDrive',mbedDrive);

function saveMbed_Callback(hObject, eventdata, handles)
    
    comPort = getappdata(0,'comPort');
    mbedDrive = getappdata(0,'mbedDrive');
    
    set(handles.saveMbed,'string','Saved!');
    pause(2)
    set(handles.saveMbed,'string','Save');

    
    
function show3d_Callback(hObject, eventdata, handles)
a = get(hObject,'Value');
if a == 1
    set(handles.panel3D,'visible','on')
else
    set(handles.panel3D,'visible','off')
end


function rateCalculations

sampleNumber = getappdata(0,'sampleNumber');
    
    global rollAng
    global pitchAng
    global yawAng
    global pitchRate
    global rollRate
    global yawRate

    i = 1;
    
    while (i<sampleNumber)
        if(i==1)
            pitchRate(i)=0;
            rollRate(i)=0;
            yawRate(i)=0;
        else
            
            pitchRate(i) = pitchAng(i-1)-pitchAng(i);
            rollRate(i) = rollAng(i-1)-rollAng(i);
            yawRate(i) = yawAng(i-1)-yawAng(i);
        end
        i=i+1;
    end
    i=1;



function timeStatistics

    global pitchAng
    global rollAng
    global yawAng
    global pitchRate
    global rollRate
    global yawRate
    
    sampleNumber = length(pitchAng);

    maxValueroll = max(rollAng)
    minValueroll = min(rollAng)
    PtoProll = peak2peak(rollAng)
    maxfValueroll = max(rollAng)
    rmsRoll = rms(rollAng)
    meanRoll = mean(rollAng)
    
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
