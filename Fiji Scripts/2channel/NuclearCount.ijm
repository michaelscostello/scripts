// Provides a mask agglutinated cells. 

input = getDirectory("Source Directory"); 
list = getFileList(input); 
output = getDirectory("Output Directory");
setBatchMode(true)


for (i=0; i<list.length; i++) 
{
    image = list[i];
    path = input + image;
    dotIndex = indexOf(image, ".");
    title = substring(image, 0, dotIndex);
    run("Bio-Formats Macro Extensions");
    Ext.setId(path);
    Ext.getCurrentFile(file);
    Ext.getSeriesCount(seriesCount);
    Ext.getSizeZ(sizeZ);

  	run("Bio-Formats Importer", "open=&path autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_");

  	
  			
  			run("Subtract Background...", "rolling=100 sliding");
  			run("Smooth");
  			setOption("BlackBackground", true);
			run("Convert to Mask");
  			run("8-bit");
			run("Dilate");
			run("Dilate");
			run("Dilate");
			run("Dilate");
			run("Fill Holes");
			run("Convert to Mask");
			run("Set Measurements...", "area mean modal min display redirect=None decimal=3");
			run("Analyze Particles...", "size=30-100000000 show=Outlines include summarize add in_situ");
			
			run("From ROI Manager");
       		roiManager("Measure");
       		
       			saveAs("Results",output+image+"Nuclear Values.csv");
			run("Clear Results");
			roiManager("Delete");
       		
	   		print("Analyzed Image"+image);
	   		
	   			saveAs("tiff, dir+title");
       	close("*");
}
