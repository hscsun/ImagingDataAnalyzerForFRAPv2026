function varargout = ImagingDataAnalyzerForFRAP(varargin)
% ImagingDataAnalyzerForFRAP MATLAB code for ImagingDataAnalyzerForFRAP.fig
%      ImagingDataAnalyzerForFRAP, by itself, creates a new ImagingDataAnalyzerForFRAP or raises the existing
%      singleton*.
%
%      H = ImagingDataAnalyzerForFRAP returns the handle to a new ImagingDataAnalyzerForFRAP or the handle to
%      the existing singleton*.
%
%      ImagingDataAnalyzerForFRAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ImagingDataAnalyzerForFRAP.M with the given input arguments.
%
%      ImagingDataAnalyzerForFRAP('Property','Value',...) creates a new ImagingDataAnalyzerForFRAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImagingDataAnalyzerForFRAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImagingDataAnalyzerForFRAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%       Models implemented:
%       Model 1 : y = va - a*exp(-b*x)           (single exponential + baseline)
%       Model 2 : y = va - a*exp(-b*x) - c*exp(-d*x)  (double exponential)
%       Model 3 : y = a - a*exp(-b*x)            (single exponential from zero)
%       Rude    : manual t_half / RL input when auto-fit R^2 < threshold
%
%   Dependencies: MoRscan.m, calc_final_thalf.m, rscan.m, shadedErrorBar.m
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImagingDataAnalyzerForFRAP

% Last Modified by GUIDE v2.5 29-Aug-2026 22:42:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImagingDataAnalyzerForFRAP_OpeningFcn, ...
                   'gui_OutputFcn',  @ImagingDataAnalyzerForFRAP_OutputFcn, ...
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


% --- Executes just before ImagingDataAnalyzerForFRAP is made visible.
function ImagingDataAnalyzerForFRAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImagingDataAnalyzerForFRAP (see VARARGIN)

% Choose default command line output for ImagingDataAnalyzerForFRAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImagingDataAnalyzerForFRAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImagingDataAnalyzerForFRAP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function limitvalue_Callback(hObject, eventdata, handles)
% hObject    handle to limitvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of limitvalue as text
%        str2double(get(hObject,'String')) returns contents of limitvalue as a double


% --- Executes during object creation, after setting all properties.
function limitvalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to limitvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function insteadvalue_Callback(hObject, eventdata, handles)
% hObject    handle to insteadvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of insteadvalue as text
%        str2double(get(hObject,'String')) returns contents of insteadvalue as a double


% --- Executes during object creation, after setting all properties.
function insteadvalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to insteadvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  maxv fig m n
[cvname cvpath] = uigetfile({'*.tif';'*.lsm'},'File Selector');
 fig=strcat(cvpath,cvname);
 m=str2num(get(handles.channels,'string'));% m=1;
 n=str2num(get(handles.channel,'string'));

frame=imread(fig,1);
maxv=unique(max(max(frame)));

 axes(handles.axes1);
 imshow(frame,'DisplayRange',[0 maxv]);
 colormap('hot');
 set(handles.result,'string',fig);


% --- Executes on button press in showimage.
function showimage_Callback(hObject, eventdata, handles)
% hObject    handle to showimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global fig maxv  imgcor m n
Imageno=str2num(get(handles.imageno,'string'));

frames=imread(fig,((Imageno-1)*m+n));
if isempty(imgcor)
    frames=frames;
else
    frames=frames*imgcor(ceil(Imageno/2));
end

 axes(handles.axes1);
 
 imshow(frames,'DisplayRange',[0 maxv]);
 colormap('hot');
 figure;imshow(frames,'DisplayRange',[0 maxv],'Border','tight');
 colormap('hot');
 set(handles.imageno,'string',Imageno);
 %h=imcontrast(gca);
 


function imageno_Callback(hObject, eventdata, handles)
% hObject    handle to imageno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imageno as text
%        str2double(get(hObject,'String')) returns contents of imageno as a double


% --- Executes during object creation, after setting all properties.
function imageno_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function pixelno_Callback(hObject, eventdata, handles)
% hObject    handle to pixelno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixelno as text
%        str2double(get(hObject,'String')) returns contents of pixelno as a double


% --- Executes during object creation, after setting all properties.
function pixelno_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixelno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channels_Callback(hObject, eventdata, handles)
% hObject    handle to channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channels as text
%        str2double(get(hObject,'String')) returns contents of channels as a double


% --- Executes during object creation, after setting all properties.
function channels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channel_Callback(hObject, eventdata, handles)
% hObject    handle to channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channel as text
%        str2double(get(hObject,'String')) returns contents of channel as a double


% --- Executes during object creation, after setting all properties.
function channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function regionNo_Callback(hObject, eventdata, handles)
% hObject    handle to regionNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of regionNo as text
%        str2double(get(hObject,'String')) returns contents of regionNo as a double


