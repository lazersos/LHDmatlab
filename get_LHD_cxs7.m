function [time, R, ti, dti, Vc, dVc] = get_LHD_cxs7(shotnum)
%GET_LHD_THOMSON Returns LHD stored energy data
%   This routine returns Thomson measured data in the form of a time
%   vector, radius vector (m), ion temperature (ev), temperature
%   error (ev), rotation velocity (m/s), and rotation velocity error
%   (m/s). It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, R, ti, dti, Vc, dVc] = get_LHD_cxs7(164423);
%
%   Created by: S. Lazerson (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       14.11.2022

time=[];
R = [];
ti = [];
dti = [];
Vc = [];
dVc = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'cxsmap7_tifit';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
fltdata=sscanf(temp(end),'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f',[23, Inf]);
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
ti = reshape(fltdata(4,:),dimsize);
dti = reshape(fltdata(5,:),dimsize);
Vc = reshape(fltdata(6,:),dimsize).*1E16;
dVc = reshape(fltdata(7,:),dimsize).*1E16;

R = R(3:end-3);
ti = ti(3:end-3,:);
dti = dti(3:end-3,:);
Vc = Vc(3:end-3,:);
dVc = dVc(3:end-3,:);

end