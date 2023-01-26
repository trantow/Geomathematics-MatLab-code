% Date: 2018-10-24
% Author: Thomas Trantow
% Purpose: Plot landsat-8 Rink (UTM zone 22)

tmAxis = [470800, 565000, 7938000, 8007000];

% L8 image
[tmImg,tmMap]=imread('data/Rink_20180921_rgb_flip.png');

hi = image([470800, 565000], [7938000, 8007000], tmImg);


set(gca, 'YDir','normal','FontSize',15);
axis(tmAxis);
daspect([1,1,1])
xlabel('UTM-East (m)')
ylabel('UTM-North (m)')
%axis([-143.7 -142.3 60.1 60.55])
%axis([550410 599820 8707395 8756355])