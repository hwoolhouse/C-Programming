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

% Last Modified by GUIDE v2.5 05-Nov-2017 23:20:55

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
    global pitchVel
    global rollVel
    global yawVel
    global pitchAcc
    global rollAcc
    global yawAcc
    
    %Arrays initialised for X, Y and Z Data, Roll, Pitch and Yaw Angle,
    %Velocity and Acceleration
    timeData = zeros(1,sampleNumber);
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
    

    
function captureData_Callback(hObject, eventdata, handles)

    global timeData
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng
    
sampleNumber = getappdata(0,'sampleNumber');
sampleRate = getappdata(0,'sampleRate');

checkArray(sampleNumber);

set(handles.captureData,'string','Press MBED Button');


try
    set(handles.captureData,'string','Press MBED Button');
    s = serial('COM3');
    fopen(s);
catch
    msgbox('Unable to connect to the MBED, please check the MBED is using COM4:, restart MATLAB and try again','Error','error');
end

i=1;
    radConv = 180/pi;
    while (i<sampleNumber)
        if(i==2)
            set(handles.captureData,'string','Data Capture has begun');
        end
        x = str2num(fscanf(s));
        xData(i) = x;
        y = str2num(fscanf(s));
        yData(i) = y;
        z = str2num(fscanf(s));
        zData(i) = z;
        pitchAng(i) = atan(y/(sqrt(z^2+x^2))*radConv); % Y angle pitch
        rollAng(i) = atan(x/(sqrt(z^2+y^2))*radConv); % X angle roll
        yawAng(i) = atan(z/(sqrt(x^2+y^2))*radConv); % Z angle yaw
        timeData(i)=i*sampleRate;
        i=i+1;
    end
fclose(s);
%velAccCalculations;
set(handles.captureData,'string','Data Captured!');
pause(3)
set(handles.captureData,'string','Ready to Capture Data');


function plotData_Callback(hObject, eventdata, handles)

    N = getappdata(0,'sampleNumber');
    R = getappdata(0,'sampleRate');
    
    global timeData
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng
    global pitchVel
    global rollVel
    global yawVel
    global pitchAcc
    global rollAcc
    global yawAcc
    
    L = R*N;
    Fs = 1/R;
    xfft = fft(xData);
    yfft = fft(yData);
    
    f = Fs*(0:(L/2))/L;
    Py2 = abs(yfft/L);
    Py1 = Py2(1:L/2+1);
    Py1(2:end-1) = 2*Py1(2:end-1);
    Px2 = abs(xfft/L);
    Px1 = Px2(1:L/2+1);
    Px1(2:end-1) = 2*Px1(2:end-1);
    
    timeDomain = get(handles.timeDomain,'value');
    freqDomain = get(handles.freqDomain,'value');
    dispRoll = get(handles.dispRoll,'value');
    dispPitch = get(handles.dispPitch,'value');
    dispYaw = get(handles.dispYaw,'value');
    
    axes(handles.axes);
    
    for timeDomain = 1
        
        for dispRoll = 1
            plot(timeData,rollAng); % X axis is time, Y axis is roll angle
                     title('Roll angle against Time');
                     xlabel('Time');
                     ylabel('Roll Angle');
                     grid on;
        end
        for dispPitch = 1
            plot(timeData,pitchAng); % X axis is time, Y axis is pitch angle
                     title('Pitch angle against Time');
                     xlabel('Time');
                     ylabel('Pitch Angle');
                     grid on;
        end
        for dispYaw = 1
            plot(timeData,yawAng); % X axis is time, Y axis is pitch angle
                     title('Pitch angle against Time');
                     xlabel('Time');
                     ylabel('Pitch Angle');
                     grid on;
        end
            
    end
    
    for freqDomain = 1
        
        for dispRoll = 1
            plot(f,Px1);
            title('Amplitude Spectrum against Frequency');
            xlabel('Frequency (Hz)');
            ylabel('Amplitude Spectrum');
            grid on;
        end
        for dispPitch = 1
            plot(f,Py1);
            title('Amplitude Spectrum against Frequency');
            xlabel('Frequency (Hz)');
            ylabel('Amplitude Spectrum');
            grid on;
        end  
    end
        
        
        
        

    
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
    %sampleRate = dataSet(2,1)-dataSet(1,1);

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
        timeData(i)=dataSet(i,1)
        xData(i)= dataSet(i,2)
        yData(i)= dataSet(i,3)
        zData(i)= dataSet(i,4)
        pitchAng(i) = atan(yData(i)/(sqrt(zData(i)^2+xData(i)^2))*radConv) % Y angle pitch
        rollAng(i) = atan(xData(i)/(sqrt(zData(i)^2+yData(i)^2))*radConv) % X angle roll
        yawAng(i) = atan(zData(i)/(sqrt(xData(i)^2+yData(i)^2))*radConv) % Z angle yaw
        i=i+1
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
setappdata(0,'sampleNumber',sampleNumber)
set(handles.sampleNumber, 'String', num2str(sampleNumber));


function sampleRate_Callback(hObject, eventdata, handles)

sampleRate = str2num(get(handles.sampleRate, 'String'));
setappdata(0,'sampleRate',sampleRate)
set(handles.sampleRate, 'String', num2str(sampleRate));


function saveParams_Callback(hObject, eventdata, handles)
N = getappdata(0,'sampleNumber');
R = getappdata(0,'sampleRate');
try
    fileID = fopen('settings.txt','w');
    fprintf(fileID,'%d %f',N,R);
    fclose(fileID);
catch
    msgbox('Unable to write to mbed settings file, please check mbed is connected as drive E:, containing a file called settings.txt and try again','Error','error');
end


function velAccCalculations

sampleNumber = getappdata(0,'sampleNumber');

    global pitchVel
    global rollVel
    global yawVel
    global pitchAcc
    global rollAcc
    global yawAcc

    i = 1;
    
    while (i<sampleNumber)
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
    while (i<sampleNumber-1)
        pitchAcc(i)= pitchVel(i)-pitchVel(i+1);
        rollAcc(i)= rollVel(i)-rollVel(i+1);
        yawAcc(i)= yawVel(i)-yawVel(i+1);
        i=i+1;
    end

    

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


function sampleRate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
