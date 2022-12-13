function [time, P] = get_LHD_nbi5b(shotnum)
%   GET_LHD_nbi5b Returns the power of NBI source 4a. It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, P] = get_LHD_nbi5b(164423);
%
%   Created by: Dmitry Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       07.12.2022

time=[];
P = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'nb5bpwr_temporal';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
fltdata = str2num(temp(end));
fltdata = fltdata';


% Return values
time=fltdata(1,:);
P = fltdata(3,:);

end