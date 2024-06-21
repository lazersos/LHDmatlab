function data=myView2extract(shotnum)
%MYVIEW2EXTRACT Extracts data from a myView2 run
%   The MYVIEW2EXTRACT routine takes your myView2 zip files and reads them
%   into a Matlab data structure.  The routine takes a shot number as
%   input.  It returns a data strcuture with fields related to the exported
%   zip file.
%
%   Note that myView2path must be set so that the routine can find your
%   myView2 installation and read from the cache directory.
%
%   Example:
%       data=myView2extract(168424);
%
%   Written by:     Samuel Lazerson (samuel.lazerson@ipp.mpg.de)
%   Version:        1.0
%   Date:           5/26/21

% Defaults
data=[];
myView2path='/Users/lazerson/Sims_Work/LHD/myView2';



% Helpers
path=[myView2path '/cache'];
data_strings={'thomson','wp','ip','lhdcxs7_cvi','echpw','firc'};
nheaders=[46,34,22,44,21,16];

% Create shotnumber helper
shotnum_txt=num2str(shotnum);


% Check for any files
files=dir([path '/*_' shotnum_txt '*']);
if isempty(files)
    disp([' Cannot find any data for shot: ' shotnum_txt]);
    disp(['    Path: ' path]);
    return;
end

% Extract Data
for i=1:length(data_strings)
%for i=4:4
    % Get datafile
    files=dir([path '/' data_strings{i}  '_' shotnum_txt '*.zip']);
    if isempty(files)
        continue;
    end
    % Unzip
    unzip([files.folder '/' files.name],'temp_mv2');
    % Read file
    files=dir('temp_mv2/*.dat');
    data.(data_strings{i})=importdata([files.folder '/' files.name],',',nheaders(i));
    % Remove directory
    rmdir('./temp_mv2','s');
end
data.shotnum=shotnum_txt;

% Handle NB powers separately
for nb={'1','2','3','4a','4b','5a','5b'}
    % Get datafile
    files=dir([path '/nb' nb{1}  'pwr_temporal_' shotnum_txt '*.zip']);
    if isempty(files)
        continue;
    end
    % Unzip
    unzip([files.folder '/' files.name],'temp_mv2');
    % Read file
    files=dir('temp_mv2/*.dat');
    field_name=['nb' nb{1} 'pwr'];
    data.(field_name)=importdata([files.folder '/' files.name],',',23);
    % Remove directory
    rmdir('./temp_mv2','s');
    % Process here
    data.(field_name).time = data.(field_name).data(:,1);
    data.(field_name).energy = data.(field_name).data(:,2).*1E3;
    data.(field_name).power = data.(field_name).data(:,3).*1E6;
    gas = data.(field_name).data(:,6);
    if max(gas) == 1
        data.(field_name).gas='H';
    elseif max(gas) == 2
        data.(field_name).gas='D';
    else
        data.(field_name).gas='unknown';
    end
    data.(field_name).time = data.(field_name).data(:,1);
end

% Reformat Thomson
if isfield(data,'thomson')
    data.thomson.time=unique(data.thomson.data(:,1))./1000; %ms to s
    data.thomson.R=unique(data.thomson.data(:,2));
    nt = length(data.thomson.time);
    nR = length(data.thomson.R);
    data.thomson.te = reshape(data.thomson.data(:,3),[nR, nt]);
    data.thomson.dte = reshape(data.thomson.data(:,4),[nR, nt]); 
    data.thomson.ne = reshape(data.thomson.data(:,5),[nR, nt]).*1E16; 
    data.thomson.dne = reshape(data.thomson.data(:,6),[nR, nt]).*1E16;
end

% Reformat CXRS
if isfield(data,'lhdcxs7_cvi')
    data.lhdcxs7_cvi.time=unique(data.lhdcxs7_cvi.data(:,1));
    nt = length(data.lhdcxs7_cvi.time);
    ntotal = length(data.lhdcxs7_cvi.data(:,1));
    nR = ntotal/nt;
    data.lhdcxs7_cvi.R=data.lhdcxs7_cvi.data(1:nR,2);
    data.lhdcxs7_cvi.ti = reshape(data.lhdcxs7_cvi.data(:,4),[nR, nt]).*1E3;
    data.lhdcxs7_cvi.ti_err = reshape(data.lhdcxs7_cvi.data(:,5),[nR, nt]).*1E3;
    data.lhdcxs7_cvi.Vc = reshape(data.lhdcxs7_cvi.data(:,6),[nR, nt]).*1E3;
    data.lhdcxs7_cvi.Vc_err = reshape(data.lhdcxs7_cvi.data(:,7),[nR, nt]).*1E3;
end

% Reformat ECRH
if isfield(data,'echpw')
    data.echpw.time=data.echpw.data(:,1);
    data.echpw.Power_55U_77G=data.echpw.data(:,2).*1E6;
    data.echpw.Power_20UR_77G=data.echpw.data(:,3).*1E6;
    data.echpw.Power_20LL_154G=data.echpw.data(:,4).*1E6;
    data.echpw.Power_20UL_154G=data.echpw.data(:,6).*1E6;
    data.echpw.Power_90_XXXG=data.echpw.data(:,7).*1E6;
    data.echpw.Power_20LR_154G=data.echpw.data(:,8).*1E6;
    data.echpw.Power_15U_56G=data.echpw.data(:,9).*1E6;
    data.echpw.Power_total=data.echpw.data(:,14).*1E6;
end

% Reformat FIR
if isfield(data,'firc')
    data.firc.time=data.firc.data(:,1);
    data.firc.nL_3669=data.firc.data(:,2).*1E19;
    data.firc.nL_3759=data.firc.data(:,3).*1E19;
end

% Reformat Ip
if isfield(data,'ip')
    data.ip.time=data.ip.data(:,1);
    data.ip.Ip=data.ip.data(:,2);
    data.ip.IpIvIc=data.ip.data(:,3);
end

% Reformat Wp
if isfield(data,'wp')
    if size(data.wp.data,2) ==4
        data.wp.time=data.wp.data(:,1);
        data.wp.Wp=data.wp.data(:,2).*1E3;
        data.wp.beta_dia=data.wp.data(:,3);
        data.wp.beta_vmec=data.wp.data(:,4);
    else
        data=rmfield(data,'wp');
    end
end


return;
end