% --- Executes during object creation, after setting all properties.
function regionNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regionNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function roi_Callback(hObject, eventdata, handles)
% hObject    handle to roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roi as text
%        str2double(get(hObject,'String')) returns contents of roi as a double


% --- Executes during object creation, after setting all properties.
function roi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function background_Callback(hObject, eventdata, handles)
% hObject    handle to background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of background as text
%        str2double(get(hObject,'String')) returns contents of background as a double


% --- Executes during object creation, after setting all properties.
function background_CreateFcn(hObject, eventdata, handles)
% hObject    handle to background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flip_Callback(hObject, eventdata, handles)
% hObject    handle to flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of flip as text
%        str2double(get(hObject,'String')) returns contents of flip as a double


% --- Executes during object creation, after setting all properties.
function flip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PreBleachs_Callback(hObject, eventdata, handles)
% hObject    handle to PreBleachs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PreBleachs as text
%        str2double(get(hObject,'String')) returns contents of PreBleachs as a double


% --- Executes during object creation, after setting all properties.
function PreBleachs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PreBleachs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Loaddata.
function Loaddata_Callback(hObject, eventdata, handles)

%% ============================================================
%% FRAP Curve Fitting and Analysis Script
%% ============================================================
%% This script reads FRAP data, normalizes it, fits curves using
%% selectable models, and saves results to Excel.
%% ============================================================
%   Performs the complete FRAP analysis workflow:
%     1. Load and parse multi-column CSV/TXT data
%     2. Split columns into ROI, Reference, Background, FLIP groups
%     3. Background subtraction and pre-bleach normalization
%     4. FLIP correction
%     5. Smoothing (moving average)
%     6. Nonlinear curve fitting (Models 1-3) with Rude Model fallback
%     7. Batch statistics (CV, Mobile Fraction, Diffusion Coefficient)
%     8. Export results to CSV
%     9. Plot normalized curves with shaded error bars
%
%   This function reads global configuration from GUI controls and stores
%   intermediate results in global variables for cross-callback access.
%
%   Inputs:
%     hObject  - handle to the Loaddata pushbutton
%     eventdata - reserved (unused)
%     handles  - structure with handles and user data
%
%   Globals Used:
%     maxv, fig, m, n, imgcor, positionsB, posflips, cvpath, cvname
%% 1. Global Variables and File Input
global cvpath cvname  imgcor positionsB  posflips 

% File selection dialog
[cvname, cvpath] = uigetfile({'*.txt';'*.xlsx';'*.xls'}, 'File Selector');
FileName = strcat(cvpath, cvname);

% Read data based on file type
if isempty(strfind(cvname, 'txt'))
    [data, ~, ~] = xlsread(FileName);
else
    data = textread(FileName, '', 'whitespace', '\t', 'headerlines', 1);
end
set(handles.result, 'string', FileName);

%% 2. Parameter Extraction
region = str2num(get(handles.regionNo, 'string')) + 1;
roi = str2num(get(handles.roi, 'string')) + 1;
flip = str2num(get(handles.flip, 'string')) + 1;
bg = str2num(get(handles.background, 'string')) + 1;
r = str2num(get(handles.PreBleachs, 'string'));
Ftmodel = str2num(get(handles.Fittings, 'string'));
AftprebleachNo = r + 1;

%% 2b. R-squared Threshold for Rude Model Trigger
RSQUARE_THRESHOLD = 0.95;  % Rude Model trigger threshold (R?? below this value triggers refinement)

%% 2c. Diffusion Coefficient Parameter
BLEACH_RADIUS_UM = str2num(get(handles.Radius, 'string'));  % Bleach spot radius (um), adjust to your microscope setting    Radius

%% 3. Data Preprocessing
[drow, dcol] = size(data);
ro1 = data(1, :);

% Handle special cases for bg and flip
if bg == roi || bg == flip || bg == 1
    bgdata = 0;
elseif bg == region
    bg = 0;
end

if flip == roi || flip == bg || flip == 1
    flipdata = 0;
elseif flip == region
    flip = 0;
end

if roi == region
    roi = 0;
end


% Divide data into groups: ROI, reference and background
ii = 0;
for col = 1:dcol
    if isnan(ro1(1, col))
        continue;
    end
    ii = ii + 1;
    iii = ceil(ii / region);
    rem_val = rem(ii, region);
    if rem_val == 1
        t(:, iii) = data(:, col);
    elseif rem_val == roi
        sig(:, iii) = data(:, col);
    elseif rem_val == bg
        bgdata(:, iii) = data(:, col);
    elseif rem_val == flip
        flipdata(:, iii) = data(:, col);
    end
end

% Pre-bleach fluorescence intensities
Imax = mean(sig(1:r, :));
FLIPmax = mean(flipdata(1:r, :));

% Default values for missing reference/background
if ~ismatrix(flipdata) || all(flipdata(:) == 0)
    flipdata = ones(size(sig)) * max(Imax);
end
if ~ismatrix(bgdata) || all(bgdata(:) == 0)
    bgdata = zeros(size(sig));
