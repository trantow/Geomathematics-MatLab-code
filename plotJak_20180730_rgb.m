% Date: 2018-10-24
% Author: Thomas Trantow
% Purpose: Plot landsat-8 Jakobshavn (UTM zone 22)

tmAxis = [524942.434382841, 619833.759122905, 7639992.54601657, 7707537.73779944];

% L8 image
[tmImg,tmMap]=imread('data/jak_L8_20180730_rgb_flip.png');

hi = image([524942.434382841, 619833.759122905], [7639992.54601657, 7707537.73779944], tmImg);


set(gca, 'YDir','normal','FontSize',15);
axis(tmAxis);
daspect([1,1,1])
xlabel('UTM-East (m)')
ylabel('UTM-North (m)')
%axis([-143.7 -142.3 60.1 60.55])
%axis([550410 599820 8707395 8756355])