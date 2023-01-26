% Date: 2011-09-30
% Author: Maciej Stachura
% Purpose: Plot the bering image from google maps.

tmAxis = [340000 545000 6650000 6730000];
%tmAxis = [-144.520933 -142.04 59.8175 60.7150561];

% Google image
[tmImg,tmMap]=imread('data/bering_bagley_combine_basemap_flip.png');

% Google
hi = image([340000, 545000], [6650000, 6730000], tmImg);
% Nasa
%hi = image([-144.520933, -142.04], [59.8175, 60.7250561], tmImg);

set(gca, 'YDir','normal','FontSize',15);
axis(tmAxis);
daspect([1,1,1])
grid on
xTick = get(gca,'xTick');
xTickLabel = arrayfun(@(x) sprintf('%3.2f',x),xTick,'uniformoutput', false); 
set(gca, 'xTickLabel', xTickLabel);
yTick = get(gca,'yTick');
yTickLabel = arrayfun(@(y) sprintf('%3.2f',y),yTick,'uniformoutput', false); 
set(gca, 'yTickLabel', yTickLabel);
daspect([1 1 1])
ax = gca;
set(gca,'XTick',[340000:20000:540000])
set(gca,'Ytick',[6660000:20000:6720000])
ax.XTickLabel = {'340' '360' '380' '400' '420' '440' '460' '480' '500' '520' '540' };
ax.YTickLabel = {'6660' '6680' '6700' '6720'};
xlabel('UTM-East (km)')
ylabel('UTM-North (km)')
%axis([-143.7 -142.3 60.1 60.55])