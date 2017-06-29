// crop_To_Roi.ijm
// ImageJ/Fiji macro by Theresa Swayne, tcs6@cumc.columbia.edu, 2017
// Input: An image or stack, and a set of ROIs in the ROI manager 
// Output: A cropped image or stack for each ROI. 
// 		Output images are numbered from 1 to the number of ROIs, 
//		and are saved in the same folder as the source image.
//		Non-rectangular ROIs are cropped to their bounding box.
// Usage: Open an image. For each area you want to crop out, 
// 		draw an ROI and press T to add to the ROI Manager.
//		Then run the macro.

path = getDirectory("image");
id = getImageID();
title = getTitle();
dotIndex = indexOf(title, ".");
basename = substring(title, 0, dotIndex);

// make sure nothing selected to begin with
selectImage(id);
roiManager("Deselect");
run("Select None");

numROIs = roiManager("count");
for(roiIndex=0; roiIndex < numROIs; roiIndex++) // loop through ROIs
	{ 
	selectImage(id);
	roiNum = roiIndex + 1; // image names starts with 1 like the ROI labels
	cropName = basename+"_crop"+roiNum;
	roiManager("Select", roiIndex);  // ROI indices start with 0
	run("Duplicate...", "title=&cropName duplicate"); // creates the cropped stack
	selectWindow(cropName);
	saveAs("tiff", path+getTitle);
	close();
	}	
run("Select None");

// TODO: save the ROIset and a snapshot