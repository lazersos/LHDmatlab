function [time, frq, PSD] = get_LHD_ICErf_95L(shotnum)
%get_LHD_ICErf_95L Returns LHD ICE signal from a discone antenna in port 9.5L  
%   It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, frq, PSD] = get_LHD_ICErf_95L(186009);
%
%   Created by: D. Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       31.12.2022

if 0

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'rf9.5-L_hf_psd';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);
end
strdata = string(fileread("C:\Users\dmmo\Downloads\rf9.5-L_hf_psd@186009_1.txt"));

% Now need to dissect
temp=split(strdata,'[Data]'); % last element contains data
%header = temp(1)
% fltdata=sscanf(temp(end),'%f,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f',[11, Inf]);
fltdata=sscanf(temp(end),'%f,%f,%f,%f,%f',[5, Inf]);
% fltdata = str2num(temp(end))';

time=unique(fltdata(1,:));
tmp = length(fltdata)/length(time);
frq = (fltdata(2,1:tmp));
dimsize=[length(frq),length(time)];

PSD = reshape(fltdata(4,:),dimsize);