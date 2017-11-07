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
    
    N = getappdata(0,'sampleNumber');
    T = getappdata(0,'sampleTime');
    
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
    
    freqData = (0:length(xfft)-1)*T/length(xfft);
    
    a = get(handles.xyzGroup,'SelectedObject');
    ang = get(a,'tag');
    
    dom = get(handles.timeGroup,'SelectedObject');
    domain = get(dom,'tag');
    
    axes(handles.axes);
    
    show3d = get(handles.show3d,'value');
    
    a2 = get(handles.panel3D,'SelectedObject');
    ang2 = get(a2,'tag');

    
    if domain == 'timeDomain'
        domArr = timeData
        domName = ' Time';
        titleType = ' Angle';

        if strcmp(ang,'dispRoll')
            angArr = rollAng;
            name = 'Roll';
        else
        if strcmp(ang,'dispPitch')
            angArr = pitchAng;
            name = 'Pitch';
        else
        if strcmp(ang,'dispYaw')
            angArr = yawAng;
            name = 'Yaw';
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
            if strcmp(ang,'dispPitch')
                angArr = plotyfft;
                name = 'Pitch';
            else
            if strcmp(ang,'dispYaw')
                angArr = plotzfft;
                name = 'Yaw';
            end
            end
            end
        end
    end
        
if show3d == 0  
    
    plot2d(domArr,angArr,strcat(name,titleType,' Against  ',domName),domName,strcat(name,titleType));
    
else
    
    if domain == 'timeDomain'

        if strcmp(ang2,'roll3d')
            angArr2 = rollAng;
            name2 = ' Roll';
        else
        if strcmp(ang2,'pitch3d')
            angArr2 = pitchAng;
            name2 = ' Pitch';
        else
        if strcmp(ang2,'yaw3d')
            angArr2 = yawAng;
            name2 = ' Yaw';
        end
        end
        end

    else
        if domain == 'freqDomain'
            domArr = freqData;
            
            if strcmp(ang2,'roll3d')
                angArr2 = plotxfft;
                name2 = ' Roll';
            else
            if strcmp(ang2,'pitch3d')
                angArr2 = plotyfft;
                name2 = ' Pitch';
            else
            if strcmp(ang2,'yaw3d')
                angArr2 = plotzfft;
                name2 = ' Yaw';
            end
            end
            end
        end
        end
    
    plot3d(domArr,angArr,angArr2,strcat(name,' Against',name2,titleType,' Against',domName),domName,strcat(name,titleType),strcat(name2,titleType));
        
end
timeStatistics




            
    
 function plot2d (xAxis,yAxis,grphTitle,xLbl,yLbl)

            plot(xAxis,yAxis); % X axis is time, Y axis is pitch angle
                     title(grphTitle);
                     xlabel(xLbl);
                     ylabel(yLbl);
                     grid on;
                     
                     
function plot3d (xAxis,yAxis,zAxis,grphTitle,xLbl,yLbl,zLbl)

            plot3(xAxis,yAxis,zAxis);
                     title(grphTitle);
                     xlabel(xLbl);
                     ylabel(yLbl);
                     zlabel(zLbl);
                     grid on;

         
                     
            
        
    
function timeDomain_Callback(hObject, eventdata, handles)

function freqDomain_Callback(hObject, eventdata, handles)

function dispRoll_Callback(hObject, eventdata, handles)

function dispPitch_Callback(hObject, eventdata, handles)

function dispYaw_Callback(hObject, eventdata, handles)



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
