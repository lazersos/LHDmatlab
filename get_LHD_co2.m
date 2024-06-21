function [time, R, nel] = get_LHD_co2(shotnum)
%GET_LHD_CO2 Returns LHD data from webservice
%   This routine returns a time vector, Radius vector, and line integrated
%   density vector.  This routine is experimental an not yet ready for
%   production.
% It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time,R,nel] = get_LHD_co2(164423);
%
%   Created by: S. Lazerson (samuel.lazerson@ipp.mpg.de)
%   Version:    0.1
%   Date:       06/30/2022

time=[];
Wp = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'co2_nel';
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
time = unique(fltdata(1,:));
R = unique(fltdata(2,:));
nel = reshape(fltdata(3,:),[length(time),length(R)]);


end