function [time, ch, d1, d2, d3, d4] = get_LHD_DNPA(shotnum)
%GET_LHD_DNPA Returns LHD neutral partcle analyzer data in counts in 4
%spatial channels (d1,d2,d3,d4)
%   It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, ch, d1, d2, d3, d4] = get_LHD_DNPA(186009);
%
%   Created by: Dmitry Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       14.11.2022

time=[];
ch = [];
d1 = [];
d2 = [];
d3 = [];
d4 = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'DNPA';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
% fltdata=sscanf(temp(end),'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f',[23, Inf]);
fltdata = str2num(temp(end))';
temp1 = split(temp(1),'DimSize = ');
temp1 = split(temp1(2),'DimUnit = ');
temp1 = temp1{1};
temp1 = temp1(1:end-3);
dimsize = str2num(temp1);
dimsize = dimsize(length(dimsize):-1:1);


% Return values
time=unique(fltdata(1,:));
ch = fltdata(2,1:dimsize(1));
% R = R(1:length(R)/length(time));
% dimsize=[length(R),length(time)];
d1 = reshape(fltdata(3,:),dimsize);
d2 = reshape(fltdata(4,:),dimsize);
d3 = reshape(fltdata(5,:),dimsize);
d4 = reshape(fltdata(6,:),dimsize);

end