end
%% 4. Normalization and Averaging
% Debackground
sigg = sig - bgdata;
siggbg = sigg(AftprebleachNo,:);

for jj = 1:drow
    sigbg(jj, :) = sigg(jj, :) - siggbg;
end

% Normalize
Imbg = mean(bgdata(1:r, :));
Imflip = mean(flipdata(1:r, :));
dif = Imax - Imbg;
diff = Imflip - Imbg;
ddif = mean(sigg(1:r, :)) - siggbg;
totalsig = flipdata - bgdata;

[n_rows, n_exp] = size(dif);
for hh = 1:n_exp
    nnormalisedsig(:, hh) = sigbg(:, hh) / ddif(hh);
    To(:, hh) = totalsig(:, hh) / diff(hh);
end

% Correct and calculate averaged curve
nnormaliseddata = nnormalisedsig ./ To;
meannorm = mean(nnormaliseddata, 2);
mm = mean(t, 2);
x = mm(AftprebleachNo:end, 1);
y = meannorm(AftprebleachNo:end, 1);
%y=y+0.1
%% 5. Fitting Model Definition
fmodel = Ftmodel;

% Select fitting model parameters
switch fmodel
    case 1  % Model 1: Single exponential with baseline
        FE_str = 'va - a*exp(-b*x)';
        lower_b = [0 0 0];
        upper_b = [1 1 10];
        sp = [0.50 0.5 0.5];
    case 2  % Model 2: Double exponential with baseline
        FE_str = 'va - a*exp(-b*x) - c*exp(-d*x)';
        lower_b = [0 0 0 0 0];
        upper_b = [1 10 10 10 1];
        sp = [0.5 0.5 0.5 0.5 0.5];
    case 3  % Model 3: Simple exponential from 0
        FE_str = 'a - a*exp(-b*x)';
        lower_b = [0 0];
        upper_b = [1 10];
        sp = [0.50 0.5];
end

FO = fitoptions('Method', 'NonlinearLeastSquares', ...
    'Maxiter', 1000, 'maxfuneval', 5000, ...
    'startpoint', sp, 'lower', lower_b, 'upper', upper_b);
FT = fittype(FE_str, 'options', FO);

% Smooth x vectors for fitted curves
gx = min(x(1)):0.01:max(x);
gx2 = mm(AftprebleachNo:end, 1);

%% 6. Fit Averaged Curve
[yout_avg, gof_avg, ~] = fit(x, y, FT, FO);

% Evaluate fitted curve at smooth and original x points
FE21_avg = yout_avg(gx);
FE22_avg = yout_avg(gx2);

% Calculate final recovery level and half recovery time for averaged curve
[final_avg, thalf_avg] = calc_final_thalf(yout_avg, FE21_avg, fmodel, gx);

% Extract R-squared from goodness-of-fit
rsquare_avg = gof_avg.rsquare;

%% 7. Rude Model Refinement (Averaged Curve)
rfinal = mean(nnormaliseddata(end-4:end, 1));
hfinal = rfinal / 2;
% Rude model trigger: use R?? threshold instead of distance comparison
tcorrect = mm(AftprebleachNo, 1);

if rsquare_avg < RSQUARE_THRESHOLD
    final_avg = rfinal;
    ma = max(find(nnormaliseddata(:, 1) <= hfinal));
    tmi = find(nnormaliseddata(:, 1) >= hfinal);
    tmi = tmi(tmi > AftprebleachNo);
    mi = min(tmi);
    thalf_avg = (mm(ma, 1) + mm(mi, 1)) / 2 - tcorrect;
    FE21_avg = final_avg - final_avg * exp(-0.6931 / (thalf_avg - tcorrect) * (gx - tcorrect));
    FE22_avg = final_avg - final_avg * exp(-0.6931 / (thalf_avg - tcorrect) * (gx2 - tcorrect));
%size(y)
%size(FE21_avg)
%size(FE22_avg)
% Recalculate R-squared for Rude model refined curve
    ss_res_rude = sum((y - FE22_avg).^2);
    ss_tot_rude = sum((y - mean(y)).^2);
    rsquare_avg_rude = 1 - ss_res_rude / ss_tot_rude;
    set(handles.result, 'string', sprintf('Rude model (R?? < 0.95): T-half is %.2f; Final recovery level is %.2f; R-squared is %.4f', thalf_avg, final_avg, rsquare_avg_rude));
else
    set(handles.result, 'string', sprintf('T-half is %.2f; Final recovery level is %.2f; R-squared is %.4f (>= 0.95)', thalf_avg, final_avg, rsquare_avg));
end
%FE21_avg=FE21_avg-0.1;
%FE22_avg=FE22_avg-0.1;
%% 8. For Loop: Fit Each Experiment Individually Using Same Fitting Models
thalf_all = zeros(n_exp, 1);
rsquare_all = zeros(n_exp, 1);
final_all = zeros(n_exp, 1);
rmse_all = zeros(n_exp, 1);
mf_all = zeros(n_exp, 1);
d_all = zeros(n_exp, 1);

