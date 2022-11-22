function [time, R, dhr] = get_LHD_cxs10dhr(shotnum)
%get_LHD_cxs10dhr Returns LHD profile of D/(H+D) ratio
%   This routine returns Thomson measured data in the form of a time
%   vector, radius vector (m), deuterium ratio (a.u.), 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, R, dhr] = get_LHD_cxs10dhr(164423);
%
%   Created by: Dmitry Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       17.11.2022

time=[];
R = [];
dhr = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'lhdcxs10_dhr';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
fltdata=sscanf(temp(end),'%f , %f , %f , %f , %f , %f , %f , %f , %f , %f , %f , %f , %f , %f',[14, Inf]);
temp1 = split(temp(1),'DimSize = ');
temp1 = split(temp1(2),'DimUnit = ');
temp1 = temp1{1};
temp1 = temp1(1:end-3);
dimsize = str2num(temp1);
dimsize = dimsize(length(dimsize):-1:1);


% Return values
time=unique(fltdata(1,:));
R = fltdata(2,1:dimsize(1));
% R = R(1:length(R)/length(time));
% dimsize=[length(R),length(time)];
dhr = reshape(fltdata(7,:),dimsize);


R = R(3:end-3);
dhr = dhr(3:end-3,:);

end