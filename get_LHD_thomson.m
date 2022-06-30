function [time, R, te, dte, ne, dne] = get_LHD_thomson(shotnum)
%GET_LHD_THOMSON Returns LHD stored energy data
%   This routine returns Thomson measured data in the form of a time
%   vector, radius vector (m), electron temperature (ev), temperature
%   error (ev), electron density (m^-3), and electron density error
%   (m^-3). It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, R, te, dte, ne, dne] = get_LHD_thomson(164423);
%
%   Created by: S. Lazerson (samuel.lazerson@ipp.mpg.de)
%   Version:    1.0
%   Date:       06/30/2022

time=[];
R = [];
te = [];
dte = [];
ne = [];
dne = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'thomson';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
fltdata=sscanf(temp(end),'%f,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i',[17, Inf]);

% Return values
time=unique(fltdata(1,:));
R = unique(fltdata(2,:))./1000;
dimsize=[length(R),length(time)];
te = reshape(fltdata(3,:),dimsize);
dte = reshape(fltdata(4,:),dimsize);
ne = reshape(fltdata(5,:),dimsize).*1E16;
dne = reshape(fltdata(6,:),dimsize).*1E16;

end