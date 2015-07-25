# Getting and Cleaning Data Course Project
***
This is the culmination of the course project for the Coursera class, Getting and Cleaning Data.  The project consisted of obtaining the data from two given URLs, combining the two data sets, perform some organization and cleaning of the data and finally returning a "tidy" dataset.

## My Implementation
In this repository is one R script titled 'run_analysis.R' which performs all the necessary tasks of the project.  Each major section of the code is commented to describe what is being performed in that section of the analysis.  
(This was executed on R-Studio version 0.99.446 on Mac (Yosemite) and R 3.2.1, 2015-06-18)

### Included in the Git repository are:
1. An unzipped copy of the data used for this project (as of 2015-07-25)
2. A copy of the tidy data result (tidydata.txt)
3. The script used to get this result (run_analysis.R)
4. The codebook for this project (CodeBook.md)

### Steps to Run the Code
1. Set the working directory for the final output of the tidy file
2. Execute the script run_analysis.R
   + Note: All file downloads are done into a temporary location and are cleaned up after execution automatically
   + Note: This script will download the latest copy of the zip file from the assignment.  If you wish to use a local file, update the sourceDataURL on line 6 to be the location of the zip file
3. Retrieve the file titled tidydata.txt for the final resulting file of tidy data
   + Note: No external libraries are called during the script

### Steps to Read the Tidy Dataset
This dataset was written using the write.table() with option row.name = FALSE  To read the data into R use the command read.table(filename, header=TRUE)