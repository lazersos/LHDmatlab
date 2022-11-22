function [time, PECRH] = get_LHD_ECRH(shotnum)
%GET_LHD_WP Returns LHD data from webservice
%   This routine returns a time vector and diagmangetic energy vector (J)
%   for a given discharge on LHD.  It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time,Wp] = get_LHD_ECRH(164423);
%
%   Created by: D. Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       09.11.2022

time=[];
PECRH = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'echpw';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);
% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data


%header = temp(1);
fltdata=sscanf(temp(end),'%e,%e,%e,%e,%e,%e,%e,%e,%e,%e,%e,%e,%e,%e',[14, Inf]);

% Return values
time=fltdata(1,:);
PECRH = fltdata(14,:);

end