% Create output folder
output_dir = sprintf('%sanaFRAP/%s', cvpath, cvname);
mkdir(output_dir);

curve_file = sprintf('%s/FRAP_CurveFits', output_dir);
summary_file = sprintf('%s/FRAP_Summary', output_dir);

for i = 1:n_exp
    % Extract single experiment data (post-bleach)
    y_single = nnormaliseddata(AftprebleachNo:end, i);
    x_single = mm(AftprebleachNo:end, 1);

    % Fit using the same fitting model
    try
        [yout, gof, ~] = fit(x_single, y_single, FT, FO);
        rsquare_i = gof.rsquare;

        % Evaluate fitted curve
        FE21 = yout(gx);
        FE22 = yout(gx2);

        % Calculate final recovery level and half recovery time
        [final_i, thalf_i] = calc_final_thalf(yout, FE21, fmodel, gx);

        % Calculate RMSE xxxxx
        residuals_i = y_single - FE22;
        rmse_i = sqrt(mean(residuals_i.^2));

        % Calculate Mobile Fraction (MF)
        pre_bleach_i = mean(nnormaliseddata(1:r, i));
        post_bleach_i = mean(nnormaliseddata(AftprebleachNo, i));
        mf_i = (final_i - post_bleach_i) / (pre_bleach_i - post_bleach_i);

        % Calculate Diffusion Coefficient (D)
        d_i = (BLEACH_RADIUS_UM^2) * log(2) / (4 * thalf_i);

        % Rude model refinement for individual experiment
        rfinal_i = mean(nnormaliseddata(end-4:end, i));
        hfinal_i = rfinal_i / 2;
        % Rude model trigger: use R?? threshold instead of distance comparison

        if rsquare_i < RSQUARE_THRESHOLD
            final_i = rfinal_i;
            ma = max(find(nnormaliseddata(1:end, i) <= hfinal_i));
            tmi = find(nnormaliseddata(1:end, i) >= hfinal_i);
            tmi = tmi(tmi > AftprebleachNo);
            mi = min(tmi);
            thalf_i = (mm(ma, 1) + mm(mi, 1)) / 2 - tcorrect;
            FE21 = final_i - final_i * exp(-0.6931 / (thalf_i - tcorrect) * (gx - tcorrect));
            FE22 = final_i - final_i * exp(-0.6931 / (thalf_i - tcorrect) * (gx2 - tcorrect));

% Recalculate R-squared for Rude model refined curve
            ss_res_rude_i = sum((y_single - FE22).^2);
            ss_tot_rude_i = sum((y_single - mean(y_single)).^2);
            rsquare_i_rude = 1 - ss_res_rude_i / ss_tot_rude_i;
            rsquare_all(i) = rsquare_i_rude;

            % Recalculate RMSE and MF after Rude model refinement
            residuals_i_rude = y_single - FE22;
            rmse_i = sqrt(mean(residuals_i_rude.^2));
            mf_i = (final_i - post_bleach_i) / (pre_bleach_i - post_bleach_i);
            d_i = (BLEACH_RADIUS_UM^2) * log(2) / (4 * thalf_i);
        end

        if rsquare_i >= RSQUARE_THRESHOLD
            rsquare_all(i) = rsquare_i;
        end

        % Store results for summary
        thalf_all(i) = thalf_i;
        final_all(i) = final_i;
        rmse_all(i) = rmse_i;
        mf_all(i) = mf_i;
        d_all(i) = d_i;

        % Save fitted curve data to Excel (one sheet per experiment)
        csv_file = sprintf('%s_Exp%d.csv', curve_file, i);
        T_curve = table(x_single, y_single, FE22, rsquare_all(i) * ones(size(x_single)), ...
            'VariableNames', {'Time', 'Raw_Normalized', 'Fitted', 'R_Squared'});
        writetable(T_curve, csv_file, 'FileType', 'text');

        % --- Annotate t_half and R?? on each fitted curve ---
        % Find the time point closest to t_half
        [~, idx_half] = min(abs(x_single - thalf_i));
        x_label = x_single(idx_half);
        y_label = FE22(idx_half);

        % Create annotation text
        if isnan(rsquare_all(i))
            annot_str = sprintf('t_{1/2}=%.2f s\nR^2=N/A', thalf_i);
        else
            annot_str = sprintf('t_{1/2}=%.2f s\nR^2=%.4f', thalf_i, rsquare_all(i));
        end

        % Place text annotation on the curve
        text(x_label, y_label + 0.05, annot_str, ...
            'FontSize', 8, ...
            'Color', 'k', ...
            'BackgroundColor', [1 1 1 0.8], ...
            'EdgeColor', 'k', ...
            'HorizontalAlignment', 'left', ...
            'VerticalAlignment', 'bottom');

    catch ME
        warning('Fitting failed for experiment %d: %s', i, ME.message);
        thalf_all(i) = NaN;
        rsquare_all(i) = NaN;
        final_all(i) = NaN;
        rmse_all(i) = NaN;
        mf_all(i) = NaN;
        d_all(i) = NaN;

        % Still save raw data even if fitting fails
        csv_file = sprintf('%s_Exp%d.csv', curve_file, i);
        T_curve_fail = table(x_single, y_single, NaN(size(x_single)), NaN(size(x_single)), ...
            'VariableNames', {'Time', 'Raw_Normalized', 'Fitted', 'R_Squared'});
        writetable(T_curve_fail, csv_file, 'FileType', 'text');
    end
