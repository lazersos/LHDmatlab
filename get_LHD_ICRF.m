function [time,PICRH_35,PICRH_45, PICRH_tot] = get_LHD_ICRF(shotnum)
%GET_LHD_WP Returns LHD data from webservice
%   This routine returns a time vector and total ICRF power (MW), as well
%   as power from individual antennas in ports 3.5 and 4.5
%   for a given discharge on LHD.  It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time,PICRH_35,PICRH_45, PICRH_tot] = get_LHD_ICRF(164423);
%
%   Created by: D. Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       09.11.2022

time=[];
PICRH_tot = [];
PICRH_35 = [];
PICRH_45 = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'ichpw';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1);
fltdata=sscanf(temp(end),'%e,%e,%e,%e,%e,%e',[6, Inf]);

% Return values
time=fltdata(1,:);
PICRH_tot = fltdata(6,:);
PICRH_35 = fltdata(2,:)+fltdata(3,:);   % k_para = 5.82 
PICRH_45 = fltdata(4,:)+fltdata(5,:);   % k_para = 0.1

end