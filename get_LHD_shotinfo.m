function [date, Bmod, Rax, gamma, Bq] = get_LHD_shotinfo(shotnum)
%GET_LHD_shotinfo Returns LHD data from webservice
%   This routine returns a information about the shot: its date and magnetic configuration.  It uses the 
%   LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [date, Bmod, Rax, gamma, Bq] = get_LHD_shotinfo(183123);
%
%   Created by: D. Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       12.11.2022


% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'shotinfo';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);
% Now need to dissect
temp=split(strdata,'[Data]'); % last element contains data


%header = temp(1);
% fltdata=sscanf(temp(end),'%e,%e,%e',[3, Inf]);
fltdata = str2num(temp(end));

% Return values
date = fltdata(3);
Bmod = fltdata(9);
Rax = fltdata(10);
gamma = fltdata(11);
Bq = fltdata(12);


end