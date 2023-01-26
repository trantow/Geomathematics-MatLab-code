% Date: 2011-09-30
% Author: Maciej Stachura
% Purpose: Plot the bering image from google maps.

tmAxis = [340000 460000 6650000 6730000];
%tmAxis = [-144.520933 -142.04 59.8175 60.7150561];

% Google image
[tmImg,tmMap]=imread('data/20130428l8b8.jpg');

% Google
hi = image([340000, 460000], [6650000, 6730000], tmImg);
% Nasa
%hi = image([-144.520933, -142.04], [59.8175, 60.7250561], tmImg);

set(gca, 'YDir','normal','FontSize',15);
axis(tmAxis);
daspect([1,1,1])
xlabel('UTM-East (m)')
ylabel('UTM-North (m)')
%axis([-143.7 -142.3 60.1 60.55])
xTick = get(gca,'xTick');
xTickLabel = arrayfun(@(x) sprintf('%3.2f',x),xTick,'uniformoutput', false); 
set(gca, 'xTickLabel', xTickLabel);
yTick = get(gca,'yTick');
yTickLabel = arrayfun(@(y) sprintf('%3.2f',y),yTick,'uniformoutput', false); 
set(gca, 'yTickLabel', yTickLabel);
daspect([1 1 1])
ax = gca;
set(gca,'XTick',[340000:10000:460000])
set(gca,'Ytick',[6650000:10000:6730000])
ax.XTickLabel = {'340' '350' '360' '370' '380' '390' '400' '410' '420' '430' '440' '450' '460'};
ax.YTickLabel = {'6650' '6660' '6670' '6680' '6690' '6700' '6710' '6720' '6730'};
xlabel('UTM-East (km)')
ylabel('UTM-North (km)')