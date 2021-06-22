function varargout = ImReg_Triangle(varargin)
% ImReg_Trianglelele MATLAB code for ImReg_Trianglelele.fig
%      ImReg_Trianglelele, by itself, creates a new ImReg_Trianglelele or raises the existing
%      singleton*.
%
%      H = ImReg_Trianglele returns the handle to a new ImReg_Trianglele or the handle to
%      the existing singleton*.
%
%      ImReg_Trianglele('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ImReg_Trianglele.M with the given input arguments.
%
%      ImReg_Trianglele('Property','Value',...) creates a new ImReg_Trianglele or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImReg_Trianglele_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImReg_Trianglele_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImReg_Trianglele

% Last Modified by GUIDE v2.5 16-Apr-2019 16:25:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImReg_Trianglele_OpeningFcn, ...
                   'gui_OutputFcn',  @ImReg_Trianglele_OutputFcn, ...
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


% --- Executes just before ImReg_Trianglele is made visible.
function ImReg_Trianglele_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImReg_Trianglele (see VARARGIN)

% Choose default command line output for ImReg_Trianglele
handles.output = hObject;

axes(handles.axes1); 
cla(handles.axes1)
axis off

global ImregTriangle
Im.path=[]; Im.name=[]; Im.data=[];
ImregTriangle.ImMovingStatic={Im,Im};
ImregTriangle.FeatureMovingStatic={[],[]};
ImregTriangle.ImRegFlag=0;
ImregTriangle.ImRegister.data=[];
ImregTriangle.ImRegister.tform=[];

set(handles.PathStatic,'String',[]);  
set(handles.PathMoving,'String',[]);  

StatusHint='Start registration.';
set(handles.StatusHint,'String',StatusHint);  

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImReg_Trianglele wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImReg_Trianglele_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function ImSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ImSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
SliderInd=get(handles.ImSlider,'value');
axes(handles.axes1); 
cla
global ImregTriangle
if ImregTriangle.ImRegFlag==0
    Im=ImregTriangle.ImMovingStatic{1,SliderInd};
    ShowImage=Im.data;
    ShowFeature{1,1}=ImregTriangle.FeatureMovingStatic{1,1};
    ShowFeature{1,2}=ImregTriangle.FeatureMovingStatic{1,2};
end
if ImregTriangle.ImRegFlag==1
    if SliderInd==2
        Im=ImregTriangle.ImMovingStatic{1,SliderInd};
        ShowImage=Im.data;
    else
        ShowImage=ImregTriangle.ImRegister.data;
    end
    
    ShowFeature{1,1}=[];
    ShowFeature{1,2}=[];
end

imagesc(ShowImage)
hold on
axis off; axis equal
ScatterType={'k+','r+';'ko','ro'};
if ~isempty(ShowFeature{1,1})
    for ci=SliderInd:2
        TR_Feature=ShowFeature{1,ci};
        s=scatter(TR_Feature(:,1),TR_Feature(:,2),ScatterType{ci,1});
        s.SizeData=36*6;
    end
    
    if SliderInd==1
        TR_Feature_1=ShowFeature{1,1};
        TR_Feature_2=ShowFeature{1,2};
        x=[TR_Feature_1(:,1) TR_Feature_2(:,1)]';
        y=[TR_Feature_1(:,2) TR_Feature_2(:,2)]';
        plot(x,y,'k')
    end
end
    
% --- Executes during object creation, after setting all properties.
function ImSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in ImStatic.
function ImStatic_Callback(hObject, eventdata, handles)
% hObject    handle to ImStatic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ImregTriangle
[filename,pathname]=uigetfile({ '*.tif';'*.tiff';'*.png';'*.jpg';},'Select image'); % '*.*';
pathFull=[pathname filename];   % 完整路径;
Im.path=pathname; 
Im.name=filename; 
Im.data=imread(pathFull);

ImregTriangle.ImMovingStatic{1,2}=Im;
set(handles.ImSlider,'value',2);
axes(handles.axes1); 
imagesc(Im.data)
axis equal
axis off

set(handles.PathStatic,'String',pathFull);  

StatusHint='Load static image done.';
set(handles.StatusHint,'String',StatusHint);  

% --- Executes on button press in ImMoving.
function ImMoving_Callback(hObject, eventdata, handles)
% hObject    handle to ImMoving (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ImregTriangle
[filename,pathname]=uigetfile({ '*.tif';'*.tiff';'*.png';'*.jpg';},'Select image'); % '*.*';
pathFull=[pathname filename];   % 完整路径;
Im.path=pathname; 
Im.name=filename; 
Im.data=imread(pathFull);

ImregTriangle.ImMovingStatic{1,1}=Im;
set(handles.ImSlider,'value',1);
axes(handles.axes1); 
imagesc(Im.data)
axis equal
axis off

set(handles.PathMoving,'String',pathFull);  

StatusHint='Load moving image done.';
set(handles.StatusHint,'String',StatusHint);  

% --- Executes on button press in FeatureAdd.
function FeatureAdd_Callback(hObject, eventdata, handles)
% hObject    handle to FeatureAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ImregTriangle

ImregTriangle.ImRegFlag=0;
axes(handles.axes1); 
ScatterType={'k+','r+';'ko','ro'};
TR_Feature={[];[]};
for SliderInd=[2 1]
    set(handles.ImSlider,'value',SliderInd);
    Im=ImregTriangle.ImMovingStatic{1,SliderInd};
    ShowImage=Im.data;
    ShowFeature=ImregTriangle.FeatureMovingStatic{1,SliderInd};
    imagesc(ShowImage)
    hold on
    axis off;  axis equal
    if ~isempty(ShowFeature)
        s=scatter(ShowFeature(:,1),ShowFeature(:,2),ScatterType{SliderInd,1});
        s.SizeData=36*6;
    end
    [x_1,y_1,button_1]=ginput(1);
    if button_1~=1
        break
    end
    s=scatter(x_1,y_1,ScatterType{SliderInd,2});
    s.SizeData=36*6;
    TR_Feature{SliderInd,1}=[ x_1 y_1];
    
end

if ~isempty(TR_Feature{1,1}) && ~isempty(TR_Feature{2,1})
    for SliderInd=[2 1]
        ShowFeature=ImregTriangle.FeatureMovingStatic{1,SliderInd};
        ShowFeature=[ShowFeature; TR_Feature{SliderInd,1}];
        ImregTriangle.FeatureMovingStatic{1,SliderInd}=ShowFeature;
    end
end

StatusHint='Add cell feature done.';
set(handles.StatusHint,'String',StatusHint);  


% --- Executes on button press in FeatureDelete.
function FeatureDelete_Callback(hObject, eventdata, handles)
% hObject    handle to FeatureDelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ImregTriangle
ImregTriangle.ImRegFlag=0;
axes(handles.axes1); 

ScatterType={'k+','r+';'ko','ro'};
SliderInd=get(handles.ImSlider,'value');
Im=ImregTriangle.ImMovingStatic{1,SliderInd};
ShowImage=Im.data;
ShowFeature=ImregTriangle.FeatureMovingStatic{1,SliderInd};
if isempty(ShowFeature)
    return
end

imagesc(ShowImage)
hold on
axis off;  axis equal
if ~isempty(ShowFeature)
    s=scatter(ShowFeature(:,1),ShowFeature(:,2),ScatterType{SliderInd,1});
    s.SizeData=36*6;
end
[x_1,y_1,~]=ginput(1);
TR_point=[x_1,y_1];
TR_point=repmat(TR_point,size(ShowFeature,1),1);
TR_point_Err=TR_point-ShowFeature;
TR_point_Err=TR_point_Err.*TR_point_Err;
TR_point_Err=sum(TR_point_Err,2);
TR_ind=find(TR_point_Err==min(TR_point_Err));

hold off
imagesc(ShowImage)
hold on
axis off;  axis equal
ShowFeature(TR_ind,:)=[];
if ~isempty(ShowFeature)
    s=scatter(ShowFeature(:,1),ShowFeature(:,2),ScatterType{SliderInd,1});
    s.SizeData=36*6;
end
for SliderInd=[2 1]
    ShowFeature=ImregTriangle.FeatureMovingStatic{1,SliderInd};
    ShowFeature(TR_ind,:)=[];
    ImregTriangle.FeatureMovingStatic{1,SliderInd}=ShowFeature;
end

StatusHint='Delete cell feature done.';
set(handles.StatusHint,'String',StatusHint);  

% --- Executes on button press in Cancle.
function Cancle_Callback(hObject, eventdata, handles)
% hObject    handle to Cancle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ImregTriangle

ImregTriangle.ImRegFlag=0;

StatusHint='Cancle image registration done.';
set(handles.StatusHint,'String',StatusHint);  


% --- Executes on button press in Register.
function Register_Callback(hObject, eventdata, handles)
% hObject    handle to Register (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ImregTriangle

ImregTriangle.ImRegFlag=1;

Im=ImregTriangle.ImMovingStatic{1,2};
ImStatic=Im.data;
Im=ImregTriangle.ImMovingStatic{1,1};
ImMoving=Im.data;

FeatureStatic=ImregTriangle.FeatureMovingStatic{1,2};
FeatureMoving=ImregTriangle.FeatureMovingStatic{1,1};
[imgBReg, RegtriEsti] = ImRegTformtriEsti_SF_V1...
    (ImStatic,ImMoving,FeatureStatic,FeatureMoving);
ImregTriangle.ImRegister.data=imgBReg;
ImregTriangle.ImRegister.tform=RegtriEsti;

axes(handles.axes1); 
cla
imagesc(imgBReg)
axis off;  axis equal
set(handles.ImSlider,'value',1);

StatusHint='Image registration done.';
set(handles.StatusHint,'String',StatusHint);  

% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ImregTriangle

Im=ImregTriangle.ImMovingStatic{1,1};
pathname=Im.path; 
filename=Im.name; 
TR_ind=find(filename=='.');
matname=[filename(1:TR_ind(end)-1) '_RegtriEsti.mat'];
fullpath=[pathname matname];
save(fullpath,'ImregTriangle')

StatusHint='Save registration file done.';
set(handles.StatusHint,'String',StatusHint);  

% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ImregTriangle

[filename,pathname]=uigetfile({'*.mat';},'Select registration file');
pathfull=[pathname filename];
load(pathfull,'ImregTriangle')
if ~exist('ImregTriangle')
    errordlg('Please select a correct mat file.')
    return
end

set(handles.ImSlider,'value',2);

Hbt1=handles.ImSlider;
F=@ImSlider_Callback; %获取按钮2回调函数的句柄
feval(F,Hbt1, eventdata, handles);%执行按钮2的回调函数,参数为Hbt1, eventdata, handles

Im=ImregTriangle.ImMovingStatic{1, 2};
pathFull=[Im.path Im.name];
set(handles.PathStatic,'String',pathFull);  
Im=ImregTriangle.ImMovingStatic{1, 1};
pathFull=[Im.path Im.name];
set(handles.PathMoving,'String',pathFull);  

StatusHint='Load registration file done.';
set(handles.StatusHint,'String',StatusHint);  


function StatusHint_Callback(hObject, eventdata, handles)
% hObject    handle to StatusHint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StatusHint as text
%        str2double(get(hObject,'String')) returns contents of StatusHint as a double


% --- Executes during object creation, after setting all properties.
function StatusHint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StatusHint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PathStatic_Callback(hObject, eventdata, handles)
% hObject    handle to PathStatic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathStatic as text
%        str2double(get(hObject,'String')) returns contents of PathStatic as a double


% --- Executes during object creation, after setting all properties.
function PathStatic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PathStatic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PathMoving_Callback(hObject, eventdata, handles)
% hObject    handle to PathMoving (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathMoving as text
%        str2double(get(hObject,'String')) returns contents of PathMoving as a double


% --- Executes during object creation, after setting all properties.
function PathMoving_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PathMoving (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FeatureAuto.
function FeatureAuto_Callback(hObject, eventdata, handles)
% hObject    handle to FeatureAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ImregTriangle

im=ImregTriangle.ImMovingStatic{1,2};
imgA=im.data;
im=ImregTriangle.ImMovingStatic{1,1};
imgB=im.data;

FeaA = detectMSERFeatures(imgA, ...
    'RegionAreaRange',[40 100], 'MaxAreaVariation' ,0.1,'ThresholdDelta',1);
FeaA=FeatureIntraDistM_SF_V3(FeaA);

FeaB = detectMSERFeatures(imgB, ...
    'RegionAreaRange',[40 100], 'MaxAreaVariation' ,0.1,'ThresholdDelta',1);
FeaB=FeatureIntraDistM_SF_V3(FeaB);

FeaA_xy=FeaA.Location;
FeaB_xy=FeaB.Location;
Dim_e=[36 24]; % image dimension expansion
FFT_thre=[0.6 0.6]; % FFT threshold for feature match
[FeaA_xy_round,FeaA_xy_match,FeaA_xy_score]=FeaMatch_SF_V2(FeaA_xy,imgA,imgB,Dim_e,FFT_thre);
[FeaB_xy_round,FeaB_xy_match,FeaB_xy_score]=FeaMatch_SF_V2(FeaB_xy,imgB,imgA,Dim_e,FFT_thre);
Point_1=[FeaA_xy_round; FeaB_xy_match];
Point_2=[FeaA_xy_match; FeaB_xy_round];

point_score_T=[FeaA_xy_score;FeaB_xy_score];
point_score=point_score_T(:,1);
TRDist=pdist(Point_1);
TRDist=squareform(TRDist);
TRDist=tril(ones(size(TRDist,1))).*(TRDist+eye(size(TRDist,1))*size(imgA,1));
TRDist=TRDist+triu(ones(size(TRDist,1)))*size(imgA,1);
[cx,cy]=find(TRDist<=20);
cx_score=point_score(cx);
cy_score=point_score(cy);
TR_del=[cx(cx_score<=cy_score); cy(cy_score<cx_score)];
Point_1(TR_del,:)=[];
Point_2(TR_del,:)=[];
ImregTriangle.FeatureMovingStatic={double(Point_2),double(Point_1)};

set(handles.ImSlider,'value',1);

Hbt1=handles.ImSlider;
F=@ImSlider_Callback; %获取按钮2回调函数的句柄
feval(F,Hbt1, eventdata, handles);%执行按钮2的回调函数,参数为Hbt1, eventdata, handles

StatusHint='Autonomous features done.';
set(handles.StatusHint,'String',StatusHint);  

% --- Executes on button press in FeatureClear.
function FeatureClear_Callback(hObject, eventdata, handles)
% hObject    handle to FeatureClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
