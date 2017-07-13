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
//print("The frame interval is",timeInt,Time);

// add headers to results file
// 0 filename, 1 slice, 2 feret (max), 3-4 Feret x-y,
// 5 Feret Angle, 6 Min Feret, 7 time
headers = "Filename,SliceNum,Feret,FeretX,FeretY,FeretAngle,MinFeret,"+Time;
File.append(headers,path + basename + ".csv");

// pre-process
run("Median...", "radius=3 stack"); // smooth while preserving edges

// threshold
setAutoThreshold("MaxEntropy dark stack");
setOption("BlackBackground", true);
run("Convert to Mask", "method=MaxEntropy background=Dark black");
run("Despeckle", "stack"); // get rid of any stray particles

// analyze
run("Analyze Particles...", "display exclude clear include stack");

// parse results
numResults = getValue("results.count");
//print("there are ",numResults," results");
sliceLabels = newArray(numResults);
sliceTimes = newArray(numResults);

selectWindow("Results"); 
// lines = split(getInfo(), "\n"); // array where each element is a row of the table
for (i = 0; i < numResults; i++)
	{
	parsedSlice = split(getResultString("Label",i),":"); // ith row
	sliceLabels[i] = parsedSlice[1];
	sliceTimes[i] = timeInt * sliceLabels[i]  - timeInt; 
	print("for row",i,"the slice number is",sliceLabels[i],"and the time is",sliceTimes[i]);
	// idea - loop through rows and replace colon with comma, slicenum, time (=time * (slicenum-1)), comma
	}


// headings = split(lines[0], "\t"); 
// convert strings to integers
//C1Count = parseInt(C1Values[1]);
//	values = split(lines[i], "\t"); // array where each element is a value in the row -- note this gives you strings

//old method
//String.copyResults;
//newResults = String.paste;
//newResults = substring(newResults,0,lengthOf(newResults)-1); // strip the final newline
//newResults = replace(newResults, "\t",","); // replace tabs with commas for csv
//newResults = replace(newResults, ":",","); // get slice number in a separate column
//File.append(newResults,path + basename + ".csv");

close(); // close the image without saving

// TODO: add a results column with time based on the above
// TODO (maybe): adapt for batch
// TODO (maybe): detect gaps in time