end

% --- Calculate CV (Coefficient of Variation) for Half Recovery Time ---
valid_idx = ~isnan(thalf_all);
if sum(valid_idx) > 1
    cv_half = std(thalf_all(valid_idx)) / mean(thalf_all(valid_idx)) * 100;
else
    cv_half = NaN;
end

% Save merged summary Excel (7 columns + CV)
summary_data = cell(n_exp + 2, 7);
summary_data(1, :) = {'Experiment', 'Half_Recovery_Time', 'Final_Recovery_Level', 'R_Squared', 'RMSE', 'Mobile_Fraction', 'Diffusion_Coefficient'};
for j = 1:n_exp
    summary_data(j+1, 1) = {sprintf('Exp_%d', j)};
    summary_data(j+1, 2) = {thalf_all(j)};
    summary_data(j+1, 3) = {final_all(j)};
    summary_data(j+1, 4) = {rsquare_all(j)};
    summary_data(j+1, 5) = {rmse_all(j)};
    summary_data(j+1, 6) = {mf_all(j)};
    summary_data(j+1, 7) = {d_all(j)};
end
% Add CV row at the bottom
summary_data(n_exp + 2, 1) = {'Group Statistics'};
summary_data(n_exp + 2, 2) = {sprintf('CV of Half Recovery Time: %.2f%%', cv_half)};
% Save summary using writetable with FileType=text (macOS compatible)
exp_names = cell(n_exp, 1);
for j = 1:n_exp
    exp_names{j} = sprintf('Exp_%d', j);
end
T_summary = table(exp_names, thalf_all, final_all, rsquare_all, rmse_all, mf_all, d_all, ...
    'VariableNames', {'Experiment', 'Half_Recovery_Time', 'Final_Recovery_Level', ...
        'R_Squared', 'RMSE', 'Mobile_Fraction', 'Diffusion_Coefficient'});
summary_file1 = sprintf('%s_summary.csv', summary_file);
writetable(T_summary, summary_file1, 'FileType', 'text');

