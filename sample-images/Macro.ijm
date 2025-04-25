// USAGE: Use in FIJI
//
// Author: Marnie L Maddock (University of Wollongong)
// mmaddock@uow.edu.au, mlm715@uowmail.edu.au
// 5.07.2024
// Count number of Objects in a Channel

/*
This macro will take an image and:
1. Run a max projection,
2. Split the channels,
3. Unsharp mask, 
4. Convert to binary,
5. Analyze particles (count objects),
6. Save the results and summary files.
*/

// Instructions
// Open image in FIJI
// Press run on macro
// Select folder to save results
// Specify which channel the objects you want to count
// Macro will automatically run. A pop-up box will appear once the macro has completed.

// create a pop-up box that allows user to specify what channel to count objects in
Dialog.create("Specify Channel Number to Count Objects");
Dialog.addNumber("Channel number for analyze particles", 1); // Instructions, with 1 being default
Dialog.show; // Display dialog box

// save number entered by user to channel_num
channel_num = Dialog.getNumber();

// ===== Setup Directories =====
// Choose source directory and create subdirectories for CSV results and ROI images.
dir1 = getDirectory("Choose Source Directory of images");
resultsDir = dir1+"CSV_results/";
resultsDir2 = dir1+"ROI_images/";
File.makeDirectory(resultsDir);
File.makeDirectory(resultsDir2);

// Process all .tif files in the source directory.
processFolder(dir1);
function processFolder(dir1) {
    list = getFileList(dir1);
    list = Array.sort(list);
    for (i = 0; i < list.length; i++) {
        if (endsWith(list[i], ".tif")) {
            processFile(dir1, resultsDir, list[i]);
        }
    }
} 

// ===== Process Each Image =====
function processFile(dir1, resultsDir, file){
	// Open the image and get its title.
	open(dir1 + File.separator + file);
	title = getTitle();
	
	
// Make max projection of z stack
run("Z Project...", "projection=[Max Intensity]");
//Split the channels
run("Split Channels");
//Select the image window to be counted (as specified by channel_num
selectImage("C" + channel_num + "-MAX_" + title);
// Sharpen image using unsharp mask
run("Unsharp Mask...", "radius=1 mask=0.60");
// Make image binary
setOption("BlackBackground", true);
run("Convert to Mask");
// Count objects
run("Analyze Particles...", "  show=Overlay display exclude clear summarize add");

// ===== Save Results =====
selectWindow("Results");
saveAs("Results", resultsDir + "Results_" + title + ".csv");
selectWindow("Summary");
saveAs("Results", resultsDir + "Summary_" + title + ".csv");

if (isOpen("Results")) close("Results");
if (isOpen("Summary")) close("Summary");
roiManager("Deselect"); // Ensure no ROIs are selected
close("*"); // Close all open images

// Sometimes windows need encouraging to close. So we can specfy them by name:
close("Results_" + title + ".csv");
close("Summary_" + title + ".csv");
close("ROI Manager");
}

//close("*"); // Close all open image windows without saving
exit("Done");















