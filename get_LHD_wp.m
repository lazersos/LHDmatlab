function [time, Wp] = get_LHD_wp(shotnum)
%GET_LHD_WP Returns LHD data from webservice
%   This routine returns a time vector and diagmangetic energy vector (J)
%   for a given discharge on LHD.  It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time,Wp] = get_LHD_wp(164423);
%
%   Created by: S. Lazerson (samuel.lazerson@ipp.mpg.de)
%   Version:    1.0
%   Date:       06/30/2022

time=[];
Wp = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'wp';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1);
fltdata=sscanf(temp(end),'%e,%e,%e,%e',[4, Inf]);

% Return values
time=fltdata(1,:);
Wp = fltdata(2,:).*1000; % kJ to J

end