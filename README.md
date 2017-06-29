# contractile-rings
ImageJ scripts for analyzing yeast contractile ring closure

# Installation
1. Download the .zip file to your computer.
2. Unzip the file to get the individual script file(s).
3. In Fiji, _Plugins > Install Plugin_ and choose the script you want to install. Repeat for all scripts as needed.
4. Quit Fiji and re-open it.

# crop_To_Roi.ijm
This script makes it easier to crop a field of view into multiple individual cells.

## Usage
1. Draw an ROI around a cell or area of interest, and press T to add the ROI to the ROI Manager.
-- The ROI can be any shape, but the cropped image will be a rectangle corresponding to the bounding box of the ROI.
2. Run the script.

## Output
All files are saved in the same folder as the original image.
-- Cropped images named <original name>_crop1, <original name>_crop2, etc. 
-- An ROI set containing the ROIs used.
-- An RGB flattened snapshot of the ROIs with labels on the slice that is active at the time the plugin is run.

