function atl03_track(path,location, profile, strength, varargin)
% Show location of atl03 track over an image. Also displays times at an
% interval to show data density and for identification of start and end
% times for the DDA. The orientation is also printed (0-> strong=l's, 1->
% strong=r's)
%
% Thomas Trantow
% 10/19/2018
%
% Input:
%       path: (String) Path to (and including) ATL03 .h5 file
%       location: (String) Location of file (if known) for plotting
%                options: 'BBGS','Negribreen','Gieseke','Sverdrup','Greenland','Jakobshavn,'Rink','Hayesbreen','Helheim','Slessor','smith-pope-kohler','foundation-academy' (default = worldmap)
%       profile: 1 2 or 3 (beam pair) e.g. gt1l vs gt2l
%       strength (string): strong or weak
%       varargin (int): Optional input for spacng of displayed time. A
%       number less than or equal to 100 will use the default spacing
%       Default spacing of time-labels is every 1,000,000th point. If no
%       varargin is given, time display will be supressed.

% Determine time labeling
wantTime = 0;
dst = 1000000; % spacing of time-label printing
if length(varargin) == 1
    if varargin{1} ~= 0
        wantTime = 1;
        if varargin{1} > 100
            dst = varargin{1};
        end
    end
end

% Determine orientation and with beams are strong/weak
    s = strsplit(path,'/');
    name = s{end};
    
    orient = h5read(path, '/orbit_info/sc_orient');
    disp('Orientation:')
    disp(orient)
    if orient == 0
        if strcmp(strength,'weak')
            sbeam = 'r';
        else
            sbeam = 'l';
        end
    else
        if strcmp(strength,'weak')
            sbeam = 'l';
        else
            sbeam = 'r';
        end
    end
    
    beamstr = strcat('gt',num2str(profile),sbeam);
    

    % Load lat/lon data of photons
    lat_gt1 = h5read(path, strcat('/gt1',sbeam,'/heights/lat_ph'));
    lon_gt1 = h5read(path, strcat('/gt1',sbeam,'/heights/lon_ph'));
    lat_gt2 = h5read(path, strcat('/gt2',sbeam,'/heights/lat_ph'));
    lon_gt2 = h5read(path, strcat('/gt2',sbeam,'/heights/lon_ph'));
    lat_gt3 = h5read(path, strcat('/gt3',sbeam,'/heights/lat_ph'));
    lon_gt3 = h5read(path, strcat('/gt3',sbeam,'/heights/lon_ph'));
    
    time = h5read(path, strcat('/',beamstr,'/heights/delta_time'));
    length(time)
    
    % Downsample (don't need to plot all the photon data)
    ds = 10000;
    lat_gt1_ds = lat_gt1(1:ds:end);
    lon_gt1_ds = lon_gt1(1:ds:end);
    lat_gt2_ds = lat_gt2(1:ds:end);
    lon_gt2_ds = lon_gt2(1:ds:end);
    lat_gt3_ds = lat_gt3(1:ds:end);
    lon_gt3_ds = lon_gt3(1:ds:end);
    time_dst = time(1:dst:end);
    
    % Determine which beam to print times for (due to old code, this
    % variable has 'gt2' in it, though it doesn't necessarily mean it is the second beam)
    switch profile
        case 1
            lat_gt2_dst = lat_gt1(1:dst:end);
            lon_gt2_dst = lon_gt1(1:dst:end);
         case 2
            lat_gt2_dst = lat_gt2(1:dst:end);
            lon_gt2_dst = lon_gt2(1:dst:end);
            
        case 3
            lat_gt2_dst = lat_gt3(1:dst:end);
            lon_gt2_dst = lon_gt3(1:dst:end);  
    end
    

 
    
    close all
    
    
    % Determining which glacier image to display and what UTM zone to
    % convert to. Images should be in a 'data' directory
    switch location
      case {'Amery','Amery Ice Shelf','amery'}
            [x_gt1,y_gt1] = polarstereo_fwd(lat_gt1_ds,lon_gt1_ds);
            [x_gt2,y_gt2] = polarstereo_fwd(lat_gt2_ds,lon_gt2_ds);
            [x_gt3,y_gt3] = polarstereo_fwd(lat_gt3_ds,lon_gt3_ds);
            [x_gt2_dst,y_gt2_dst] = polarstereo_fwd(lat_gt2_dst,lon_gt2_dst);
            
            landsat_show_bands('data/','LC08_L1GT_045133_20190102_20190130_01_T2',2,3,4)
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southeast')
            axis([1.685e+06 1.907e+06 6.595E+05 7.926e+05])
            title({strcat('Amery Ice Shelf: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end
      case {'Stancomb-Wills','stancomb-wills','Stancomb','stancomb','Wills','wills'}
            [x_gt1,y_gt1] = polarstereo_fwd(lat_gt1_ds,lon_gt1_ds);
            [x_gt2,y_gt2] = polarstereo_fwd(lat_gt2_ds,lon_gt2_ds);
            [x_gt3,y_gt3] = polarstereo_fwd(lat_gt3_ds,lon_gt3_ds);
            [x_gt2_dst,y_gt2_dst] = polarstereo_fwd(lat_gt2_dst,lon_gt2_dst);
            
            landsat_show_bands('data/','LC08_L1GT_181113_20151031_20170402_01_T2',2,3,4)
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Stancomb-Wills: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end
      case {'Foundation','foundation','Academy','academy','Foundation-Academy','foundation-academy'}
            [x_gt1,y_gt1] = polarstereo_fwd(lat_gt1_ds,lon_gt1_ds);
            [x_gt2,y_gt2] = polarstereo_fwd(lat_gt2_ds,lon_gt2_ds);
            [x_gt3,y_gt3] = polarstereo_fwd(lat_gt3_ds,lon_gt3_ds);
            [x_gt2_dst,y_gt2_dst] = polarstereo_fwd(lat_gt2_dst,lon_gt2_dst);
            
            landsat_show_bands('data/','LC08_L1GT_169122_20180205_20180220_01_T2',2,3,4)
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Foundation-Academy: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end
       case {'Colorado','colorado','ccpond','colo'}
            [x_gt1,y_gt1] = ll2utm(lat_gt1_ds,lon_gt1_ds,13);
            [x_gt2,y_gt2] = ll2utm(lat_gt2_ds,lon_gt2_ds,13);
            [x_gt3,y_gt3] = ll2utm(lat_gt3_ds,lon_gt3_ds,13);
            [x_gt2_dst,y_gt2_dst] = ll2utm(lat_gt2_dst,lon_gt2_dst,13);
            
            landsat_show_bands('data/','LC08_L1TP_034033_20200702_20200708_01_T1',2,3,4)
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Colorado: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end  
            axis([377600 382800 4353000 4364000])
      case {'Smith','smith','Pope','pope','Kohler','kohler','smith-pope-kohler','Smith-Pope-Kohler','smith-pope','Smith-Pope'}
            [x_gt1,y_gt1] = polarstereo_fwd(lat_gt1_ds,lon_gt1_ds);
            [x_gt2,y_gt2] = polarstereo_fwd(lat_gt2_ds,lon_gt2_ds);
            [x_gt3,y_gt3] = polarstereo_fwd(lat_gt3_ds,lon_gt3_ds);
            [x_gt2_dst,y_gt2_dst] = polarstereo_fwd(lat_gt2_dst,lon_gt2_dst);
            
            landsat_show_bands('data/','LC08_L1GT_008113_20180213_20180222_01_T2',2,3,4)
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Smith-Pope-Kohler: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end
            
        case {'Slessor','slessor'}
            [x_gt1,y_gt1] = polarstereo_fwd(lat_gt1_ds,lon_gt1_ds);
            [x_gt2,y_gt2] = polarstereo_fwd(lat_gt2_ds,lon_gt2_ds);
            [x_gt3,y_gt3] = polarstereo_fwd(lat_gt3_ds,lon_gt3_ds);
            [x_gt2_dst,y_gt2_dst] = polarstereo_fwd(lat_gt2_dst,lon_gt2_dst);
            
            landsat_show_bands('data/','LC08_L1GT_171118_20181017_20181030_01_T2',2,3,4)
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Slessor Glacier:',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end
            
        case {'Pine Island','pinegl'}
            [x_gt1,y_gt1] = polarstereo_fwd(lat_gt1_ds,lon_gt1_ds);
            [x_gt2,y_gt2] = polarstereo_fwd(lat_gt2_ds,lon_gt2_ds);
            [x_gt3,y_gt3] = polarstereo_fwd(lat_gt3_ds,lon_gt3_ds);
            [x_gt2_dst,y_gt2_dst] = polarstereo_fwd(lat_gt2_dst,lon_gt2_dst);
            
            landsat_show_bands('data/','LC08_L1GT_233113_20200126_20200210_01_T2',2,3,4)
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Pine Island Glacier:',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
         end
            
            
            
        case {'Negribreen','Negri','negri'}
            [x_gt1,y_gt1] = ll2utm(lat_gt1_ds,lon_gt1_ds,35);
            [x_gt2,y_gt2] = ll2utm(lat_gt2_ds,lon_gt2_ds,35);
            [x_gt3,y_gt3] = ll2utm(lat_gt3_ds,lon_gt3_ds,35);
            [x_gt2_dst,y_gt2_dst] = ll2utm(lat_gt2_dst,lon_gt2_dst,35);

            fig('width',30,'border','on')
            %plotNegri_20170707_rgb
            %plotNegri_20190805_rgb
            landsat_show_bands('data/','LC08_L1TP_210004_20200329_20200409_01_T2',2,3,4)
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Negribreen: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end
            
        case {'Rink','rink'}
            [x_gt1,y_gt1] = ll2utm(lat_gt1_ds,lon_gt1_ds,22);
            [x_gt2,y_gt2] = ll2utm(lat_gt2_ds,lon_gt2_ds,22);
            [x_gt3,y_gt3] = ll2utm(lat_gt3_ds,lon_gt3_ds,22);
            [x_gt2_dst,y_gt2_dst] = ll2utm(lat_gt2_dst,lon_gt2_dst,22);

            fig('width',30,'border','on')
            plotRink_20180921_rgb
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Rink Glacier:',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end
            
        case {'Sverdrup','sverdrup'}
            [x_gt1,y_gt1] = ll2utm(lat_gt1_ds,lon_gt1_ds,21);
            [x_gt2,y_gt2] = ll2utm(lat_gt2_ds,lon_gt2_ds,21);
            [x_gt3,y_gt3] = ll2utm(lat_gt3_ds,lon_gt3_ds,21);
            [x_gt2_dst,y_gt2_dst] = ll2utm(lat_gt2_dst,lon_gt2_dst,21);

            fig('width',30,'border','on')
            plotSverdrup_20180902_rgb
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Sverdrup: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end
            
        case {'BBGS','bbgs','Bering','bering'}
            [x_gt1,y_gt1] = ll2utm(lat_gt1_ds,lon_gt1_ds);
            [x_gt2,y_gt2] = ll2utm(lat_gt2_ds,lon_gt2_ds);
            [x_gt3,y_gt3] = ll2utm(lat_gt3_ds,lon_gt3_ds);
            [x_gt2_dst,y_gt2_dst] = ll2utm(lat_gt2_dst,lon_gt2_dst);

            fig('width',30,'border','on')
            plotBBGS_good
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Bering Glacier: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end
            
            fig('width',30,'border','on')
            plotBagley_20130402_l8b8
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Bagley Ice Field: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end
            
        case {'Hayesbreen','Hayes','hayes'}
            [x_gt1,y_gt1] = ll2utm(lat_gt1_ds,lon_gt1_ds,33);
            [x_gt2,y_gt2] = ll2utm(lat_gt2_ds,lon_gt2_ds,33);
            [x_gt3,y_gt3] = ll2utm(lat_gt3_ds,lon_gt3_ds,33);
            [x_gt2_dst,y_gt2_dst] = ll2utm(lat_gt2_dst,lon_gt2_dst,33);

            fig('width',30,'border','on')
            plotHayes_20180630_rgb
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title(strcat('Hayesbreen: ',name),'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end
            end

        case {'Jakobshavn','Jak','jak'}
            [x_gt1,y_gt1] = ll2utm(lat_gt1_ds,lon_gt1_ds,22);
            [x_gt2,y_gt2] = ll2utm(lat_gt2_ds,lon_gt2_ds,22);
            [x_gt3,y_gt3] = ll2utm(lat_gt3_ds,lon_gt3_ds,22);
            [x_gt2_dst,y_gt2_dst] = ll2utm(lat_gt2_dst,lon_gt2_dst,22);

            fig('width',30,'border','on')
            %plotJak_20180730_rgb
            %landsat_show_bands('data/','LC08_L1TP_007012_20190601_20190605_01_T1',2,3,4)   
            
            landsat_show_bands('data/','LC08_L1TP_009011_20200703_20200708_01_T1',2,3,4)  
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Jakobshavn: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(x_gt2_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+.5,num2str(time_dst(i)))
            end  
            end
            
        case {'Helheim','helheim','Helhiem','helhiem'}
            [x_gt1,y_gt1] = ll2utm(lat_gt1_ds,lon_gt1_ds,24);
            [x_gt2,y_gt2] = ll2utm(lat_gt2_ds,lon_gt2_ds,24);
            [x_gt3,y_gt3] = ll2utm(lat_gt3_ds,lon_gt3_ds,24);
            [x_gt2_dst,y_gt2_dst] = ll2utm(lat_gt2_dst,lon_gt2_dst,24);

            fig('width',30,'border','on')
            plotHelheim_20180715_rgb
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Helheim Glacier: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end  
            end
            
        case {'GB','gb','Gieseke','gieseke'}
            [x_gt1,y_gt1] = ll2utm(lat_gt1_ds,lon_gt1_ds,21);
            [x_gt2,y_gt2] = ll2utm(lat_gt2_ds,lon_gt2_ds,21);
            [x_gt3,y_gt3] = ll2utm(lat_gt3_ds,lon_gt3_ds,21);
            [x_gt2_dst,y_gt2_dst] = ll2utm(lat_gt2_dst,lon_gt2_dst,21);

            fig('width',30,'border','on')
            plotGB_20180924_rgb
            hold on
            p1 = plot(x_gt1,y_gt1,'r-','linewidth',2);
            p2 = plot(x_gt2,y_gt2,'g-','linewidth',2);
            p3 = plot(x_gt3,y_gt3,'b-','linewidth',2);
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Gieseke Braer: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                text(x_gt2_dst(i),y_gt2_dst(i)+1000,num2str(time_dst(i)))
            end  
            end
                        
        case {'Greenland','greenland'}
            fig('width',30,'border','on')
            hold on
            worldmap greenland
            land = shaperead('landareas', 'UseGeoCoords', true);
            geoshow(land, 'FaceColor', [0.5 0.7 0.5])
            p1 = plotm(lat_gt1_ds,lon_gt1_ds,'r-');
            p2 = plotm(lat_gt2_ds,lon_gt2_ds,'g-');
            p3 = plotm(lat_gt3_ds,lon_gt3_ds,'b-');
            legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
            title({strcat('Greenland: ',string(' '),name) ''},'Interpreter','none')
            if wantTime == 1
            for i = 1:length(time_dst)
                textm(lat_gt2_dst(i),lon_gt2_dst(i)+.5,num2str(time_dst(i)),'Fontsize',5)
            end
            end


        otherwise % Plot on worldmap

        worldmap world
        load coastlines
        [latcells, loncells] = polysplit(coastlat, coastlon);
        plotm(coastlat, coastlon)
        hold on
        p1 = plotm(lat_gt1_ds,lon_gt1_ds,'r-');
        p2 = plotm(lat_gt2_ds,lon_gt2_ds,'g-');
        p3 = plotm(lat_gt3_ds,lon_gt3_ds,'b-');
        legend([p1, p2, p3],strcat('gt1',sbeam),strcat('gt2',sbeam),strcat('gt3',sbeam),'location','southoutside')
        title({name ''},'Interpreter','none') 
        if wantTime == 1
        for i = 1:length(time_dst)
            textm(lat_gt2_dst(i),lon_gt2_dst(i),num2str(time_dst(i)))
        end
        end
    end
end
    
