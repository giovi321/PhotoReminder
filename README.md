# PhotoReminder
Bash script that emails pictures on the 365th day since when they were shot. Includes GPS coordinates of the picture.

## What does the script do?
The script is divided into three sub-scripts.
### First script (search.sh)
* Looks for all *.jpg files in a folder (and subfolders).
* Parses the following EXIF information
	* Path and name of the file
	* Date when the picture was shot
	* Time when the picture was shot
	* GPS coordinates
* Puts all these information in a database (photodb.csv)

### Second script (search2.sh)
* Reads the photodb.csv database
* Extracts the information of each file
* Compares the date (only the date, not the time) of each pictures with today's date
* Puts all the pictures that match the criteria in a new photodbmatch.csv database
* Starts the third script (search3.sh)

### Third script (search3.sh)
* Reads the databse of the pictures that match today's date
* Picks randomly one of the pictures
* Sends an email (HTML email) containing:
	* Date and time when the picture was shot
	* GPS coordinates of the location where the picture was shot
	* Google Maps link (clickable) with the coordinates of the picture

## Run with cron
The script is intended to be run with cron.

### First script
Should be ran once a year less one day since the scripts finds pictures that are exactly one year old. However, I run it every month as the script can be modified to match pictures that are x days old.

	@monthly /home/scripts/photo/search.sh

### Second script
Should be run every day at a specified time, so that you receive one picture every day by email.
The following line runs the script at 12:30PM.

	30 12 * * * /home/scripts/photo/search2.sh

### Third script
Should never be run as it is started automatically by the second script.

## Required packages
* sendemail (see my repository for fixing sendemail to use with gmail)
* ImageMagick
* awk
* printf
* grep
* sed
* head
* tail
