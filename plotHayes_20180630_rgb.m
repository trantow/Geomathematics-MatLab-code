% Date: 2018-07-14
% Author: Thomas Trantow
% Purpose: Plot landsat-8 Hayesbreen

tmAxis = [573300, 590850, 8694000, 8708790];
%tmAxis = [-144.520933 -142.04 59.8175 60.7150561];

% Google image
[tmImg,tmMap]=imread('data/Hayesbreen_20180630_rgb_flip.png');

% Google
hi = image([573300, 590850], [8694000, 8708790], tmImg);
% Nasa
%hi = image([-144.520933, -142.04], [59.8175, 60.7250561], tmImg);

set(gca, 'YDir','normal','FontSize',15);
axis(tmAxis);
daspect([1,1,1])
xlabel('UTM-East (m)')
ylabel('UTM-North (m)')
%axis([-143.7 -142.3 60.1 60.55])
%axis([550410 599820 8707395 8756355])