% Write CV info to a separate CSV file (CSV doesn't support multiple sheets)
%cv_info = table({'CV of Half Recovery Time'}, {sprintf('%.2f%%', cv_half)}, ...
%    'VariableNames', {'Metric', 'Value'});
%csv_file_cv = sprintf('%s_CV.csv', summary_file);
%writetable(cv_info, csv_file_cv, 'FileType', 'text');

% Print summary table to Command Window
fprintf('\n=== FRAP Summary ===\n');
fprintf('%-12s %-16s %-18s %-12s %-10s %-14s %-16s\n', ...
    'Experiment', 'T-half (s)', 'Final Level', 'R-Squared', 'RMSE', 'Mobile Frac', 'D (um^2/s)');
for j = 1:n_exp
    if isnan(thalf_all(j))
        fprintf('%-12s %-16s %-18s %-12s %-10s %-14s %-16s\n', ...
            sprintf('Exp_%d', j), 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A');
    else
        fprintf('%-12s %-16.2f %-18.4f %-12.4f %-10.4f %-14.4f %-16.4f\n', ...
            sprintf('Exp_%d', j), thalf_all(j), final_all(j), rsquare_all(j), ...
            rmse_all(j), mf_all(j), d_all(j));
    end
end
%fprintf('CV of Half Recovery Time: %.2f%%\n', cv_half);
% Print CSV file names to Command Window
fprintf('\nFiles saved as CSV format (compatible with macOS, no Excel required):\n');
fprintf('  - %s_Exp1.csv ... %s_Exp%d.csv (individual curve fits)\n', curve_file, curve_file, n_exp);
fprintf('  - %s.csv (summary with all experiments)\n', summary_file);
%fprintf('  - %s_CV.csv (group statistics)\n', summary_file);
fprintf('====================\n\n');
%% 9. Plotting
% Plot on axes3


axes(handles.axes3);
plot(mm, nnormaliseddata, 'LineWidth', 2);
hold on;
plot(gx, FE21_avg, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
axis([0, 1.02*max(mm), -0.01, 1.2]);
ylabel('Normalised Fluorescence Intensity (A.U.)', 'FontSize', 10, 'FontWeight', 'normal', 'Color', 'k');
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'normal', 'Color', 'k');
hold off;



% FRAP raw figure
scrsz = get(groot, 'ScreenSize');
FRAPraw = figure('Name', 'FRAP Raw', 'NumberTitle', 'off', ...
    'Position', [scrsz(3)/10 scrsz(4)/10 scrsz(3)/2 scrsz(4)/2]);
axes('FontSize', 14);
plot(mm, sig, 'LineWidth', 1.5, 'LineStyle', '-');
%axis([0, 1.02*max(mm), -0.01, 1.2]);
set(gca, 'FontSize', 13);
ylabel('Fluorescence Intensity (A.U.)', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');
xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');

% Save FRAP image
savenamefrapraw = sprintf('%sanaFRAP/%s/FRAPraw', cvpath, cvname);
print(FRAPraw, '-dpng', '-r800', savenamefrapraw);


% FRAP fitting figure
scrsz = get(groot, 'ScreenSize');
FRAPfitting = figure('Name', 'FRAP Curve Rude Fitting', 'NumberTitle', 'off', ...
    'Position', [scrsz(3)/10 scrsz(4)/10 scrsz(3)/2 scrsz(4)/2]);
axes('FontSize', 14);
plot(mm, nnormaliseddata, 'LineWidth', 1.5, 'LineStyle', '-');
hold on;
plot(gx, FE21_avg, 'Color', 'k', 'LineWidth', 3, 'LineStyle', '-');
axis([0, 1.02*max(mm), -0.01, 1.2]);
set(gca, 'FontSize', 13);
ylabel('Normalised Fluorescence Intensity (A.U.)', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');
xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');
hold off;
% Save FRAP image
savenamefrap = sprintf('%sanaFRAP/%s/FRAPfitting', cvpath, cvname);
print(FRAPfitting, '-dpng', '-r800', savenamefrap);

% FLIP of REF figure
flip_fig = figure('Name', 'FLIP', 'NumberTitle', 'off', ...
    'Position', [scrsz(3)/10 scrsz(4)/10 scrsz(3)/2 scrsz(4)/2]);
axes('FontSize', 14);
plot(mm, totalsig, 'LineWidth', 2, 'LineStyle', '-');
axis([0, 1.02*max(mm), 0, 1.2*max(max(totalsig))]);
set(gca, 'FontSize', 13);
ylabel('Fluorescence Intensity (A.U.)', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');
xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');

% Save FLIP image
savenamef = sprintf('%sanaFRAP/%s/FLIPref', cvpath, cvname);
print(flip_fig, '-dpng', '-r800', savenamef);

%% 9b. Region Plot (Mean +/- Std) ??? only when number of experiments > 3
if n_exp > 3
    mean_nnormaliseddata = mean(nnormaliseddata, 2);
    std_nnormaliseddata = std(nnormaliseddata, 0, 2);

    scrsz = get(groot, 'ScreenSize');
    rangeplot = figure('Name', 'FRAP Curve + std', 'NumberTitle', 'off', ...
        'Position', [scrsz(3)/10 scrsz(4)/10 scrsz(3)/2 scrsz(4)/2]);
    axes('FontSize', 14);
    box on
    hold on;



    % +/- 1 std boundary lines (magenta)
    plot(mm', [mean_nnormaliseddata' - std_nnormaliseddata'; ...
                    mean_nnormaliseddata' + std_nnormaliseddata'], 'Color', 'm');

    % Shaded error band using fill (built-in, no File Exchange dependency)
    hold on;
    H(2) = shadedErrorBar(mm', nnormaliseddata', {@mean, @(mm) 1*std(mm)  }, '-m', 0);
    % Mean curve (black, thick line)
    hold on;
    plot(mm', mean_nnormaliseddata', 'Color', 'm', 'LineWidth', 3);   
    hold on;
    plot(gx, FE21_avg, 'Color', 'k', 'LineWidth', 2, 'LineStyle', '-');
    legend([H(2).mainLine, H.patch], '\mu', '\sigma', 'Location', 'Northwest','TextColor','g','FontSize',10,'FontWeight','bold');
    
    ylim([-0.1 1.1])
    set(gca, 'FontSize', 13);
    ylabel('Normalised Fluorescence (A.U.)', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');
    xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');
    hold off
    savename = sprintf('%sanaFRAP/%s/orgRP', cvpath, cvname);
    print(rangeplot, '-dpng', '-r800', savename)
end


%bad fitting doesn't active the following function
if n_exp==1 && rsquare_avg>=0.95
    flot=0.1:0.2:0.9;
    sizeflot=max(size(flot));

    for jjj=1:1:sizeflot
        %based on: 1-fy=exp(-0.6931/thalf*t);    ln0.5=-0.6931
        %times(jjj)=(log(1-flot(jjj)))/(-0.6931)*thalf
        %pos(jjj)=max(find(mm(AftprebleachNo:(max(size(mm))-1),1)<=times(jjj)));
        if size(max(find(FE22(1:(max(size(FE22))-1))<=flot(jjj)*FE22(max(size(FE22))))))>0
            pos(jjj)=max(find(FE22(1:(max(size(FE22))-1))<=flot(jjj)*FE22(max(size(FE22)))))+r;
        else
            pos(jjj)=1;
        end
        posflip(jjj)=flipdata(1,1)/flipdata(pos(jjj),1);
    end   
    positionsB=[1 AftprebleachNo pos max(size(mm))];
    posflips=[1 flipdata(1,1)/flipdata(AftprebleachNo,1) posflip flipdata(1,1)/flipdata(max(size(mm)),1)];

    for imgc=1:length(flipdata(:,1))
        imgcor(imgc)=flipdata(1,1)/flipdata(imgc,1);
    end
else
    fprintf('Mutiple data sets or Bad fitting\n\n');
     
end

function result_Callback(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result as text
%        str2double(get(hObject,'String')) returns contents of result as a double


% --- Executes during object creation, after setting all properties.
function result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in profile.
function profile_Callback(hObject, eventdata, handles)
% hObject    handle to profile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fig poflips  positionsB xxlabe xlabe sree re posflips  cvpath cvname
%% rplotmodify_optimized.m
%% Extract FRAP fluorescence recovery radial profiles using MoRscan
%% and save raw data to Excel files
%% Compatible with MATLAB R2015a/b, ready for MATLAB Publish

    %% 1. Read parameters from GUI
    % Declare global variables (used by rscan library)

    % Read parameters from GUI controls
    m     = str2num(get(handles.channels,    'string'));
    n     = str2num(get(handles.channel,     'string'));
    cx    = str2num(get(handles.cx,          'string'));
    cy    = str2num(get(handles.cy,          'string'));
    rno   = str2num(get(handles.rno,         'string'));
    psz   = str2num(get(handles.pixelsize,   'string'));
    smr   = str2num(get(handles.smoothrange, 'string'));
    fitting = 1;
positionsB
    %% 2. Call MoRscan to extract radial profiles,re:raw;sre:smoothed raw;sree:smoothed U shape;ri:U shape from left to right,
    if fitting == 0
        % Use poflips (no flip)
        [sree, ri, re, sre] = MoRscan(fig, m, n, positionsB, cx, cy, rno, poflips, smr, fitting);
    elseif fitting == 1
        % Use posflips (with flip)
        [sree, ri, re, sre] = MoRscan(fig, m, n, positionsB, cx, cy, rno, posflips, smr, fitting);
    end

    %% 3. Background subtraction
    % Use frame 2 (first frame after bleach) as background reference
    sd = re(:, 2);
    se = sree(:, 2);

    rer   = [];
    sreer = [];

    % Subtract background per ring
    for i = 1:max(size(positionsB))
        rer(:, i)   = re(:, i)   - sd;
        sreer(:, i) = sree(:, i) - se;
    end

    %% 4. Compute axis labels
    si  = size(re);   % Original data size
    si2 = size(rer);  % Size after background subtraction
    sii = size(ri);

    % Radial distance labels (um): negative half + origin + positive half
    m1 = (-1*rno+1):1:-1;
    m2 = 1:(rno-1);
    xxlabe = [m1, 0, m2] * psz / 1000;

    % Time axis labels (um)
    xlabe = (1:si(1, 1)) * psz / 1000;

    %% 5. Plot radial recovery profiles
    axes(handles.axes4);
    plot(xxlabe, sree, 'Marker', 'none', 'LineWidth', 1.2);
    grid on;
    hleg1 = legend('PreBleach', 'AfterBleach', '10% FR', '30% FR', ...
                   '50% FR', '70% FR', '90% FR', '100% FR');
    axis([1.015*min(xxlabe), 1.015*max(xxlabe), -0.05, 1.2]);
    ylabel('Normalised Fluorescence Intensity (A.U.)', ...
           'FontSize', 12, 'FontWeight', 'normal', 'Color', 'k');
    xlabel('Distance to bleaching center (\mum)', ...
           'FontSize', 12, 'FontWeight', 'normal', 'Color', 'k');
    set(hleg1, 'Location', 'SouthEast');
    set(hleg1, 'Interpreter', 'none');

    ssi = size(sree);

    %% 6. Save data to Excel
    % Extract required ri columns (raw radial profile data)
    out(:, 1) = ri(:, 1);
    out(:, 2) = ri(:, 2);
    out(:, 3) = ri(:, 4);
    out(:, 4) = ri(:, 6);
    out(:, 5) = ri(:, 8);

    % Build output directory path (use fullfile for cross-platform compatibility)
    outputDir = fullfile(cvpath, 'anaFRAP', cvname);

    % File path
    fileName = fullfile(outputDir, '/rProfilePlot.csv');

    % Use table + writetable instead of deprecated xlswrite
    % table auto-generates column names, writetable available in MATLAB 2015
    T = table(ri(:, 1), ri(:, 2), ri(:, 3), ri(:, 4), ri(:, 5),ri(:, 6), ri(:, 7), ri(:, 8), ...
              'VariableNames', {'PreBleach', 'AfterBleach', 'FRx10pct', 'FRx30pct', ...
                   'FRx50pct', 'FRx70pct', 'FRx90pct', 'FRx100pct'});
    writetable(T, fileName);

    fprintf('Raw profile data saved to: %s\n', fileName);





% --- Executes on button press in zero.
function zero_Callback(hObject, eventdata, handles)
% hObject    handle to zero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all
clear global 

function controlnameANOVA_Callback(hObject, eventdata, handles)
% hObject    handle to controlnameANOVA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of controlnameANOVA as text
%        str2double(get(hObject,'String')) returns contents of controlnameANOVA as a double


% --- Executes during object creation, after setting all properties.
function controlnameANOVA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to controlnameANOVA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function cx_Callback(hObject, eventdata, handles)
% hObject    handle to cx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx as text
%        str2double(get(hObject,'String')) returns contents of cx as a double


% --- Executes during object creation, after setting all properties.
function cx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cy_Callback(hObject, eventdata, handles)
% hObject    handle to cy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cy as text
%        str2double(get(hObject,'String')) returns contents of cy as a double


% --- Executes during object creation, after setting all properties.
function cy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rno_Callback(hObject, eventdata, handles)
% hObject    handle to rno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rno as text
%        str2double(get(hObject,'String')) returns contents of rno as a double


% --- Executes during object creation, after setting all properties.
function rno_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixelsize_Callback(hObject, eventdata, handles)
% hObject    handle to pixelsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixelsize as text
%        str2double(get(hObject,'String')) returns contents of pixelsize as a double


% --- Executes during object creation, after setting all properties.
function pixelsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixelsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% raw profile plot for the bleaching area
function rawplot_Callback(hObject, eventdata, handles)
% hObject    handle to rawplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xlabe re cvpath cvname
%raw half plot
scrsz = get(groot,'ScreenSize');
rProfile_fig=figure('Name','Raw radial profile for the bleaching area','NumberTitle','off','Position',[scrsz(3)/10 scrsz(4)/10 scrsz(3)/2 scrsz(4)/2]);
axes('FontSize',12);
plot(xlabe,re,'Marker','none','LineWidth',1.2);
hleg1 = legend('Prebleach','AfterBleach','10% FR','30% FR','50% FR','70% FR','90% FR','100% FR');
axis([0,1.015*max(xlabe),0,1.2])
set(hleg1,'Location','SouthEast')
set(hleg1,'Interpreter','none')
set(gca, 'FontSize', 13);
ylabel('Normalised Fluorescence Intensity (A.U.)','FontSize',14,'FontWeight','normal','Color','k');
xlabel('Distance to bleaching center (\mum)','FontSize',14,'FontWeight','normal','Color','k');
hold off;
% Save image
savenamerProfile = sprintf('%sanaFRAP/%s/rProfile', cvpath, cvname);
print(rProfile_fig, '-dpng', '-r800', savenamerProfile);


% smoothed profile plot
function smp_Callback(hObject, eventdata, handles)
% hObject    handle to smp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xxlabe sree cvpath cvname
scrsz = get(groot,'ScreenSize');
sProfile_fig=figure('Name','Smoothed radial profile for the bleaching area','NumberTitle','off','Position',[scrsz(3)/10 scrsz(4)/10 scrsz(3)/2 scrsz(4)/2]);
axes('FontSize',12);
plot(xxlabe,sree,'Marker','none','LineWidth',1.2);
hleg1 = legend('PreBleach','AfterBleach','10% FR','30% FR','50% FR','70% FR','90% FR','100% FR');
axis([1.015*min(xxlabe),1.015*max(xxlabe),0,1.2])
set(hleg1,'Location','SouthEast')
set(hleg1,'Interpreter','none')
set(gca, 'FontSize', 13);
ylabel('Normalised Fluorescence Intensity (A.U.)','FontSize',14,'FontWeight','normal','Color','k');
xlabel('Distance to bleaching center (\mum)','FontSize',14,'FontWeight','normal','Color','k');
hold off;
% Save FLIP image
savenamesProfile = sprintf('%sanaFRAP/%s/srProfile', cvpath, cvname);
print(sProfile_fig, '-dpng', '-r800', savenamesProfile);

function smoothrange_Callback(hObject, eventdata, handles)
% hObject    handle to smoothrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothrange as text
%        str2double(get(hObject,'String')) returns contents of smoothrange as a double


% --- Executes during object creation, after setting all properties.
function smoothrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function frange_Callback(hObject, eventdata, handles)
% hObject    handle to frange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frange as text
%        str2double(get(hObject,'String')) returns contents of frange as a double


% --- Executes during object creation, after setting all properties.
function frange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fittings_Callback(hObject, eventdata, handles)
% hObject    handle to Fittings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fittings as text
%        str2double(get(hObject,'String')) returns contents of Fittings as a double


% --- Executes during object creation, after setting all properties.
function Fittings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fittings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Radius_Callback(hObject, eventdata, handles)
% hObject    handle to Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Radius as text
%        str2double(get(hObject,'String')) returns contents of Radius as a double


% --- Executes during object creation, after setting all properties.
function Radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
