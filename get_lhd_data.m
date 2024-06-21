function data = get_lhd_data(diag_name,shotnum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

subdex=1;
server='egftp1.lhd.nifs.ac.jp';

if ~ischar(diag_name)
    return;
end

if ~isnumeric(shotnum)
    return;
end

shotgroup_str=num2str(floor(shotnum./1000).*1000,'%6.6i');
shot_str = num2str(shotnum,'%6.6i');
subshot_str = num2str(subdex,'%6.6i');



str=['/data/' diag_name '/' shotgroup_str '/' shot_str '/' subshot_str '/'];

lhd_ftp = ftp(server);
try
    files=dir(lhd_ftp,[str '*']);
catch
    disp('FTP connection refused');
    close(lhd_ftp);
end
close(lhd_ftp);


unzip(['http://' server str files(1).name]);

file_unzip = strrep(files(1).name,'.zip','');

fid = fopen(file_unzip,'r');
data=[];
n=1;
while ~feof(fid)
    str=fgetl(fid);
    if isempty(str), continue;end
    if strcmp(str(1),'#'), continue; end
    data(n,:) = sscanf(str,'%d',[inf]);
    n=n+1;
end

return


return;

end

