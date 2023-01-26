% Date: 2018-03-19
% Author: Thomas Trantow
% Purpose: Plot the bering image from google maps.

tmAxis = [400000 500000 6680000 6730000];
%tmAxis = [-144.520933 -142.04 59.8175 60.7150561];

% Google image
[tmImg,tmMap]=imread('data/bagley_20130402_L8B8.png');

% Google
hi = image([400000, 500000], [6680000, 6730000], tmImg);
% Nasa
%hi = image([-144.520933, -142.04], [59.8175, 60.7250561], tmImg);

set(gca, 'YDir','normal','FontSize',15);
axis(tmAxis);
%daspect([2,1,1])
%axis([-143.7 -142.3 60.1 60.55])