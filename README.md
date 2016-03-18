# CircleDetection

Circle detection and registration code for 2D binary image pairs
- Detect circles in each image
- Center positions and radii are the feature vectors of the detected circles.
- Circles that are far from the mean position in each image were chosen for affine matrix calculation. In the current implementation, maximum number of circles set to 40 and 20 respectively in images A and B.
- RANSAC/Exhaustive search were used to get the 2D Affine Transform Matrix. Since affine transform matrix involves two pairs of corresponding points, the total number of combinations that can be used for affine transform matrix calculation is (40x39)x(20x19)/2. Assuming the circles in image B exist in image A, the number of combinations that yeilds the correct affine matrix is 20x19. Therefore, the probability to get a correct pair is 1/(20x39). In the current implementation, the maximum number of iteration is set to 10,000 such that the expected number of the correct pairs within the iteration is approximately 13.
