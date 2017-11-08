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
    
    % Using global varibles for arrays because using the gui means we dont run all the functions in a specific order but they can still all access these arrays
    global timeData
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng
    
    %arrays are filled with zeros up to the size of the number of samples
    timeData = zeros(1,sampleNumber);
    xData = zeros(1,sampleNumber);
    yData = zeros(1,sampleNumber);
    zData = zeros(1,sampleNumber);
    pitchAng = zeros(1,sampleNumber);
    rollAng = zeros(1,sampleNumber);
    yawAng = zeros(1,sampleNumber);
    
    
function saveParams_Callback(hObject, eventdata, handles)
    %this function saves the sample time period and number set in the gui to the settings file on the mbed board
    
    %Get the inputted sample number rate and mbed drive from the gui
    N = getappdata(0,'sampleNumber');
    T = getappdata(0,'sampleTime');
    mbedDrive = getappdata(0,'mbedDrive');
    
    try
        %Custom error exceptions are thrown if the user tries to set the
        %parameters to incorrect values
        if(T<=0) %not possible to have time period less than 1
            throw(MException('settings:SmpleTme:negative','Sample time has been set less or equal to 0'))
        else
            if (T>10) %If sample time is greater than 10, matlab would timeout on fscanf
                throw(MException('settings:SmpleTme:big','Sample time has been set greater 10'))
            end
        end
        if(N<=1)
            throw(MException('settings:SmpleNo:less1','Sample Number set less than or equal to 1'))
        else
            if isreal(N)==0 || rem(N,1)~=0 %sample number must be a real integer
                throw(MException('settings:SmpleNo:nonint','sample Number has been set as non real or non integer'))
            end
        end
        filename = strcat(mbedDrive,':\settings.txt');
        settingsFile = fopen(filename,'w');
        fprintf(settingsFile,'%d %f',N,T);
        fclose(settingsFile);
    catch ME %errors (custom and matlab) thrown within the try block are caught and dealt with here,
        %the errors are identified and give the user detailed popup errors
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
        if strcmp(ME.identifier,'settings:SmpleNo:less1')
            msgbox({'Sample Number cannot be less than or equal to 1','please change the value and try again'},'Error','error')
        end
        if strcmp(ME.identifier,'settings:SmpleNo:nonint')
            msgbox({'Sample number must be a real Integer','please change the value and try again'},'Error','error')
        end
        return
    end
    
    
function [sampleNumber, sampleTime]= getSettings
    %function to get the sample time and sample number from the mbed
    %settings file
    
    try
        mbedDrive = getappdata(0,'mbedDrive');
        
        filename=strcat(mbedDrive,':\settings.txt'); %letter of mbed drive is combined with string of rest of path to give full path to file
        settingsFile = fopen(filename,'r') ;
        settingsArray=fscanf(settingsFile,'%d%f'); %the two numbers (which are seperated by a space) are read into a matlab array
        %array split into seprate variables for each parameter then
        %settings file is closed
        sampleNumber=settingsArray(1);
        sampleTime=settingsArray(2);
        fclose(settingsFile);
        
    catch ME %error catching for if the settings file couldn't be found
        if strcmp(ME.identifier,'MATLAB:FileIO:InvalidFid')
            msgbox({'Unable to save to mbed settings file due to invalid file location','please make sure you have  got the Mbed plugged in and set to the correct drive in Mbed settings', 'please ensure you have saved the sampling parameters'},'Error','error')
        end
        if strcmp(ME.identifier,'MATLAB:fopen:InvalidCharacter')
            msgbox({'Unable to save to mbed settings file due to invalid character or empty setting for MBED drive','please make sure you have set the correctly set the mbed drive under mbed settings to a single letter that the mbed drive is in'},'Error','error')
        end
    end
    
    
