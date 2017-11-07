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


%function to initialise arrays so they don't resize each iteration of a loop
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
    
    %program-wide arrays initialised for X, Y and Z Data, Roll, Pitch and Yaw Angle and rate
    
    %Empty arrays of dimensions 1xsampleNumber created
    timeData = zeros(1,sampleNumber); %Empty array for the time data
    xData = zeros(1,sampleNumber); %Empty array for the x accelerometer data
    yData = zeros(1,sampleNumber); %Empty array for the y accelerometer data
    zData = zeros(1,sampleNumber); %Empty array for the z accelerometer data
    pitchAng = zeros(1,sampleNumber); %Empty array for the pitch angle data
    rollAng = zeros(1,sampleNumber); %Empty array for the roll angle data
    yawAng = zeros(1,sampleNumber); %Empty array for the yaw angle data
    pitchRate = zeros(1,sampleNumber); %Empty array for the pitch rate data
    rollRate = zeros(1,sampleNumber); %Empty array for the roll rate data
    yawRate = zeros(1,sampleNumber); %Empty array for the yaw rate data
    
    
    %function to save the parameters to the mbed board
function saveParams_Callback(hObject, eventdata, handles)

N = getappdata(0,'sampleNumber'); %retrieve the sample number as inputted by the user
T = getappdata(0,'sampleTime'); %retrieve the sample rate as inputted by the user

mbedDrive = getappdata(0,'mbedDrive'); %retrieve the user inputted drive location

try %error checking on user input
    if(T<=0) %if inputted rate is less than or equal to 0, throw error, as it is not possible to have such a rate
        throw(MException('settings:SmpleTme:negative','Sample time has been set less or equal to 0'))
    else
        if (T>10) %if inputted rate is greater than 10s, throw error, as this has been defined as too great
            throw(MException('settings:SmpleTme:big','Sample time has been set greater 10'))
        end
    end
    if(N<=0) %if inputted number is less than or equal to 0, throw error, as it is not possible to have a negative number of samples
        throw(MException('settings:SmpleNo:negative','Sample Number set less than or equal to 0'))
    else
        if isreal(N)==0 || rem(N,1)~=0 %if inputted number is not real or not an integer, throw error, as the sample number must be a real integer
            throw(MException('settings:SmpleNo:nonint','sample Number has been set as non real or non integer'))
        end
    end
    filename = strcat(mbedDrive,':\settings.txt'); %set the file name as "settings.txt" in the mbed drive, i.e. saving it to the mbed
    settingsFile = fopen(filename,'w'); %open the settings file in the drive
    fprintf(settingsFile,'%d %f',N,T); %print the sample number, then the sample rate in the settings.txt file
    fclose(settingsFile); %close the file
catch ME
    if strcmp(ME.identifier,'MATLAB:FileIO:InvalidFid') %display error if the file location is invalid
       msgbox({'Unable to save to mbed settings file due to invalid file location','please make sure you have  got the Mbed plugged in and set to the correct drive in Mbed settings'},'Error','error')
    end
    if strcmp(ME.identifier,'MATLAB:fopen:InvalidCharacter') %display error if the file contains an invalid character, or a setting is empty
    msgbox({'Unable to save to mbed settings file due to invalid character or empty setting for MBED drive','please make sure you have set the correctly set the mbed drive under mbed settings to a single letter that the mbed drive is in'},'Error','error')
    end
    if strcmp(ME.identifier,'settings:SmpleTme:negative') %display error if sample time is less than or equal to 0
       msgbox({'Sample time cannot be less than or equal to 0','please change the value and try again'},'Error','error')
    end
    if strcmp(ME.identifier,'settings:SmpleTme:big') %display error if sample time is greater than 10s
       msgbox({'Sample time cannot be greater than 10','please change the value and try again'},'Error','error')
    end
    if strcmp(ME.identifier,'settings:SmpleNo:negative') %display error if sample number is less than or equal to 0
       msgbox({'Sample Number cannot be less than or equal to 0','please change the value and try again'},'Error','error')
    end
    if strcmp(ME.identifier,'settings:SmpleNo:nonint') %display error if sample number is not a real integer
        msgbox({'Sample number must be a real Integer','please change the value and try again'},'Error','error')
    end    
    return
