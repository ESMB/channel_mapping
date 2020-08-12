end_of_filename_for_green="0.tif";	// This is the part that the green section will be taken from (i.e. if lots of files). 
end_of_filename_SR=".tif";	// These are the rest of the files that the red part will be taken from- i.e. to generate the cropped files for SR analysis. 
number_of_frames_to_project=10;



run("Clear Results");

requires("1.33s"); 

   dir = getDirectory("Choose root Directory ");

   count = 0;

   countFiles(dir);

   n = 0;

   setBatchMode(true);

   processFiles(dir);


   

   function countFiles(dir) {

      list = getFileList(dir);

      for (i=0; i<list.length; i++) {

  if (!startsWith(list[i],"Log")){

        if (endsWith(list[i], "/"))

              countFiles(""+dir+list[i]);

          else

              count++;

      }

  }

}

   function processFiles(dir) {

      list = getFileList(dir);

      for (i=0; i<list.length; i++) {

if (!startsWith(list[i],"Log")){

          if (endsWith(list[i], "/"))

              processFiles(""+dir+list[i]);

          else {

             showProgress(n++, count);

             path = dir+list[i];

             processFile(path);

          }

}

      }

  }



  function processFile(path) {

       if (endsWith(path, end_of_filename_for_green)) {

           open(path);



	

file= getTitle();				// image filename.tif 

root = substring(file,0,indexOf(file, ".tif"));		// image rootname



setBatchMode(true);

run("Z Project...", "start=1 stop="+number_of_frames_to_project+" projection=[Average Intensity]");
saveAs("Tiff", ""+dir+"Unmapped.tif");
close();

makeRectangle(0, 256, 512, 512);
run("Crop");

saveAs("Tiff", ""+dir+file+"Bottom_For_SR.tif");

close();










} else if(endsWith(path, end_of_filename_SR)){
	
	open(path);



	

file= getTitle();				// image filename.tif 

root = substring(file,0,indexOf(file, ".tif"));		// image rootname



setBatchMode(true);


makeRectangle(0, 256, 512, 512);
run("Crop");

saveAs("Tiff", ""+dir+file+"Bottom_For_SR.tif");

close();
	
}// End If loop	

}	// End batch processing loop