function captureData_Callback(hObject, eventdata, handles)
    %function to perform data capture using the accelerometer and the mbed board
    %Data is only captured if the mbed rest button is pressed when prompted
    set(handles.captureData,'string','Press MBED Button');
    drawnow %the text on the button is updated and gui refreshed with drawnow
    
    global timeData
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng
    try %call getSettings to read the values stored in the settings file
        [sampleNumber, sampleTime]= getSettings;
    catch ME %if an error thrown in the function means outputs of the function are not recieved this catches that error
        if strcmp(ME.identifier,'MATLAB:unassignedOutputs')
            msgbox({'Unable to read mbed settings file' ,'Data capture aborted','Ensure you have correctly saved both mbed and sampling settings and try again'},'Error','error');
            return
        end
    end
    
    checkArray(sampleNumber); %The arrays are checked to see if they need to be re-initialized
    
    comPort = getappdata(0,'comPort');
    try
        s = serial(strcat('COM',comPort)); %connect by serial to the com port of the mbed
        fopen(s);
    catch ME
        if strcmp(ME.identifier,'MATLAB:serial:fopen:opfailed') %if the com port fails to open the user is informed of options to fix this
            msgbox({'Unable to connect to MBED serial port - Data capture aborted','Ensure you have connected the Mbed and set it to the correct port in settings, restart matlab and try again'},'Error','error');
            return
        end
    end
    
    i=1;
    radConv = 180/pi;
    try
        while (i<=sampleNumber)
            %The data sent by the mbed is read using fscanf, and as the
            %data is always sent in the same format with x first then y on
            %a new line and so on,  this code will save them as the correct variable
            x = str2double(fscanf(s)); %data is read as a string then converted to a number using str2double
            if(i==1)
                % Once data capture has sucessfully begun (x is now captured) string on button changes so user does not think they still need to press the mbed button
                set(handles.captureData,'string','Data Capture has begun');
                drawnow
            end
            xData(i) = x; %save the current value of x acceleration into an array
            y = str2double(fscanf(s));
            yData(i) = y;
            z = str2double(fscanf(s));
            zData(i) = z;
            %pitch, roll and yaw angles are calculated and stored into
            %arrays. This is done in matlab rather than c so the mbed has
            %to do as little processing as possible
            pitchAng(i) = atan2(y,sqrt(z^2+x^2))*radConv;
            rollAng(i) = atan2(x,sqrt(z^2+y^2))*radConv;
            yawAng(i) = atan2(z,sqrt(x^2+y^2))*radConv;
            timeData(i)=i*sampleTime; %the time of the sample from starting capture is calculated using sample time
            i=i+1;
        end
    catch ME %if fscanf is unable to read data the user is sent an error message
        if strcmp(ME.identifier,'MATLAB:serial:fscanf:opfailed')
            msgbox({'Unable to collect readings - Data capture aborted','Ensure the Mbed is still connected and try again'},'Error','error');
            fclose(s); %serial connection is closed so problems are not caused when it is opened again
            return;
        end
        
    end
    fclose(s);
    set(handles.captureData,'string','Data Captured!');
    pause(4)  %button chages to show completion for 4 seconds then returns to being capture data
    set(handles.captureData,'string','Capture Data');
    
    
