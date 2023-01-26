% Date: 2018-10-24
% Author: Thomas Trantow
% Purpose: Plot landsat-8 Helheim (UTM zone 24)

tmAxis = [463847.997096494, 574268.782315827, 7332401.81487766, 7426820.19494364];

% L8 image
[tmImg,tmMap]=imread('data/Helheim_20180715_rgb_flip.png');

hi = image([463847.997096494, 574268.782315827], [7332401.81487766, 7426820.19494364], tmImg);


set(gca, 'YDir','normal','FontSize',15);
axis(tmAxis);
daspect([1,1,1])
xlabel('UTM-East (m)')
ylabel('UTM-North (m)')
%axis([-143.7 -142.3 60.1 60.55])
%axis([550410 599820 8707395 8756355])