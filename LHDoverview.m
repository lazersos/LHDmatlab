function fig = LHDoverview(shotnum)
%LHDOVERVIEW Produces a LHD Overview plot from myView2 data
%   The LHDOVERVIEW routine creates and overview plot from LHD data
%   extracted from myView2 exported data.  It takes a discharge number as
%   input and returns a figure handle to the plot.
%
%   Example:
%       fig=LHDoverview(168424);
%
%   See also: MYVIEW2EXTRACT
%
%   Written by:     Samuel Lazerson (samuel.lazerson@ipp.mpg.de)
%   Version:        1.0
%   Date:           5/27/21

fig=[];
data=[];

% Get data
data = myView2extract(shotnum);

% Check for data
if isempty(data)
    disp('Could not find data check paths!');
    return;
end

%Setup Figure
nplots=4;
fig=figure('Position',[1 1 512 768],'Color','white','InvertHardCopy','off');
% Power
subplot(nplots,1,1);
nbi_total=[];
time_total=[];
leg_txt={};
for nb={'1','2','3','4a','4b','5a','5b'}
    field_txt = ['nb' nb{1} 'pwr'];
    if isfield(data,field_txt)
        hold on;
        plot(data.(field_txt).time,data.(field_txt).power./1E6,'LineWidth',1);
        hold off;
        if isempty(time_total)
            time_total = data.(field_txt).time;
            nbi_total = data.(field_txt).power;
        else
            nbi_total = nbi_total+ pchip(data.(field_txt).time,data.(field_txt).power,time_total);
        end
        leg_txt=[leg_txt; ['NBI_{' nb{1} '} (' data.(field_txt).gas ')']];
    end
end
if isfield(data,'echpw')
    for ec={'55U_77G','20UR_77G','20LL_154G','20UL_154G','90_XXXG','20LR_154G','15U_56G'}
        field_txt = ['Power_' ec{1}];
        if isfield(data.echpw,field_txt)
            hold on;
            plot(data.echpw.time,data.echpw.(field_txt)./1E6,'LineWidth',1);
            hold off;
            %if isempty(time_total)
            %    time_total = data.echpw.time;
            %    nbi_total = data.echpw.(field_txt);
            %else
            %    nbi_total = nbi_total+ pchip(data.echpw.time,data.echpw.(field_txt),time_total);
            %end
            leg_txt=[leg_txt; ['ECRH_{' strrep(ec{1},'_','\_') 'Hz} ']];
        end
    end
end
% Calc limits
x_limits = time_total([find(nbi_total>1000,1,'first') find(nbi_total>1000,1,'last')]);
%x_limits(1) = min([0 x_limits(1)]);
x_limits(1) = x_limits(1)-1;
x_limits(2) = x_limits(2)+1;
hold on;
if ~isempty(time_total)
    plot(time_total,nbi_total./1E6,'k','LineWidth',2);
    leg_txt=[leg_txt; 'NBI_{Total}'];
end
if isfield(data,'echpw')
    plot(data.echpw.time,data.echpw.Power_total./1E6,':k','LineWidth',2);
    leg_txt=[leg_txt; 'ECRH_{Total}'];
end
hold off;
xlim(x_limits);
legend(leg_txt,'Position',[0.76,0.66,0.22,0.33]);
ylabel('Power [MW]');
title(['LHD XP: ' num2str(shotnum,'%6.6i')]);

%Density
subplot(nplots,1,2);
leg_txt={};
if isfield(data,'firc')
    hold on;
    plot(data.firc.time,0.5.*(data.firc.nL_3669+data.firc.nL_3759)./1E19,'LineWidth',1);
    hold off;
    leg_txt=[leg_txt; 'n_{line} [m^{-2}]'];
    axis tight;
    ylim([0 max(ylim)]);
end
if isfield(data,'thomson')
    dex = and(data.thomson.R>3669,data.thomson.R<3759);
    dexf = and(data.thomson.time>x_limits(1)+1.1,data.thomson.time<x_limits(2)-1.1);
    hold on;
    plot(data.thomson.time,mean(data.thomson.ne(dex,:),1)./1E19,'o','LineWidth',1);
    hold off;
    leg_txt=[leg_txt; 'n_{e-core} [m^{-3}]'];
    ylim([0 max(mean(data.thomson.ne(dex,dexf)./1E19,'all')*1.5,max(ylim))]);
end
xlim(x_limits);
legend(leg_txt,'Location','NorthWest');
ylabel('Density x10^{19}');

%Temperature
subplot(nplots,1,3);
leg_txt={};
if isfield(data,'thomson')
    dex = and(data.thomson.R>3669,data.thomson.R<3759);
    dexf = and(data.thomson.time>x_limits(1)+1.1,data.thomson.time<x_limits(2)-1.1);
    hold on;
    plot(data.thomson.time,mean(data.thomson.te(dex,:),1)./1E3,'o','LineWidth',1);
    hold off;
    leg_txt=[leg_txt; 'T_{e-core}'];
    ylim([0 max(mean(data.thomson.te(dex,dexf)./1E3,'all')*1.5,max(ylim))]);
end
if isfield(data,'lhdcxs7_cvi')
    dex = and(data.lhdcxs7_cvi.R>3.669,data.lhdcxs7_cvi.R<3.759);
    dexf = and(data.lhdcxs7_cvi.time>x_limits(1)+1.1,data.lhdcxs7_cvi.time<x_limits(2)-1.1);
    hold on;
    plot(data.lhdcxs7_cvi.time,mean(data.lhdcxs7_cvi.ti(dex,:),1)./1E3,'o','LineWidth',1);
    hold off;
    leg_txt=[leg_txt; 'T_{i-core}'];
    ylim([0 max(mean(data.lhdcxs7_cvi.ti(dex,dexf)./1E3,'all')*1.5,max(ylim))]);
end
xlim(x_limits);
legend(leg_txt,'Location','NorthEast');
ylabel('Temperature [keV]');

%Energy/Current
subplot(nplots,1,4);
leg_txt={};
if and(isfield(data,'wp'),isfield(data,'ip'))
    hold on;
    [ax, ha1, ha2] = plotyy(data.wp.time,data.wp.Wp./1000,data.ip.time,data.ip.Ip);
    hold off;
    set(ax(1),'YColor','blue',...
        'YLim',[0 max(ax(1).YLim)],...
        'XLim',x_limits); 
    set(ha1,'Color','blue');
    set(ax(2),'YColor','red',...
        'YLim',[-1 1].*max(abs(ax(2).YLim)),...
        'XLim',x_limits); 
    set(ha2,'Color','red');
    ylabel(ax(1),'Stored Energy [kJ]');
    ylabel(ax(2),'Toroidal Current [kA]');
elseif isfield(data,'wp')
    hold on;
    plot(data.wp.time,data.wp.Wp./1000,'blue');
    hold off;
    ylim([0 max(ylim)]);
    ylabel('Stored Energy [kJ]');
    xlim(x_limits);
elseif isfield(data,'ip')
    hold on;
    plot(data.ip.time,data.ip.Ip,'red');
    hold off;
    ylim([-1 1].*max(abs(ylim)));
    ylabel('Toroidal Current [kA]');
    xlim(x_limits);
end
xlabel('Time [s]');

end

