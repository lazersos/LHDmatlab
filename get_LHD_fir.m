function [time, R, nel] = get_LHD_fir(shotnum)
%GET_LHD_FIR Returns LHD data from webservice
%   This routine returns a time vector, Radius vector (m), and line 
%   integrated density vector (m^-2).  
%   It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time,R,nel] = get_LHD_fir(164423);
%
%   Created by: S. Lazerson (samuel.lazerson@ipp.mpg.de)
%   Version:    1.0
%   Date:       06/30/2022

time=[];
Wp = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'fir_nel';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1);
fltdata=sscanf(temp(end),'%E,%E,%E,%E,%E,%E,%E,%E,%E,%E,%E,%E,%E,%E,%E,%E',[16, Inf]);
time = fltdata(1,:);
R = [3309, 3399, 3489, 3479 3669, 3759, 3849, 3939, 4029, 4119, 4209, 4299, 4389]./1000;
nel = fltdata(4:end,:).*1E19;


end