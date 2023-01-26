%% landsat_show_bands.m %%%%%%%%%%%%%%%%%%%%%%%%
%
% Display a Landsat-8 geotiff image (single of multiple bands) with geolocated pixels.
%   path (string): Path to Landsat image folder (not to the actual geotiff but to
%   the containing folder that is attained after downloading and unzipping)
%   identifier (string): The name of the containing folder 
%   varargin: (int) bands (e.g. 1,2,3 or 4,8,1,2 or 5) 
%
% Example call: landsat_show_bands('data/','LC08_L1GT_045133_20190102_20190130_01_T2',2,3,4)
%
% Note that this function doesn't make good plots for displaying axes and
% titles. It is best for displaying the full-resolution image so that, for
% example, one can determine where on the glacier the DDA results are. Run
% this code, aply the 'hold on' command and then plot the DDA results (or whatever).
%
% Thomas Trantow
% 07/20/17
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function landsat_show_bands(path,identifier,varargin)
    nVarargs = length(varargin);
    
    close all

    % Determine bands to plot
    switch nVarargs

        case 0 
            
            [A,R] = geotiffread(strcat(path,'/',identifier,'/',identifier,'_B8.TIF'));
        
        case 1
            X = num2str(varargin{1});
            [A,R] = geotiffread(strcat(path,'/',identifier,'/',identifier,'_B',X,'.TIF'));

        case 2
            X1 = num2str(varargin{1});
            X2 = num2str(varargin{2});
            [A1,R] = geotiffread(strcat(path,'/',identifier,'/',identifier,'_B',X1,'.TIF'));
            [A2,R2] = geotiffread(strcat(path,'/',identifier,'/',identifier,'_B',X2,'.TIF'));
            A = cat(3,A2,A1);
        case 3
            X1 = num2str(varargin{1});
            X2 = num2str(varargin{2});
            X3 = num2str(varargin{3});
            [A1,R] = geotiffread(strcat(path,'/',identifier,'/',identifier,'_B',X1,'.TIF'));
            [A2,R2] = geotiffread(strcat(path,'/',identifier,'/',identifier,'_B',X2,'.TIF'));
            [A3,R3] = geotiffread(strcat(path,'/',identifier,'/',identifier,'_B',X3,'.TIF'));
            A = cat(3,A3,A2,A1);
        case 4
            X1 = num2str(varargin{1});
            X2 = num2str(varargin{2});
            X3 = num2str(varargin{3});
            adjust = varargin{4};
            
            X1v = adjust(1);
            X2v = adjust(2);
            X3v = adjust(3);
            
            [A1,R] = geotiffread(strcat(path,'/',identifier,'/',identifier,'_B',X1,'.TIF'));
            [A2,R2] = geotiffread(strcat(path,'/',identifier,'/',identifier,'_B',X2,'.TIF'));
            [A3,R3] = geotiffread(strcat(path,'/',identifier,'/',identifier,'_B',X3,'.TIF'));
            A = cat(3,A3.*X1v,A2.*X2v,A1.*X3v);
    end

    % Get geotiff info
    x = R.XWorldLimits;
    y = R.YWorldLimits;
    
    res = R.SampleSpacingInWorldX; % Assume square pixel
    
    A = flipud(A);
    A = imadjust(A,stretchlim(A)); %This makes the image look better
    
    
    fig('width',35, 'border','on')
    imshow(A, 'XData',[x(1) x(2)],'YData',[y(1) y(2)],'InitialMagnification','fit')
    set(gca,'position',[0 0 1 1],'units','normalized')
    set(gca,'FontSize',15)
    hold on
    set(gca,'YDir','normal')
    %grid on
    %grid minor
    %xlabel('X_{UTM} (m)')
    %ylabel('Y_{UTM} (m)')
    axis equal
    
   
end
    