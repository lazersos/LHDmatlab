function [time,PtNBI,PrNBI, Pnbi1, Pnbi2, Pnbi3, Pnbi4, Pnbi5,Enbi1, Enbi2, Enbi3, Enbi4, Enbi5,gnbi1,gnbi2,gnbi3,gnbi4,gnbi5] = get_LHD_nbi(shotnum)
%get_LHD_nbi Returns LHD nbi power (total) for tangential nNBI, radial NBI, for NBI1-5, as well as the NBI gas
%   This routine returns Thomson measured data in the form of a time
%   vector, total power of tangential negative NBIs 1-3 [MW] PtNBI, total power of radial positive NBIs 4-5 [MW] PrNBI, 
%    energy [keV] and power [MW] of NBIs 1-5 Enbi* and Pnbi*, respectively;
%    gas of NBI (char) for NBI1-5 in gnbi*.
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%      [time,PtNBI,PrNBI, Pnbi1, Pnbi2, Pnbi3, Pnbi4, Pnbi5,Enbi1, Enbi2, Enbi3, Enbi4, Enbi5,gnbi1,gnbi2,gnbi3,gnbi4,gnbi5] = get_LHD_nbi(164423);
%
%   Created by: Dmitry Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       17.11.2022

;

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'nbpwr_tot_temporal';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
% fltdata=sscanf(temp(end),'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%i,%i,%i,%i,%i',[18, 5]);
fltdata = str2num(temp(end));
fltdata = fltdata';

% Return values
time = fltdata(1,:);
PtNBI = fltdata(2,:);
PrNBI = fltdata(3,:);
Enbi1 = fltdata(4,:);
Pnbi1 = fltdata(5,:);
Enbi2 = fltdata(6,:);
Pnbi2 = fltdata(7,:);
Enbi3 = fltdata(8,:);
Pnbi3 = fltdata(9,:);
Enbi4 = fltdata(10,:);
Pnbi4 = fltdata(11,:);
Enbi5 = fltdata(12,:);
Pnbi5 = fltdata(13,:);

if fltdata(14,1) == 1
    gnbi1 = 'H2';
elseif fltdata(14,1) == 2
    gnbi1 = 'D2';
elseif fltdata(14,1) == 3
    gnbi1 = 'He';
elseif fltdata(14,1) == -1
    gnbi1 = 'unknown';    
end

if fltdata(15,1) == 1
    gnbi2 = 'H2';
elseif fltdata(15,1) == 2
    gnbi2 = 'D2';
elseif fltdata(15,1) == 3
    gnbi2 = 'He';
elseif fltdata(15,1) == -1
    gnbi2 = 'unknown';    
end

if fltdata(16,1) == 1
    gnbi3 = 'H2';
elseif fltdata(16,1) == 2
    gnbi3 = 'D2';
elseif fltdata(16,1) == 3
    gnbi3 = 'He';
elseif fltdata(16,1) == -1
    gnbi3 = 'unknown';    
end

if fltdata(17,1) == 1
    gnbi4 = 'H2';
elseif fltdata(17,1) == 2
    gnbi4 = 'D2';
elseif fltdata(17,1) == 3
    gnbi4 = 'He';
elseif fltdata(17,1) == -1
    gnbi4 = 'unknown';    
end

if fltdata(18,1) == 1
    gnbi5 = 'H2';
elseif fltdata(18,1) == 2
    gnbi5 = 'D2';
elseif fltdata(18,1) == 3
    gnbi5 = 'He';
elseif fltdata(18,1) == -1
    gnbi5 = 'unknown';    
end



end