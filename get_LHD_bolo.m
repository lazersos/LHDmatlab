function [time, Prad] = get_LHD_bolo(shotnum)
%GET_LHD_WP Returns LHD data from webservice
%   This routine returns a time vector and total radiated power from a wide
%   angle metal foil bolometerfor a given discharge on LHD.  It uses the 
%   LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time,Wp] = get_LHD_bolo(164423);
%
%   Created by: D. Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       09.11.2022

time=[];
Prad = []; %kW

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'bolo';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);
% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data


%header = temp(1);
fltdata=sscanf(temp(end),'%e,%e,%e',[3, Inf]);

% Return values
time=fltdata(1,:);
Prad = fltdata(2,:);

end