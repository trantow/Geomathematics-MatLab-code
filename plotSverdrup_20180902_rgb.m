% Date: 2018-10-24
% Author: Thomas Trantow
% Purpose: Plot landsat-8 Sverdrup (UTM zone 21)

tmAxis = [452172.641436564,501092.292769854,8368923.76619366,8417332.53295716];

% L8 image
[tmImg,tmMap]=imread('data/Sverdrup_20180902_rgb_flip.png');

hi = image([452172.641436564, 501092.292769854], [8368923.76619366, 8417332.53295716], tmImg);


set(gca, 'YDir','normal','FontSize',15);
axis(tmAxis);
daspect([1,1,1])
xlabel('UTM-East (m)')
ylabel('UTM-North (m)')
%axis([-143.7 -142.3 60.1 60.55])
%axis([550410 599820 8707395 8756355])