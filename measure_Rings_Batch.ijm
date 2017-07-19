// @File(label = "Input folder:", style = "directory") inputdir
// @File(label = "Output folder:", style = "directory") outputdir
// @String(label = "File suffix", value = ".tif") suffix

// Note: DO NOT DELETE OR MOVE THE FIRST 3 LINES -- they supply essential parameters.

// measure_Rings.ijm
// IJ1 macro to process, threshold, and measure diameter of yeast contractile rings
// Theresa Swayne, for Pon lab, 2017
// input: folder containing single-channel max projections containing one ring (extraneous structures are ok if touching edges)
// output: a csv file containing measurements
// limitations: 
//	the image must be saved first (will quit with error if it's not saved)
//  If a csv file exists with the same name data will be appended to it

// setup
run("Set Measurements...", "feret's display redirect=None decimal=3");
run("Input/Output...", "file=.csv"); 

setBatchMode(true);

n = 0; // number of images
processFolder(inputdir); // starts the actual processing 

function processFolder(dir1) 
	{ // recursively goes through folders and finds images that match file suffix
	list = getFileList(dir1);
	for (i=0; i<list.length; i++) 
		{
		// print("processing",list[i]);
		if (endsWith(list[i], "/"))
			processFolder(dir1++File.separator+list[i]);
		else if (endsWith(list[i], suffix))
			processImage(dir1, list[i]);
		}
	} // end processFolder

function processImage(dir1, name) 
	{ // processes images found by processFolder
	open(dir1+File.separator+name);
	print(n++, name); // log of image number and names
	
	id = getImageID();
	title = getTitle();
	dotIndex = indexOf(title, ".");
	basename = substring(title, 0, dotIndex);
	
	// add headers to results file
	// 0 filename, 1 feret (max), 2-3 Feret x-y,
	// 4 Feret Angle, 5 Min Feret
	headers = "Filename,Feret,FeretX,FeretY,FeretAngle,MinFeret";
	File.append(headers,outputdir + File.separator + basename + ".csv");

	roiManager("Deselect");
	run("Select None");

	// pre-process
// first trial	run("Median...", "radius=3 stack"); // smoothing while preserving edges
// second trial run("Gaussian Blur...","sigma=1 stack");	
// third trial no filter
	// threshold
	setAutoThreshold("MaxEntropy dark stack");
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=MaxEntropy background=Dark black");
	run("Despeckle", "stack"); // get rid of any stray particles
	
	// analyze
	run("Analyze Particles...", "display exclude clear include stack");
	
	// save results
	String.copyResults;
	newResults = String.paste;
	newResults = substring(newResults,0,lengthOf(newResults)-1); // strip the final newline
	newResults = replace(newResults, "\t",","); // replace tabs with commas for csv
	File.append(newResults,outputdir + File.separator + basename + ".csv");
	
	close(); // close the image without saving
	} // end processImage