function plotData_Callback(hObject, eventdata, handles)
    %This function allows graphs to be plotted in frequency and time
    %domains. Graphs can also be plotted in 3d using mutiple angles
    
    set(handles.dataTable,'visible','off'); %hides the table if it has been open
    set(handles.analyseData,'value',0); %and unchecks box that displays table
    
    global timeData %initialise global arrays so they can be plotted
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng
    
    %Sample number and time period are found using the length of the arrays
    %and differnce between the fist 2 time values. We do not use the values
    %typed into the box or stored on the settings file incase the user is
    %using loaded previously captured data with diffent paramters
    N=length(timeData);
    T=timeData(2)-timeData(1);
    
    L = T*N; %set variable L to be the total length of data capture
    %perform the fast fourier transforms to convert data into frequency
    %amplitude spectrums
    xfft = fft(xData);
    yfft = fft(yData);
    zfft = fft(zData);
    
    plotxfft = abs(xfft/L); %set the data to be graphed as the absolute of the X fft data divided by the total test time
    plotyfft = abs(yfft/L);
    plotzfft = abs(zfft/L);
    
    
    setappdata(0,'rollFFT',plotxfft);
    setappdata(0,'pitchFFT',plotyfft);
    setappdata(0,'yawFFT',plotzfft);
    freqData = (0:length(xfft)-1)*T/length(xfft); %populate the frequency data array
    
    a = get(handles.xyzGroup,'SelectedObject'); %get the selected button pressed by user in relation to roll pitch or yaw angles
    ang = get(a,'tag'); %get the tag of the selected button to identify it
    
    dom = get(handles.timeGroup,'SelectedObject'); %as above for identifying selction of time or frequency domain
    domain = get(dom,'tag');
    
    show3d = get(handles.show3d,'value'); %get value if user has selected the graph to be 3D
    
    a2 = get(handles.panel3D,'SelectedObject'); %gets the value of the selected button in the z axis panel
    ang2 = get(a2,'tag');
    
    %the selections for which variables to plot are found using ifs and
    %varibles are set to be used in a function to plot the graph. this
    %reduces the amount of repeated code as the plot and axis titles etc
    %don't need to be under every possible combination of axis, they are
    %just combined using the plot2d or plot3d function
    if strcmp(domain,'timeDomain')
        domArr = timeData;
        domName = 'Time'; %this is needed for the graph title and axis labels
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
        if strcmp(domain,'freqDomain')
            domArr = freqData;
            domName = 'Frequency';
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
        %plot the graph of the set domain and the set angle data, titled in relation to both
        plot2d(domArr,angArr,strcat(name,titleType,' Against ',domName),domName,strcat(name,'titleType'));
        
    else  %if the graph is set to be 3D
        
        if strcmp(domain,'timeDomain')
            
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
            if strcmp(domain,'freqDomain')
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
        %plot the 3D graph of the domain array against the two angle arrays as set, and titled accordingly
        plot3d(domArr,angArr,angArr2,strcat(name,' Against',name2,titleType,' Against',domName),domName,strcat(name,titleType),strcat(name2,titleType));
        
    end
    
    
    [peakAmpRoll,p2pAmpRoll,meanAmpRoll,rmsAmpRoll,peakFreRoll,p2pFreRoll,meanFreRoll,rmsFreRoll,peakAmpPitch,p2pAmpPitch,meanAmpPitch,rmsAmpPitch,peakFrePitch,p2pFrePitch,meanFrePitch,rmsFrePitch,peakAmpYaw,p2pAmpYaw,meanAmpYaw,rmsAmpYaw,peakFreYaw,p2pFreYaw,meanFreYaw,rmsFreYaw] = timeStatistics;
    %Get the values of useful statistics from timeStatistics functiom
    %the below code gets a copy of the table from the gui and adds all the varibles
    %for each statistic into it's respectve cell in the table, then sets
    %the gui table to these stats
    tab = get(handles.dataTable,'Data');
    
    tab(1,1) = num2cell(peakAmpRoll);
    tab(1,2) = num2cell(peakAmpPitch);
    tab(1,3) = num2cell(peakAmpYaw);
    
    tab(2,1) = num2cell(p2pAmpRoll);
    tab(2,2) = num2cell(p2pAmpPitch);
    tab(2,3) = num2cell(p2pAmpYaw);
    
    tab(3,1) = num2cell(meanAmpRoll);
    tab(3,2) = num2cell(meanAmpPitch);
    tab(3,3) = num2cell(meanAmpYaw);
    
    tab(4,1) = num2cell(rmsAmpRoll);
    tab(4,2) = num2cell(rmsAmpPitch);
    tab(4,3) = num2cell(rmsAmpYaw);
    
    tab(5,1) = num2cell(peakFreRoll);
    tab(5,2) = num2cell(peakFrePitch);
    tab(5,3) = num2cell(peakFreYaw);
    
    tab(6,1) = num2cell(p2pFreRoll);
    tab(6,2) = num2cell(p2pFrePitch);
    tab(6,3) = num2cell(p2pFreYaw);
    
    tab(7,1) = num2cell(meanFreRoll);
    tab(7,2) = num2cell(meanFrePitch);
    tab(7,3) = num2cell(meanFreYaw);
    
    tab(8,1) = num2cell(rmsFreRoll);
    tab(8,2) = num2cell(rmsFrePitch);
    tab(8,3) = num2cell(rmsFreYaw);
    
    set(handles.dataTable,'Data',tab);
    
    
    
    
    
    
function plot2d (xAxis,yAxis,grphTitle,xLbl,yLbl)
    %function to plot in 2D, having been given data to plot, the title, and the names of the data to plot
    plot(xAxis,yAxis);
    title(grphTitle);
    xlabel(xLbl);
    ylabel(yLbl);
    grid on; %display the grid
    
    
function plot3d (xAxis,yAxis,zAxis,grphTitle,xLbl,yLbl,zLbl)
    %function to plot in 3D, having been given data to plot, the title, and the names of the data to plot
    plot3(xAxis,yAxis,zAxis); % X axis is domain, Y axis is selected angle, Z axis is 2nd selected angle
    title(grphTitle);
    xlabel(xLbl);
    ylabel(yLbl);
    zlabel(zLbl);
    grid on; %display the grid
    
    
    
    
    
    
function timeDomain_Callback(hObject, eventdata, handles) %time domain radio button
    
function freqDomain_Callback(hObject, eventdata, handles) %frequency domain radio button
    
function dispRoll_Callback(hObject, eventdata, handles) %roll angle radio button
    
function dispPitch_Callback(hObject, eventdata, handles) %pitch angle radio button
    
