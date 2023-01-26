function icesat2_track_segs(groundfile,res,glacier)
%
% Function that plots the track segment locations from the DDA-ice results
% (usually the 1km segments in the DDA plots e.g. seg0, seg1 etc.)
%
% Inputs:  groundfile (string): path to the ground estimate file from the DDA ouput
%          (usually called  ground_estimate_pass0.txt)
%          res (int): resolution or length of the track segments in meters (usually
%          1000 m)
%          glacier (string): Glacier to plot on. Only Negribreen is
%          implmented as of 11/4/21
%
%

% Load DDA ground estimate: 
% Format:[bin_lon, bin_lat, bin_elev, bin_distance, bin_time, bin_elev_stdev, bin_density_mean, bin_weighted_stdev][bin_lon, bin_lat, bin_elev, bin_distance, bin_time, bin_elev_stdev, bin_density_mean, bin_weighted_stdev]
D = load(groundfile);

at = D(:,4);
startat = at(1);
[x,y] = ll2utm(D(:,2),D(:,1),33);

numsegs = ceil((at(end)-startat)/res);

% Plot
fig('width',40,'border','on')
% ADD ADDITIONAL GLACIERS HERE %
switch glacier
    case {'negri','Negri','negribreen','Negribreen','negri2019'}
        plotNegri_20190805_rgb
end

hold on

for i = 1:numsegs
    datatempbool = (at>= startat+(i-1)*res) & (at < startat+i*res);
    xtemp = x(datatempbool);
    ytemp = y(datatempbool);
    plot(xtemp,ytemp,'-','linewidth',3)
    
    lentemp = length(xtemp);
    if lentemp > 0
        midx = xtemp(round(lentemp/2));
        midy = ytemp(round(lentemp/2));
        text(midx,midy,{num2str(i)})
    end
end


    
    
    
    
    
    
        