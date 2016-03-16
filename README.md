# CircleDetection

Circle detection and registration code for 2D binary image pairs
- Detect circles in each image
- Center positions and radii are the feature vectors of the detected circles.
- Circles that are far from the mean position in each image were chosen for affine matrix calculation.
- RANSAC/Exhaustive search were used to get the 2D Affine Transform Matrix.
