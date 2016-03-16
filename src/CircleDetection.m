% detect/recognize/register circles
% Last updated: 03/15/2016 by Bill Byung Gu Cho

warning('off', 'all')
pair_no = input('Which pair ? [1-12] ');

src = imread(['../images/pair' num2str(pair_no) '/figure_A.bmp']);
dst = imread(['../images/pair' num2str(pair_no) '/figure_B.bmp']);

% Detect circles and get their centers and radii
[src_centers, src_radii, ~] = imfindcircles(src, [2 30], 'objectpolarity','bright','method','twostage');
[dst_centers, dst_radii, ~] = imfindcircles(dst, [2 30], 'objectpolarity','bright','method','twostage');

H = findOptimalAffine(src_centers, src_radii, dst_centers, dst_radii, 1);
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
h1 = imshow(src);
title('Image A')
subplot(132)
h2 = imshow(srcW);
title('Warped Image A')
subplot(133)
h3 = imshow(dst);
title('Image B')

issave = input('Save image ? (y/n): ' ,'s');
if strcmp(issave,'y')
  saveas(gcf,['../images/pair' num2str(pair_no) '/AWB'],'fig')
  saveas(gcf,['../images/pair' num2str(pair_no) '/AWB'],'png')
  saveas(gcf,['../images/pair' num2str(pair_no) '/AWB'],'epsc')
end