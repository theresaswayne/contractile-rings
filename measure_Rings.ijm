// measure_Rings.ijm
// IJ1 macro to process, threshold, and measure diameter of yeast contractile rings
// Theresa Swayne, for Pon lab, 2017
// input: single-channel max projection containing one ring (extraneous structures are ok if touching edges)
// output: a csv file containing measurements and slice number
// limitations: 
//	the image must be saved first (will quit with error if it's not saved)
//  data will be appended to existing csv file with the same name

// setup
run("Set Measurements...", "feret's stack display redirect=None decimal=3");
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
// [row], filename, feret (max), slice, 
// Feret x, Feret y, Angle, Min Feret, elapsed time 
headers = "Row, Filename,Feret,SliceNum,FeretX,FeretY,FeretAngle,MinFeret,"+Time;
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
lines = split(getInfo(), "\n"); // array where each element is a row of the table
for (i = 1; i < numResults+1; i++) // start at 1 because in the lines array, row 0 is headers 
	{
//	parsedSlice = split(getResultString("Label",i),":"); // ith row
//	sliceLabels[i] = parsedSlice[1];
	sliceNum = getResult("Slice", i-1); // start at 0 because in the getResult world, row 0 is the 1st result 
	sliceTime = timeInt * (sliceNum - 1); 
	print("for row",i,"the slice number is",sliceNum,"and the time is",sliceTime);
//	timeString = ","+sliceLabels[i]+","+sliceTimes[i]+",";
//	print("for row",i,"the timeString is ",timeString);
//	resultsRow = replace(lines[i],":",timeString);	
	resultsRow = replace(lines[i], "\t",","); // replace tabs with commas for csv
	resultsRow = resultsRow + ","+sliceTime;
	File.append(resultsRow,path + basename + ".csv");
	}

// TODO: get rid of row numbers

close(); // close the image without saving

// TODO (maybe): adapt for batch
// TODO (maybe): detect gaps in time

