function [time, rho, frq, Te] = get_LHD_fast_ece(shotnum)
%GET_LHD_fast_ece Returns LHD Te profile
%   This routine returns ECE measured data in the form of a time
%   vector, reff/a99 in vacuum, electron temperature (kev). 
%   It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, rho, frq, Te] = get_LHD_fast_ece(186009);
%
%   Created by: D. Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       20.12.2022

if 0

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'ece_fast';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);
end
strdata = string(fileread("C:\Users\dmmo\Downloads\ece_fast@186009_1.txt"));

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
% fltdata=sscanf(temp(end),'%f,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f',[11, Inf]);
fltdata = str2num(temp(end))';

% Return values
time=unique(fltdata(1,:));
tmp = length(fltdata)/length(time);
rho = (fltdata(7,1:tmp));
frq = unique(fltdata(2,1:tmp));
dimsize=[length(rho),length(time)];
Te = reshape(fltdata(3,:),dimsize);


end