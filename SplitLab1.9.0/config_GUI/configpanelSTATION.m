%% Station data
h.panel(1) = uipanel('Units','pixel','Title','Station',...
    'Position',pos-[0 -10 0 10],'Visible','off', ...
    'BackgroundColor', [224   223   227]/255 );
set(cfig,'color',get(h.panel(1),'BackgroundColor'));


x = 60;
y = pos(4)-70;
w = 60;
v = 20;
%% 

k = strcmp(config.studytype,'Reservoir')+1;
txt = {'Station Code:';
    'Network code';
    strings{1,k};
    strings{2,k};
    'Station Elevation [m]'};

for i=0:4
    tmphndl(i+1) = uicontrol('Parent',h.panel(1),'Units','pixel',...
        'Style','text',...
        'Position',[x y-(i*v*1.75) 250 v],...
        'String', txt{i+1},...
        'HorizontalAlignment','Left');
end




%%
uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[pos(3)-160 y+3 120 22],...
    'String', 'IRIS station query',...
    'Tooltip','http://www.iris.edu/SeismiQuery/station.htm',...
    'Callback','web http://www.iris.edu/SeismiQuery/station.htm -browser');
uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[pos(3)-160 y-27 120 22],...
    'String', 'Orfeus station query',...
    'Tooltip','http://www.orfeus-eu.org/cgi-bin/stationdb/stationsearch.cgi ',...
    'Callback','web http://www.orfeus-eu.org/cgi-bin/stationdb/stationsearch.cgi -browser');
uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[pos(3)-160 y-57 120 20],...
    'String', 'NEIC station book',...
    'Tooltip','http://neic.cr.usgs.gov/neis/station_book/station_book.html',...
    'Callback','web http://neic.cr.usgs.gov/neis/station_book/station_book.html -browser');

uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[pos(3)-160 y-87 120 22],...
    'String', 'Database Look-Up',...
    'Tooltip','lookup internal database from IRIS',...
    'Callback',@getIRISstationInfo);

google=uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[pos(3)-160 y-117 120 22],...
    'String', 'GoogleEarth Link',...
    'Tooltip','Open current station in GoogleEarth (Windows/MAC only)',...
    'Callback',['googleEarthlink(config.slat,config.slong,',...
    '[config.stnname, '' ('' config.netw '')''],',...
    'fullfile(config.savedir,[config.project(1:end-4), ''.kml'']),'...
    'config.comment);'] );





%% edit fields
x = 160;
y = y+5;
h.station(1) = uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[x y w v],...
    'String', config.stnname,...
    'FontName','FixedWidth',...
    'Callback','config.stnname=get(gcbo,''String'');');
 uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','PushButton',...
    'Position',[x+w+5 y 25 v],...
    'String', 'Find',...
    'Callback',@stationLookUp);



h.station(2) = uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[x y-1.75*v w v],...
    'String', config.netw,...
    'FontName','FixedWidth',...
    'Callback','config.netw=get(gcbo,''String'');');
h.station(3) = uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[x y-3.5*v w v],...
    'String', config.slat,...
    'FontName','FixedWidth',...
    'Callback','config.slat=str2num(get(gcbo,''String''));SL_plotConfigMap;');
h.station(4) = uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[x y-5.25*v w v],...
    'String', config.slong,...
    'FontName','FixedWidth',...
    'Callback','config.slong=str2num(get(gcbo,''String'')); if config.slong>180, config.slong=config.slong-360; set(gcbo,''String'', num2str(config.slong));end   ; if config.slong<-180, config.slong=config.slong+360; set(gcbo,''String'', num2str(config.slong));end   ;SL_plotConfigMap;');



h.station(6) = uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[x   y-7.0*v   w   v],...
    'String', config.selev,...
    'FontName','FixedWidth',...
    'Callback','config.selev=str2num(get(gcbo,''String''));');
uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','text',...
    'Position',[85 y-9.2*v  180 v*2],...
    'String', 'Note: Elevation is positive upward, while event depths are given positive downward!',...
    'HorizontalAlignment','Left');










%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Correction
uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','text',...
    'Position',[60 105 250 v],...
    'String', 'Misorientation                                 deg clock wise',...
    'HorizontalAlignment','Left');
h.station(5) = uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[x 110 w v],...
    'String', config.rotation,...
    'FontName','FixedWidth',...
    'Callback','config.rotation=str2num(get(gcbo,''String'')); rotate_seismographIcon') ;


uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','CheckBox',...
    'value',config.SwitchEN,...
    'Position',[30 80 230 18],...
    'String', 'Switch East and North components',...
    'Callback','config.SwitchEN=get(gcbo,''value''); rotate_seismographIcon') ;
uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','CheckBox',...
    'value',config.signE==-1,...%make logical variable from comparison with -1
    'Position',[30 55 230 18],...
    'Tooltip','<html><b>East</b> component points <b>West</b>?</html>',...
    'String', 'Switch polarity of East-component',...
    'Callback','if get(gcbo,''value''), config.signE=-1; else,  config.signE=1; end; rotate_seismographIcon') ;

uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','CheckBox',...
    'value',config.signN==-1,...%make logical variable from comparison with -1
    'Position',[30 30 230 18],...
    'Tooltip','<html><b>North</b> component points <b>South</b>?</html>',...
    'String', 'Switch polarity of North-component',...
    'Callback','if get(gcbo,''value''), config.signN=-1; else, config.signN=1; end; rotate_seismographIcon') ;

uicontrol('Parent',h.panel(1),'Units','pixel',...
    'Style','CheckBox',...
    'value',config.signZ==-1,...%make logical variable from comparison with -1
    'Position',[30 5 260 18],...
    'Tooltip','<html>Vertical component points <b>downwards</b> (standard is <b>upward</b>)?</html>',...
    'String', 'Switch polarity of Vertical-component to "down"',...
    'Callback','if get(gcbo,''value''), config.signZ=-1; else, config.signZ=1; end') ;


%%



ax= axes( 'parent',h.panel(1), ...
    'Units','pixel',...
    'Tag','StationConfigMap',...
    'position', [pos(3)-125 25 80 80]);
set(gcf, 'UserData',ax);
a = imread('world.topo.bathy.200406.jpg');
O = ones(size(a));
A=[O;a;O];
set(ax, 'UserData',A*.9);
if ~strcmp(config.studytype,'Reservoir')
    SL_plotConfigMap;
    %set(maphndl,'Visible','off')
end

    maphndl = findobj('Type', 'image','Tag','Karte');



hold on
plot([-1 1 nan 0 0],[0 0 nan 1 -1],'k:');

text([0 .7], [.7 0], {'N','E'},...
    'color','m',...    'FontSize',get(gcf,'DefaultUicontrolFontSize')-1,...
    'FontWeight','Demi',...
    'BackgroundColor','none',...
    'Tag','Seimograph Orientation Labels');
plot([.65 0],[0 0],'m',...
    'LineWidth',2,...
    'Tag','Seimograph Orientation Arrows');

set(ax,...
    'Ytick',[],'Xtick',[],...
    'Ylim',[-1 1],'Xlim',[-1 1])
xlabel('West - East', 'FontSize',get(0,'FactoryUicontrolFontSize')-1);
ylabel('South - North','FontSize',get(0,'FactoryUicontrolFontSize')-1);

rotate_seismographIcon
hold off
maphndl = findobj('Type', 'image','Parent',ax,'Tag','Karte');
%%




set (h.Type,    'UserData', {[tmphndl(3:4) h.Units] , strings,maphndl})



%%
axes( 'parent',h.panel(1), 'Units','pixel','position', [20 140 60 60] )
image(icon.compas)
axis off
axes( 'parent',h.panel(1), 'Units','pixel','position', [320 160 48 48] )
image(icon.check)
axis off