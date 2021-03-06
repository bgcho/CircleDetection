% detect/recognize/register circles
% Last updated: 03/15/2016 by Bill Byung Gu Cho


warning('off', 'all')
th = 1;
no_pick = [2 2];
numIteration = 10000;

pair_no = input('Which pair ? [1-12] ');
optimal_opt = input('Which optimal method: (RANSAC(R) | Exhaustive(E)): ', 's');

src = imread(['../images/pair' num2str(pair_no) '/figure_A.bmp']);
dst = imread(['../images/pair' num2str(pair_no) '/figure_B.bmp']);

% Detect circles and get their centers and radii
[src_centers, src_radii, ~] = imfindcircles(src, [2 30], 'objectpolarity','bright','method','twostage');
[dst_centers, dst_radii, ~] = imfindcircles(dst, [2 30], 'objectpolarity','bright','method','twostage');


% Use the only the circles that are further apart
[src_centers_far, src_radii_far]= pickFarCircles(src_centers, src_radii, no_pick(1));
[dst_centers_far, dst_radii_far] = pickFarCircles(dst_centers, dst_radii, no_pick(2));

switch lower(optimal_opt)
case {'r','ransac'}
  H = findOptimalAffineRANSAC(src_centers_far, src_radii_far, dst_centers_far, dst_radii_far, th, numIteration);
case {'e', 'exhaustive'}
  H = findOptimalAffineExhaust(src_centers_far, src_radii_far, dst_centers_far, dst_radii_far, th, numIteration);
end
H_matlab = [H(1:2,:).' [0 0 1].'];

T = affine2d(H_matlab);
srcW = imwarp(src, T);
corr_map = xcorr2(srcW, dst);
[~, max_indx] = max(corr_map(:));
[yshift, xshift] = ind2sub([size(corr_map,1), size(corr_map,2)], max_indx);
xshift = xshift - (size(dst,2)-1);
yshift = yshift - (size(dst,1)-1);
srcW = srcW(yshift:yshift+size(dst,1)-1,xshift:xshift+size(dst,2)-1);

figure; set(gcf,'position', [3 34 998 288])
subplot(131)
h1 = imshow(src); hold on;
viscircles(src_centers, src_radii,'edgecolor','r','linewidth',2);
title('Image A')
subplot(132)
h2 = imshow(srcW);
title('Warped Image A')
subplot(133)
h3 = imshow(dst); hold on;
viscircles(dst_centers, dst_radii,'edgecolor','r','linewidth',2);
title('Image B')

issave = input('Save image ? (y/n): ' ,'s');
if strcmp(issave,'y')
  saveas(gcf,['../images/pair' num2str(pair_no) '/AWB'],'fig')
  saveas(gcf,['../images/pair' num2str(pair_no) '/AWB'],'png')
  saveas(gcf,['../images/pair' num2str(pair_no) '/AWB'],'epsc')
end
