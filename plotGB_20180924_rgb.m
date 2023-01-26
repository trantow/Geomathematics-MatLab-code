% Date: 2018-10-24
% Author: Thomas Trantow
% Purpose: Plot landsat-8 Gieseke Braer (UTM zone 21)

tmAxis = [532073.3181592,602100.300060811,8134214.25338617,8203707.64400886];

% L8 image
[tmImg,tmMap]=imread('data/GB_20180924_rgb_flip.png');

hi = image([532073.3181592, 602100.300060811], [8134214.25338617, 8203707.64400886], tmImg);


set(gca, 'YDir','normal','FontSize',15);
axis(tmAxis);
daspect([1,1,1])
xlabel('UTM-East (m)')
ylabel('UTM-North (m)')
%axis([-143.7 -142.3 60.1 60.55])
%axis([550410 599820 8707395 8756355])