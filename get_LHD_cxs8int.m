function [time, R, I] = get_LHD_cxs8int(shotnum)
%GET_LHD_LHD_cxs8int Returns LHD impurity intensity daat from the CXS8
%system
%   This routine returns Thomson measured data in the form of a time
%   vector, radius vector (m), and intensity of impurity radiation (a.u.). 
%   It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, R, I] = get_LHD_cxs8int(shotnum);
%
%   Created by: Dmitry Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       12.11.2022

time=[];
R = [];
I = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'lhdcxs8_int';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
fltdata=sscanf(temp(end),'%f,%f,%f,',[3, Inf]);

% Return values
time=unique(fltdata(1,:));
R = unique(fltdata(2,:))./1000;
dimsize=[length(R),length(time)];
I = reshape(fltdata(3,:),dimsize);

end