function [time, frq, spec1, spec2, spec3, spec4] = get_LHD_ICE(shotnum)
%GET_LHD_ICE Returns LHD ICE spectrograms in teh range of several tens
%of MHz. The data come from two probes in port 5.5u-neg (spec1), 5.5u-pos
%(spec2) and 6.5u-neg (spec3) and 6.5u-pos(spec4)
%(spec2)
%   
% It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, frq, spec1, spec2] = get_LHD_ICE2(164423);
%
%   Created by: Dmitry Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       14.11.2022

time=[];
frq = [];
spec1 = [];
spec2 = [];
spec3 = [];
spec4 = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'ICH-ICE';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
% fltdata=sscanf(temp(end),'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f',[23, Inf]);
fltdata = str2num(temp(end))';

% Return values
time=unique(fltdata(1,:));
frq = unique(fltdata(2,:));
% R = R(1:length(R)/length(time));
dimsize=[length(frq),length(time)];
spec1 = reshape(fltdata(3,:),dimsize);
spec2 = reshape(fltdata(5,:),dimsize);
spec3 = reshape(fltdata(7,:),dimsize);
spec4 = reshape(fltdata(9,:),dimsize);


end