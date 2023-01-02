function [time, frq, PSD] = get_LHD_PCI_ch4(shotnum)
% GET_LHD_get_LHD_PCI_ch4 Returns LHD spectrogram of the density fluctuations measured with PCI. 
% It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, frq, PSD] = get_LHD_PCI_ch4(164423);
%
%   Created by: D. Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       26.12.2022

time=[];
frq = [];
PSD = [];
% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'pci_ch4_fft';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% strdata = string(fileread("C:\Users\dmmo\Downloads\pci_ch4_fft@185484_1.txt"));

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
fltdata=sscanf(temp(end),'%f,%f,%f',[3, Inf]);
% fltdata = str2num(temp(end))';

% Return values
time=unique(fltdata(1,:));
tmp = length(fltdata)/length(time);
frq = unique(fltdata(2,1:tmp));
dimsize=[length(frq),length(time)];
PSD = reshape(fltdata(3,:),dimsize);

end