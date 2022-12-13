function [time, rho, te, ne] = get_LHD_thomson_fit(shotnum)
%GET_LHD_THOMSON_fit Returns LHD smoothened Te and ne profiles
%   This routine returns Thomson measured data in the form of a time
%   vector, radius vector (m), electron temperature (ev), temperature
%   error (ev), electron density (m^-3), and electron density error
%   (m^-3). It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, rho, te, ne] = get_LHD_thomson_fit(164423);
%
%   Created by: D. Moseev (samuel.lazerson@ipp.mpg.de)
%   Version:    1.0
%   Date:       10.12.2022

time=[];
rho = [];
te = [];
ne = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'tsmap_smooth';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
% fltdata=sscanf(temp(end),'%f,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f',[11, Inf]);
fltdata = str2num(temp(end))';

% Return values
time=unique(fltdata(1,:));
tmp = length(fltdata)/length(time);
rho = unique(fltdata(5,1:tmp));
dimsize=[length(rho),length(time)];
te = reshape(fltdata(3,:),dimsize);
ne = reshape(fltdata(4,:),dimsize).*1E16;

end