# CircleDetection

Circle detection and registration code for 2D binary image pairs
- Detect circles in each image
- Center positions and radii are the feature vectors of the detected circles.
- Circles that are far from the mean position in each image were chosen for affine matrix calculation. In the current implementation, maximum number of circles set to 40 and 20 respectively in images A and B.
- RANSAC/Exhaustive search were used to get the 2D Affine Transform Matrix. Since affine transform matrix involves two pairs of corresponding points, the total number of combinations that can be used for affine transform matrix calculation is $\frac{\left(40 \times 39\right)\times \left(20 \times 19\right)}{2}$. Assuming the circles in image B exist in image A, the number of combinations that yeilds the correct affine matrix is 20*19