function dispYaw_Callback(hObject, eventdata, handles) %yaw angle radio button
    
    
    
function saveData_Callback(hObject, eventdata, handles)
    %function to save data to file
    global timeData
    global xData
    global yData
    global zData
    %Creates a table out of x, y and z data which is then saved in a location
    %chosen by the user using a user interace file explorer box
    T = table(timeData.',xData.',yData.',zData.','VariableNames',{'Time','Raw_X_Values','Raw_Y_Values','Raw_Z_Values'});
    [file,path,FilterIndex] = uiputfile('*.csv','Save Table As: ');
    if(FilterIndex~=0) %If filter index is 0 the user has clicked cancel
        writetable(T,strcat(path,file));
    else
        msgbox('Saving data cancelled by user','Cancelled','warn');
    end
    
    
    
function loadData_Callback(hObject, eventdata, handles)
    %Function to load previously captured data from a csv file. Data was
    %saved as raw x, y and z values and pitch, roll and yaw are recalculated here.
    try
        [file,path,FilterIndex] = uigetfile('*.csv','Load: ');
        if(FilterIndex==0)
            msgbox('Loading data cancelled by user','Cancelled','warn');
            return;
        end
        T1 = readtable(strcat(path,file)); %read data from .csv file as specified into a table
        dataSet = table2array(T1); %convert table into array
        sampleNumber = height(T1); %calculate sample number from number of entries in array height
        
    catch ME %Catch an error if the user tried to selected a non csv file
        if strcmp(ME.identifier,'MATLAB:readtable:UnrecognizedFileExtension')
            msgbox({'Please only attempt to load a .csv file', 'data has not been loaded'},'Error','error')
        end
    end
    
    global timeData
    global xData
    global yData
    global zData
    global pitchAng
    global rollAng
    global yawAng
    checkArray(sampleNumber);  %check that arrays don't need to be resized
    i=1;
    radConv = 180/pi;
    while i<=sampleNumber
        timeData(i)=dataSet(i,1);  %read each row and column and set as an indexed point in the data arrays
        xData(i)= dataSet(i,2);
        yData(i)= dataSet(i,3);
        zData(i)= dataSet(i,4);
        pitchAng(i) = atan2(yData(i),sqrt(zData(i)^2+xData(i)^2))*radConv; % Y angle pitch calc
        rollAng(i) = atan2(xData(i),sqrt(zData(i)^2+yData(i)^2))*radConv; % X angle roll calc
        yawAng(i) = atan2(zData(i),sqrt(xData(i)^2+yData(i)^2))*radConv; % Z angle roll calc
        i=i+1;
    end
    
    
function checkArray(sampleNumber)
    %function to check if arrays need to be resized or if they are already
    %the correct size and can just be overwritten
    global timeData;
    created = exist('timeData', 'var'); %check if time data array exists and is the right size
    arraySize = length(timeData);
    
    if (created == 0)
        initialiseArrays(sampleNumber);
    else
        if(arraySize~=sampleNumber)
            initialiseArrays(sampleNumber);  %if the size of the array does not equal the number of samples, the array is initialized
        end
    end
    
    
    
    
    
function sampleNumber_Callback(hObject, eventdata, handles)
    
    sampleNumber = str2double(get(handles.sampleNumber, 'String'));
    setappdata(0,'sampleNumber',sampleNumber);
    set(handles.sampleNumber, 'String', num2str(sampleNumber));
    %function for the sample number setting
    
function sampleTime_Callback(hObject, eventdata, handles)
    %function for the sample time setting
    sampleTime = str2double(get(handles.sampleTime, 'String'));
    setappdata(0,'sampleTime',sampleTime);
    set(handles.sampleTime, 'String', num2str(sampleTime));
    
    
function mbedSettings_Callback(hObject, eventdata, handles)
    %function for the mbed settings panel
    a = get(hObject,'Value');
    %If the mbed settings toggle button is switched off, the mbed settings
    %area becomes hidden
    if a == 1
        set(handles.mbedSettingsPanel,'visible','on');
        set(handles.saveMbed,'visible','on');
        set(hObject,'string','Hide MBED Settings');
    else
        set(handles.mbedSettingsPanel,'visible','off');
        set(handles.saveMbed,'visible','off');
        set(hObject,'string','Show MBED Settings');
    end
    
function comPort_Callback(hObject, eventdata, handles) %callback for the user COM Port entry
    comPort = get(handles.comPort,'String');
    setappdata(0,'comPort',comPort);
    
