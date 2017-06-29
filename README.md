# contractile-rings
ImageJ scripts for analyzing yeast contractile ring closure

# Installation
(to be updated)

# crop_To_Roi.ijm
This script makes it easier to crop a field of view into multiple individual cells.

## Usage
1. Draw an ROI around a cell or area of interest, and press T to add the ROI to the ROI Manager.
-- The ROI can be any shape, but the cropped image will be a rectangle corresponding to the bounding box of the ROI.
2. Run the script.

## Output
The cropped images will be named <original name>_crop1, <original name>_crop2, etc. and will be saved in the same folder as the original image.
