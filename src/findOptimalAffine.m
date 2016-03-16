function H_final = findOptimalAffine(x1, cr1, x2, cr2, th)


numIteration = 10000;
threshold = 1;
x1_hom = [x1.' ; ones(1,size(x1,1))];
x2_hom = [x2.' ; ones(1,size(x2,1))];
max_count = 0;
H_final = [];

for ii = 1:numIteration

  count = 0;

  % select a subset of points 
  subPts1 = randperm( size(x1,1) );
  subPts2 = randperm( size(x2,1) );
  
  % estimate homography using the selected points
  H = getAffineMat(x1(subPts1(1:2),:), x2(subPts2(1:2),:));
    
  % Warp x1
  x1_warp = H*x1_hom;
  x1_warp = x1_warp(1:2,:).';

  for jj = 1:size(x1_warp,1)
  	[min_dist, corr_indx] = min(sqrt(sum((x2-repmat(x1_warp(jj,:),[size(x2,1),1])).^2, 2)) + cr2-cr1(jj));
  	if min_dist<th
  		count = count + 1;
  	end
  end
  if max_count < count
    max_count = count;
  	disp(['max count = ' num2str(count) ' / ' num2str(min(size(x1,1),size(x2,1)))])
  	H_final = H;    
  end

  if max_count==min(size(x1,1),size(x2,1))
    break
  end

end