// measure_Rings.ijm
// IJ1 macro to process, threshold, and measure diameter of yeast contractile rings
// Theresa Swayne, for Pon lab, 2017
// input: single-channel max projection containing one ring (extraneous structures are ok if touching edges)
// output: a csv file containing measurements and slice number
// limitations: 
//	the image must be saved first (will quit with error if it's not saved)
//  data will be appended to existing csv file with the same name

// setup
run("Set Measurements...", "feret's display redirect=None decimal=3");
run("Input/Output...", "file=.csv"); 
roiManager("Deselect");
run("Select None");

path = getDirectory("image");
if (path == ""){
	exit("Please save the image first, then re-run the macro.");
}

title = getTitle();
dotIndex = indexOf(title, ".");
basename = substring(title, 0, dotIndex);

// collect time interval
Stack.getUnits(X, Y, Z, Time, Value);
timeInt = Stack.getFrameInterval();
print("The frame interval is",timeInt,Time);

// add headers to results file
// 0 filename, 1 feret (max), 2-3 Feret x-y,
// 4 Feret Angle, 5 Min Feret
headers = "Filename,SliceNum,Feret,FeretX,FeretY,FeretAngle,MinFeret,"+Time;
File.append(headers,path + basename + ".csv");

// pre-process
run("Median...", "radius=3 stack"); // smoothing while preserving edges

// threshold
setAutoThreshold("MaxEntropy dark stack");
setOption("BlackBackground", true);
run("Convert to Mask", "method=MaxEntropy background=Dark black");
run("Despeckle", "stack"); // get rid of any stray particles

// analyze
run("Analyze Particles...", "display exclude clear include stack");

// collect slice numbers from results table
	// columns: 0 row#, 1 label
	// rows: slices with particles

// read data from the Results window
//selectWindow("Results"); 
//lines = split(getInfo(), "\n"); 
//numResults = getValue("results.count");
//sliceLabels = newArray[numResults];
//for (i = 1; i < numResults; i++) {
//	parsedSlice = split(getResultString("Label",i),":"); // ith row
//	sliceLabels[i] = parsedSlice[1];
//	print("for row", i, "the slice is ",sliceLabels[i]);
//	}
	
// headings = split(lines[0], "\t"); 
// C1Values = split(lines[1], "\t"); 

// convert strings to integers
//C1Count = parseInt(C1Values[1]);


// save results
String.copyResults;
newResults = String.paste;
newResults = substring(newResults,0,lengthOf(newResults)-1); // strip the final newline
newResults = replace(newResults, "\t",","); // replace tabs with commas for csv
newResults = replace(newResults, ":",","); // replace colon with commas to get slice number
File.append(newResults,path + basename + ".csv");

close(); // close the image without saving

// TODO: add a results column for time based on the above
// TODO: adapt for batch
// TODO: detect gaps in time