function mbedDrive_Callback(hObject, eventdata, handles) %callback for the user mbed drive entry
    mbedDrive = (get(handles.mbedDrive,'String'));
    setappdata(0,'mbedDrive',mbedDrive);
    
function saveMbed_Callback(hObject, eventdata, handles) %button for saving com port and mbed drive info
    
    comPort = getappdata(0,'comPort');
    mbedDrive = getappdata(0,'mbedDrive');
    
    set(handles.saveMbed,'string','Saved!');
    pause(2) %delay so user can see it has been saved before revertng back to the original button
    set(handles.saveMbed,'string','Save');
    
    
    
function show3d_Callback(hObject, eventdata, handles) %callback for the show 3d checkbox
    a = get(hObject,'Value');
    if a == 1
        set(handles.panel3D,'visible','on')
    else
        set(handles.panel3D,'visible','off')
    end
function analyseData_Callback(hObject, eventdata, handles) %callback for the analyse data checkbox
    a = get(hObject,'Value');
    if a == 1
        set(handles.dataTable,'visible','on');
        set(handles.axes,'visible','off');
    else
        set(handles.dataTable,'visible','off');
        set(handles.axes,'visible','on');
    end
    
function dataTable_CreateFcn(hObject, eventdata, handles)
    
    
function [peakAmpRoll,p2pAmpRoll,meanAmpRoll,rmsAmpRoll,peakFreRoll,p2pFreRoll,meanFreRoll,rmsFreRoll,peakAmpPitch,p2pAmpPitch,meanAmpPitch,rmsAmpPitch,peakFrePitch,p2pFrePitch,meanFrePitch,rmsFrePitch,peakAmpYaw,p2pAmpYaw,meanAmpYaw,rmsAmpYaw,peakFreYaw,p2pFreYaw,meanFreYaw,rmsFreYaw]=timeStatistics
    %function to calculate useful statistics
    
    global pitchAng
    global rollAng
    global yawAng
    
    rollFFT = getappdata(0,'rollFFT');
    pitchFFT = getappdata(0,'pitchFFT');
    yawFFT = getappdata(0,'yawFFT');
    
    maxAmpRoll = gt(abs(max(rollAng)),abs(min(rollAng)));
    if maxAmpRoll == 1
        peakAmpRoll = max(rollAng);
    else
        peakAmpRoll = min(rollAng);   %this returns the signed max absolute value
    end
    p2pAmpRoll = peak2peak(rollAng);
    meanAmpRoll = mean(rollAng);
    rmsAmpRoll = rms(rollAng);
    
    maxFreRoll = gt(abs(max(rollFFT)),abs(min(rollFFT)));
    if maxFreRoll == 1
        peakFreRoll = max(rollFFT);
    else
        peakFreRoll = min(rollFFT);
    end
    p2pFreRoll = peak2peak(rollFFT);
    meanFreRoll = mean(rollFFT);
    rmsFreRoll = rms(rollFFT);
    
    
    maxAmpPitch = gt(abs(max(pitchAng)),abs(min(pitchAng)));
    if maxAmpPitch == 1
        peakAmpPitch = max(pitchAng);
    else
        peakAmpPitch = min(pitchAng);
    end
    p2pAmpPitch = peak2peak(pitchAng);
    meanAmpPitch = mean(pitchAng);
    rmsAmpPitch = rms(pitchAng);
    
    maxFrePitch = gt(abs(max(pitchFFT)),abs(min(pitchFFT)));
    if maxFrePitch == 1
        peakFrePitch = max(pitchFFT);
    else
        peakFrePitch = min(pitchFFT);
    end
    p2pFrePitch = peak2peak(pitchFFT);
    meanFrePitch = mean(pitchFFT);
    rmsFrePitch = rms(pitchFFT);
    
    
    maxAmpYaw = gt(abs(max(yawAng)),abs(min(yawAng)));
    if maxAmpYaw == 1
        peakAmpYaw = max(yawAng);
    else
        peakAmpYaw = min(yawAng);
    end
    p2pAmpYaw = peak2peak(yawAng);
    meanAmpYaw = mean(yawAng);
    rmsAmpYaw = rms(yawAng);
    
    maxFreYaw = gt(abs(max(yawFFT)),abs(min(yawFFT)));
    if maxFreYaw == 1
        peakFreYaw = max(yawFFT);
    else
        peakFreYaw = min(yawFFT);
    end
    p2pFreYaw = peak2peak(yawFFT);
    meanFreYaw = mean(yawFFT);
    rmsFreYaw = rms(yawFFT);
    
    
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
