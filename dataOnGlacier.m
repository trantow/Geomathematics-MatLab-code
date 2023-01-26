%% Data = dataOnGlacier(filePath,iceSystem, varargin)
% Author:      Thomas Trantow 
% Description: Gets all data (X,Y,Z,...) on a Glacier system 
%
% Input:
%              filePath  - (String) path of data file : (x,y,elev,...) (default) or (lon,lat,elev,...)
%                          (array) the filePath variable can also be the
%                          actual (X,Y,Z,..) data itself
%              iceSystem - (String) name of ice system. Common options: BBGS, 
%                          Bering, Bagley, Negribreen
%
%              (Optional - varargin)
%                          
%              plot - (String = 'plot') Plot data on glacier
%              save - (String =  'save') write an output file of the data 
%                     on the glacier adds '_on' to file name
%              latlon - (String = 'latlon') if in Lat Lon
%              valOutside - (Double or int) Give a default number for data points outside
%              the glacier. Helpful if you need a square domain. Usual value
%              is a 0 or -9999 (Only input that can be numeric)
% Output:
%              Data - on glacier, (X,Y,Z) of data if UTM, (lon,lat,Z) 
%
% Example call: dataOnGlacier('data/mydata.dat','BBGS','plot','save')
%
% Date:        Original: 04/04/2013
%              Last Modified: 01/13/2016
%-------------------------------------------------------------------------
function Data = dataOnGlacier(filePath,iceSystem, varargin)

close all

%--------ADD CONTOUR FILES HERE--------------
% Use Lon - Lat for contour file
glacier = 0;
switch iceSystem
    case 'BBGS' % Bering-Bagley
        % NEW GLIMS CONTOUR ADDED 01/13/2016
        %contour = load('data/contour_BBGS_glims_v7.dat');
        contour = load('data/contour_BBGS_v12.dat');
        glacier = 1;
    case 'Bagley' % Just Bagley
        contour = load('data/contour_Bagley_v12.dat');
        glacier = 2;
    case 'Bagley_C2' % Bagley for CryoSat data
        contour = load('data/contour_Bagley_C2.dat');
        glacier = 2;
    case 'Bering' % Just Bering
        % NEW GLIMS CONTOUR ADDED 01/13/2016
        contour = load('data/contour_Bering_v12.dat');
        %contour = load('data/contour_v4_1.dat');
        glacier = 3;
    case 'MABEL_strip' %MABEL data over bering for on granulae over rift
        contour = load('data/mabel_strip.dat');
        glacier = 3;
    case 'Negribreen'
        contour = load('data/contour_negri_glims_less_UTM_20170707.dat');
        glacier = 4;
    case 'Negribreen_2015'
        contour = load('data/contour_negri_glims_less_UTM_20150706.dat');
        glacier = 4;
    case 'Tunabreen'
        contour = load('data/contour_tunabreen.dat');
        glacier = 6;
    case 'Negribreen_2015_utm35'
        contour = load('data/contour_negri_glims_less_UTM35_20150706.dat');
        glacier = 5;     
    case 'BBBJ'
        % Bering Glacier plus area around the BBJ
        contour = load('data/contour_BBBJ_v1.dat');
        glacier = 1;
    case '20110415'
        % 20110415 LandSat-7 image domain (crev_model paper)
        contour_utm = [360240 6680925; 389010 6680835; 398010 6705810; 369225 6705965];
        [lat,lon] = utm2deg_bering(contour_utm);
        contour = [lon,lat];
    case '20110314'
        % 20110314 LandSat-7 image domain (crev_model paper)
        terminus = flipud([357150 6672270;360645 6670440; 363765 6669525; 367485 6670785; 369150 6672210; 374985 6674670; 378570 6678900]);
        contour_utm = [356460 6670425; 369825 6706065; 398405 6706005; 388685 6680595; terminus];
        [lat,lon] = utm2deg_bering(contour_utm);
        contour = [lon,lat];
    otherwise
        error('No contour file exists. Please add to m-file or check the input name. Current options: BBGS, Bering, Bagley');
