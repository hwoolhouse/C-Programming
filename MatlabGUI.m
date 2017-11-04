function varargout = untitled1(varargin)
% UNTITLED1 MATLAB code for untitled1.fig
%      UNTITLED1, by itself, creates a new UNTITLED1 or raises the existing
%      singleton*.
%
%      H = UNTITLED1 returns the handle to a new UNTITLED1 or the handle to
%      the existing singleton*.
%
%      UNTITLED1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED1.M with the given input arguments.
%
%      UNTITLED1('Property','Value',...) creates a new UNTITLED1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled1

% Last Modified by GUIDE v2.5 04-Nov-2017 16:40:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @end_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled1_OutputFcn, ...
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

end

% --- Executes just before MatlabGUI is made visible.
function end_OpeningFcn(hObject, eventdata, handles, varargin)

% DEFAULT FUNCTION

% Choose default command line output for untitled1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = untitled1_OutputFcn(hObject, eventdata, handles) 

% DEFAULT FUNCTION

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% All default auto generated stuff above - don't edit
%---------------------------------------------------------------------

%
%                                                  `T",.`-, 
%                                                     '8, :. 
%                                              `""`oooob."T,. 
%                                            ,-`".)O;8:doob.'-. 
%                                     ,..`'.'' -dP()d8O8Yo8:,..`, 
%                                   -o8b-     ,..)doOO8:':o; `Y8.`, 
%                                  ,..bo.,.....)OOO888o' :oO.  ".  `-. 
%                                , "`"d....88OOOOO8O88o  :O8o;.    ;;,b 
%                               ,dOOOOO""""""""O88888o:  :O88Oo.;:o888d 
%                               ""888Ob...,-- :o88O88o:. :o'"""""""Y8OP 
%                               d8888.....,.. :o8OO888:: :: 
%                              "" .dOO8bo`'',,;O88O:O8o: ::, 
%                                 ,dd8".  ,-)do8O8o:"""; ::: 
%                                 ,db(.  T)8P:8o:::::    ::: 
%                                 -"",`(;O"KdOo::        ::: 
%                                   ,K,'".doo:::'        :o: 
%                                    .doo:::"""::  :.    'o: 
%        ,..            .;ooooooo..o:"""""     ::;. ::;.  'o. 
%   ,, "'    ` ..   .d;o:"""'                  ::o:;::o::  :; 
%   d,         , ..ooo::;                      ::oo:;::o"'.:o 
%  ,d'.       :OOOOO8Oo::" '.. .               ::o8Ooo:;  ;o: 
%  'P"   ;  ;.OPd8888O8::;. 'oOoo:.;..         ;:O88Ooo:' O"' 
%  ,8:   o::oO` 88888OOo:::  o8O8Oo:::;;     ,;:oO88OOo;  ' 
% ,YP  ,::;:O:  888888o::::  :8888Ooo::::::::::oo888888o;. , 
% ',d: :;;O;:   :888888::o;  :8888888Ooooooooooo88888888Oo; , 
% dPY:  :o8O     YO8888O:O:;  O8888888888OOOO888"" Y8o:O88o; , 
%,' O:  'ob`      "8888888Oo;;o8888888888888'"'     `8OO:.`OOb . 
%'  Y:  ,:o:       `8O88888OOoo"""""""""""'           `OOob`Y8b` 
%   ::  ';o:        `8O88o:oOoP                        `8Oo `YO. 
%   `:   Oo:         `888O::oP                          88O  :OY 
%    :o; 8oP         :888o::P                           do:  8O: 
%   ,ooO:8O'       ,d8888o:O'                          dOo   ;:. 
%   ;O8odo'        88888O:o'                          do::  oo.: 
%  d"`)8O'         "YO88Oo'                          "8O:   o8b' 
% ''-'`"            d:O8oK  -hrr-                   dOOo'  :o": 
%                   O:8o:b.                        :88o:   `8:, 
%                   `8O:;7b,.                       `"8'     Y: 
%                    `YO;`8b' 
%                     `Oo; 8:. 
%                      `OP"8.` 
%                       :  Y8P 
%                       `o  `, 
%                        Y8bod. 
%                        `""""' 

                        

function initialiseArrays(sampleNumber)
   
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

function popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Pop-up menu for selecting Time Domain/Frequency Domain

contents = cellstr(get(hObject,'String'));
popChoice = contents(get(hObject,'Value'));
if (strcmp(popChoice,'Graph Time Domain'))
    popVal = 1;
elseif (strcmp(popChoice,'Graph Frequency Domain'))
    popVal = 2;
end

end

function popupmenu_CreateFcn(hObject, eventdata, handles)

% UI Settings for Pop-up menu

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function disproll_Callback(hObject, eventdata, handles)

% 'Display Roll' tickbox

% get(hObject,'Value')

end

function disppitch_Callback(hObject, eventdata, handles)

% 'Display Pitch' tickbox

% get(hObject,'Value')

end

function savedata_Callback(hObject, eventdata, handles)

% 'Save Data' push button

% Writes time, raw x, y then z data as a table, then into a .csv file

end

function loaddata_Callback(hObject, eventdata, handles)

% 'Load Data' push button

% Reads data out as a table, then into the dataSet Array, and returns the sampleRate and the sampleNumber

end

function sampleNumber_Callback(hObject, eventdata, handles)

% 'Edit text box' for 'Number of Samples'

sampleNumber = str2num(get(handles.sampleNumber, 'String'));
setappdata(0,'sampleNumber',sampleNumber)
set(handles.sampleNumber, 'String', num2str(sampleNumber));

% We should maybe be using str2double rather than str2num, apparently
% doubles are better but I don't really understand

end

function sampleNumber_CreateFcn(hObject, eventdata, handles)
% UI settings for sample number box
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function sampleRate_Callback(hObject, eventdata, handles)

% 'Edit text box' for 'Time Between Samples'

sampleRate = str2num(get(handles.sampleRate, 'String'));
setappdata(0,'sampleRate',sampleRate)
set(handles.sampleRate, 'String', num2str(sampleRate));

% Again possibly should be str2double

end

function sampleRate_CreateFcn(hObject, eventdata, handles)
% UI settings for sample rate box
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white');
end
end

function savesettings_Callback(hObject, eventdata, handles)

% 'Save' button for saving parameters. Writes to .csv file.

m = getappdata(0,'sampleNumber');
n = getappdata(0,'sampleRate');
fileID = fopen('settings.csv','w');
fprintf(fileID,'%d %.3f',m,n);
fclose(fileID);

% should initialise arrays here when that function is sorted

end

function captureData_Callback(hObject, eventdata, handles, popChoice)

% 'Ready to Capture Data' button.

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

set(handles.captureData, 'String', 'Please press MBDED button to begin');
s = serial('COM4');
fopen(s);
i=1;
while i<sampleNumber
    x = str2num(fscanf(s));
    xData(i) = x;
    y = str2num(fscanf(s));
    yData(i) = y;
    z = str2num(fscanf(s));
    zData(i) = z;
    pitchAng(i) = atan2((y),(sqrt((z)^2)+((x)^2))*(radConv)); % Y angle pitch
    rollAng(i) = atan2((x),(sqrt((z)^2)+((y)^2))*(radConv)); % X angle roll
    yawAng(i) = atan2((z),(sqrt(((x)^2)+((y)^2)))*(radConv)); % Z angle yaw
    i=i+1;
end
fclose(s)
end

function plot_Callback(hObject, eventdata, handles)

% 'Plot Graph' button to begin plotting

axes(handles.axes);

end
