function [time, lambda, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16] = get_LHD_FIDA2(shotnum)
%GET_LHD_FIDA2 Returns LHD FIDA measurements from parallel NBI
%   This routine returns ECE measured data in the form of a time
%   vector, reff/a99 in vacuum, electron temperature (kev). 
%   It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, lambda,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16] = get_LHD_FIDA2(186009);
%
%   Created by: D. Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       20.12.2022

if 0

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'fida_2';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);
end
strdata = string(fileread("C:\Users\dmmo\Downloads\fida_2@186009_1.txt"));

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
% fltdata=sscanf(temp(end),'%f,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f',[11, Inf]);
fltdata = str2num(temp(end))';

% Return values
time=unique(fltdata(1,:));
tmp = length(fltdata)/length(time);
lambda = (fltdata(3,1:tmp));
dimsize=[length(lambda),length(time)];
s1 = reshape(fltdata(4,:),dimsize);
s2 = reshape(fltdata(5,:),dimsize);
s3 = reshape(fltdata(6,:),dimsize);
s4 = reshape(fltdata(7,:),dimsize);
s5 = reshape(fltdata(8,:),dimsize);
s6 = reshape(fltdata(9,:),dimsize);
s7 = reshape(fltdata(10,:),dimsize);
s8 = reshape(fltdata(11,:),dimsize);
s9 = reshape(fltdata(12,:),dimsize);
s10 = reshape(fltdata(13,:),dimsize);
s11 = reshape(fltdata(14,:),dimsize);
s12 = reshape(fltdata(15,:),dimsize);
s13 = reshape(fltdata(16,:),dimsize);
s14 = reshape(fltdata(17,:),dimsize);
s15 = reshape(fltdata(18,:),dimsize);
s16 = reshape(fltdata(19,:),dimsize);

end