end        

%-------Determine Inputs---------------------
nVarargs = length(varargin);
wantPlot = 0;
wantSave = 0;
type = 1; % Default UTM (1), will be 2 if latlon
outside = 1; % Default value for no assigned data value outside of glacier
for iVars=1:nVarargs
    varTemp = varargin{iVars};
    if isnumeric(varTemp)
        outside = varTemp;
        continue
    end
    switch varTemp
        case 'plot'
            wantPlot = 1;
        case 'save'
            wantSave =1;
        case 'latlon'
            type = 2;
        otherwise
            error('Invalid Input Argument')   
    end
end
%-----Load Data-----------------
data = load(filePath);

%--------Change contour data to XY if need be---------------
if (type == 1) && glacier ~=4 && glacier ~=5 && glacier ~=6% if input is UTM
    [XV,YV,zone] = deg2utm_07V(contour(:,2),contour(:,1));
elseif (type ==2) || glacier==4 || glacier ==5 || glacier==6% if input is LatLon (or UTM for negri)
    XV = contour(:,1);
    YV = contour(:,2);
end

X = data(:,1);
Y = data(:,2);
ELEV = data(:,3:end);
[m,n] = size(data);

% Matrix IN: 1 if in or on glacier, 0 otherwise
IN = inpolygon(X,Y,XV,YV);

if (outside == 1)
    
    % Number of Data Points on Glacier
    num = sum(IN);
    
    % Matrix containing elevation only if it is on the glacier
    X_IN = zeros(num,1);
    Y_IN = zeros(num,1);
    ELEV_IN = zeros(num,n-2);
    counter = 1;
    
    for i = 1:length(ELEV)
        if IN(i) == 1
            X_IN(counter) = X(i);
            Y_IN(counter) = Y(i);
            ELEV_IN(counter,:) = ELEV(i,:);
            counter = counter+1;
        end
    end

else
    len = length(ELEV);
    X_IN = zeros(len,1);
    Y_IN = zeros(len,1);
    ELEV_IN = zeros(len,n-2);
    for i = 1:len
        if IN(i) == 1
            X_IN(i) = X(i);
            Y_IN(i) = Y(i);
            ELEV_IN(i,:) = ELEV(i,:);
        else
            X_IN(i) = X(i);
            Y_IN(i) = Y(i);
            ELEV_IN(i,:) = outside;
        end
    end
end
Data = [X_IN,Y_IN,ELEV_IN];

%----Save Option---------------------
% Write data to file
if wantSave == 1   
    w = filePath(end-3:end);
    name = strrep(filePath,w,strcat('_on_',iceSystem,'.dat'));
    dlmwrite(name,Data,'delimiter',' ','precision',14) 
end


%------------------- Plot Option-------------------------

if wantPlot ==1
    %---------Convert to LatLon for better plotting------------
    fig1 = figure;
            set(gca,'FontSize',15);
    if glacier == 1 || glacier == 2
        %plot BBGS google pic
        plotBBGS
    elseif glacier == 3
        % plot Bering google pic
        plotBering
        %plotBBGS
    elseif glacier == 4
        % Plot negri
        plotNegri_20170707_rgb
    elseif glacier == 5
        % Plot negri
        plotNegri_20150706_rgb
    elseif glacier == 6
        plotTuna_20180419_rgb
    end
    
   %For better plotting use lat/lon (not for negri)
   if type == 1 && glacier ~=4
        [Y_INll,X_INll] = utm2deg_bering([X_IN,Y_IN]);
   else
       Y_INll = Y_IN;
       X_INll = X_IN;
   end
   
    hold on
    scatter(X_INll,Y_INll,25,ELEV_IN(:,1),'filled')
    grid on
    h = colorbar;
    set(h,'fontsize',20);   
    ylabel(h, 'elevation (m)','FontSize',20);
    caxis([min(ELEV_IN(:,1)) max(ELEV_IN(:,1))]);

end


end