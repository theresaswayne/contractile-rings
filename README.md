# contractile-rings
ImageJ scripts for analyzing yeast contractile ring closure

# Installation
1. Download the .zip file to your computer.
2. Unzip the file to get the individual script file(s).
3. In Fiji, _Plugins > Install Plugin_ and choose the script you want to install. Repeat for all scripts as needed.
4. Quit Fiji and re-open it.

---

# crop_To_Roi.ijm
This script makes it easier to crop a field of view into multiple individual cells.

## Usage
1. Draw an ROI around a cell or area of interest, and press T to add the ROI to the ROI Manager.
* The ROI can be any shape; the cropped image will be a rectangle corresponding to the bounding box of the ROI.
2. Repeat for all cells in the field.
3. Run the script.

## Output
All files are saved in the same folder as the original image. 
Output files include:
- Cropped images, named <original name>_crop1.tif, <original name>_crop2.tif, etc. 
- An ROI set containing the ROIs used.
- An RGB flattened snapshot of the ROIs with labels, on the slice that is active at the time the plugin is run.

---

# split_Channels_Param.ijm
This script splits composite images or stacks into  individual channels.

## Usage
1. Place all the images you want to split into a folder.
2. Create an output folder to hold the split images.
3. Run the macro and select your input and output folders when prompted.

## Output

A set of single-channel images, named with prefixes C1, C2, etc.

---

# measure_Rings.ijm
This script measures contractile ring diameter in cropped single-channel projections.

It performs the following processing steps:
* Median filter, 3-pixel radius
* Maximum entropy threshold using the stack histogram
* Despeckle
* Analyze particles, recording Label and Feret diameter to 3 decimal places

## Usage
1. Open a single-channel projected time series.
* The image must have been already saved. If not, the macro will quit and remind you to save it.
2. Run the macro. 
 
## Output
A CSV file containing Feret measurements for each timepoint.

## Limitations
* If a new ring appears near an old one that has just contracted, your measurements will be misleading. You need to check the data to be sure you are measuring a single ring contraction. 

    * Simply delete any measurements after the first ring has fully contracted.  
    * Alternatively, use _Image > Stacks > Tools > Make substack_ to crop the original stack in time.

* The measurements use the same units as your image. If your image has an incorrect scale factor, or none, then your measurements will be incorrect.
