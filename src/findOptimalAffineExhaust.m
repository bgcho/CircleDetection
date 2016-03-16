function H_final = findOptimalAffine(x1, cr1, x2, cr2, th, max_numLoop)


numLoop = 1;
x1_hom = [x1.' ; ones(1,size(x1,1))];
x2_hom = [x2.' ; ones(1,size(x2,1))];
max_count = 0;
H_final = [];

% keyboard
subPts1 = nchoosek([1:length(cr1)],2);
subPts1 = [subPts1 ; fliplr(subPts1)];
rand_select1 = randperm(length(subPts1));
subPts1 = subPts1(rand_select1,:);
subPts2 = nchoosek([1:length(cr2)],2);
subPts2 = [subPts2 ; fliplr(subPts2)];
rand_select2 = randperm(length(subPts2));
subPts2 = subPts2(rand_select2,:);


% keyboard
for ii = 1:length(subPts1)
  for jj = 1:length(subPts2)

    count = 0;

    H = getAffineMat(x1(subPts1(ii,:),:), x2(subPts2(jj,:),:));
      
    % Warp x1
    x1_warp = H*x1_hom;
    x1_warp = x1_warp(1:2,:).';

    for kk = 1:size(x1_warp,1)
    	[min_dist, corr_indx] = min(sqrt(sum((x2-repmat(x1_warp(kk,:),[size(x2,1),1])).^2, 2)) + cr2-cr1(kk));
    	if min_dist<th
    		count = count + 1;
    	end
    end
    if max_count < count
      max_count = count;
    	disp(['max count = ' num2str(count) ' / ' num2str(min(size(x1,1),size(x2,1)))])
    	H_final = H;    
    end
    numLoop = numLoop + 1;
    if (max_count>=0.9*min(size(x1,1),size(x2,1)) | numLoop>max_numLoop), break; end
  end
  if (max_count>=0.9*min(size(x1,1),size(x2,1)) | numLoop>max_numLoop), break; end
end