end

%function to get the sample time and sample number from the mbed
function [sampleNumber, sampleTime]= getSettings(mbedDrive) 
           
    mbedDrive = getappdata(handles.mbedSettings,'mbedDrive'); %get the settings file from the mbed
            try 
            filename=strcat(mbedDrive,':\settings.txt'); %set the file name to be the path of the settings file
            settingsFile = fopen(filename,'r');  %open the settings file
            catch  %if cannot find the settings file, display error message as below
                msgbox({'Could not access the settings file in the MBED', 'Please ensure the MBED is plugged in and set to the correct drive in MBED Settings'},'Error', 'error') 
            end 
            sampleNumber=fscanf(settingsFile,'%s'); %scan the settings file to get the sample number and set as the new value 
            sampleTime=fscanf(settingsFile,'%s'); %scan the settings file to get the sample rate and set as the new value
            fclose(settingsFile); %close the settings file

%function to perform data capture using the accelerometer and the mbed board
function captureData_Callback(hObject, eventdata, handles)  
    
set(handles.captureData,'string','Press MBED Button'); %sets button to say "Press MBED Button"
drawnow %changes button to display properly

    global timeData %intialise data arrays for capture, inc. time, x, y, z accelerometer data, and pitch, roll and yaw angles
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng    
    
sampleNumber = getappdata(0,'sampleNumber'); %set the inputted sample number
sampleTime = getappdata(0,'sampleTime'); %set the inputted sample time

checkArray(sampleNumber); %check if arrays need to be initialised with new sample number

comPort = getappdata(0,'comPort'); %set the COM port as inputted

    try
        s = serial(strcat('COM',comPort)); %set the serial communications name as the COM port
        fopen(s); %open serial communications through the named COM port
    catch %if unable to connect, display error message
        msgbox('Unable to connect to the MBED - please check the MBED is using the correct COM port in MBED Settings, restart matlab and try again','Error','error');
    end    
    
i=1; %index variable initialised
radConv = 180/pi; %formula for converting from radians to degrees
    while (i<=sampleNumber) %while loop to iterate through 
        x = str2num(fscanf(s)); %get first string value through from serial comms and convert to number, set it as variable "x"
        if(i==1) %if on the first iteration loop
            set(handles.captureData,'string','Data Capture has begun'); %sets button to confirm data capture has begun
            drawnow %change figure so it displays properly
        end
        xData(i) = x; %set the value of the indexed location of the X data array to be the value of variable "x"
        y = str2num(fscanf(s)); %get second string value through from serial comms and convert to number, set it as variable "y"
        yData(i) = y; %set the value of the indexed location of the Y data array to be the value of variable "y"
        z = str2num(fscanf(s)); %get third string value through from serial comms and convert to number, set it as variable "z"
        zData(i) = z; %set the value of the indexed location of the Z data array to be the value of variable "z"
        pitchAng(i) = atan2(y,sqrt(z^2+x^2))*radConv % calculate the Y angle pitch using collected data and add to its array at the indexed location
        rollAng(i) = atan2(x,sqrt(z^2+y^2))*radConv % calculate the X angle roll using collected data and add to its array at the indexed location
        yawAng(i) = atan2(z,sqrt(x^2+y^2))*radConv % calculate the Z angle yaw using collected data and add to its array at the indexed location
        timeData(i)=i*sampleTime; %calculate the time and add to its array at the indexed location
        i=i+1; %add 1 to the index variable so iteration loops through next data points
    end
