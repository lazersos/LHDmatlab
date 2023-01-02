function [time,channels] = get_LHD_FILD(shotnum)
%GET_LHD_FILD Returns LHD FILD data from webservice. 16 channels with 1 ms
%integration time
%   
% It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time,Wp] = get_LHD_FILD(164423);
%
%   Created by: D. Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       15.11.2022

time=[];


% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'FILD';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1);
% fltdata=sscanf(temp(end),'%e,%e,%e,%e,%e,%e',[6, Inf]);
fltdata = str2num(temp(end))';

% Return values
time=fltdata(1,:);
channels = fltdata(2:end,:);

end