fclose(s); %close serial communications
rateCalculations; %run the rateCalculations function
set(handles.captureData,'string','Data Captured!'); %display message to say data has been captured
pause(4) %pause to allow time for updating
set(handles.captureData,'string','Ready to Capture Data'); %display message to say data is ready to be captured


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
        domName = 'Time';

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
            domName = 'Frequency';
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
    
    plot2d(domArr,angArr,strcat(name,' Angle Against ',domName),domName,strcat(name,' Angle'));
    
else
    
        if domain == 'timeDomain'


        if strcmp(ang2,'roll3d')
            angArr2 = rollAng;
            name = 'Roll';
        else
        if strcmp(ang2,'pitch3d')
            angArr2 = pitchAng;
            name = 'Pitch';
        else
        if strcmp(ang2,'yaw3d')
            angArr2 = yawAng;
            name = 'Yaw';
        end
        end
        end

    else
        if domain == 'freqDomain'
            domArr = freqData;
            
            if strcmp(ang2,'roll3d')
                angArr2 = plotxfft;
                name = 'Roll';
            else
            if strcmp(ang2,'pitch3d')
                angArr2 = plotyfft;
                name = 'Pitch';
            else
            if strcmp(ang2,'yaw3d')
                angArr2 = plotzfft;
                name = 'Yaw';
            end
            end
            end
        end
        end
    
    plot3d(domArr,angArr,angArr2,strcat(name,' Angle Against ',domName),domName,strcat(name,' Angle'),'zlbl');
        
end
   



            
    
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

    mbedDrive = getappdata(0,'mbedDrive');
    [sampleNumber, sampleTime] = getSettings(mbedDrive);
    
    global pitchAng
    global rollAng
    global yawAng
    global pitchRate
    global rollRate
    global yawRate
    
    
    i=0;

    while i<sampleNumber
    absSumPitchAng = absSumPitchAng+abs(pitchAng(i));
    absSumRollAng = absSumRollAng+abs(rollAng(i));
    absSumYawAng = absSumYawAng+abs(yawAng(i));
    absSumpitchRate = absSumpitchRate+abs(pitchRate(i));
    absSumrollRate = absSumrollRate+abs(rollRate(i));
    absSumyawRate = absSumyawRate+abs(yawRate(i));
    sumSquaredPitchAng = sumSquaredPitchAng+(pitchAng(i))^2;
    sumSquaredRollAng = sumSquaredRollAng+(rollAng(i))^2;
    sumSquaredYawAng = sumSquaredYawAng+(yawAng(i))^2;
    sumSquaredpitchRate = sumSquaredpitchRate+(pitchRate(i))^2;
    sumSquaredrollRate = sumSquaredrollRate+(rollRate(i))^2;
    sumSquaredyawRate = sumSquaredyawRate+(yawRate(i))^2;

    i=i+1;

    end

    meanPitchAng = sum(pitchAng)/sampleNumber;
    meanRollAng = sum(rollAng)/sampleNumber;
    meanYawAng = sum(yawAng)/sampleNumber;
    meanpitchRate = sum(pitchRate)/sampleNumber;
    meanrollRate = sum(rollRate)/sampleNumber;
    meanyawRate = sum(yawRate)/sampleNumber;

    absMeanPitchAng = absSumPitchAng/sampleNumber;
    absMeanRollAng = absSumRollAng/sampleNumber;
    absMeanYawAng = absSumYawAng/sampleNumber;
    absMeanpitchRate = absSumpitchRate/sampleNumber;
    absMeanrollRate = absSumrollRate/sampleNumber;
    absMeanyawRate = absSumyawRate/sampleNumber;

    rMSPitchAng = sqrt(sumSquaredPitchAng/sampleNumber);
    rMSRollAng = sqrt(sumSquaredRollAng/sampleNumber);
    rMSYawAng = sqrt(sumSquaredYawAng/sampleNumber);
    rMSpitchRate = sqrt(sumSquaredpitchRate/sampleNumber);
    rMSrollRate = sqrt(sumSquaredrollRate/sampleNumber);
    rMSyawRate = sqrt(sumSquaredyawRate/sampleNumber);


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
