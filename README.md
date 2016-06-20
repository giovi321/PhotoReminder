# PhotoReminder
 Bash script that emails pictures on the anniversary when they were shot. Includes GPS coordinates of the picture.
 
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

## How to use the script
### First script (search.sh)
Run the script by defining in which folder it should look for pictures (NOTE: all subfolders will be scanned for pictures as well**):

	./search.sh /directory/of/your/pictures

**This option can be changed by changing the option in search.sh file. Check the comments starting on the line 35.

### Second script (search2.sh)
Just run it:

	./search2.sh

### Third script (search3.sh)
Edit the variables containing the email information for sendemail. The message ($message variable) has to be one line only, I suggest to use HTML formatting.
Don not run this script, it is automatically run by the second script.

## Run with cron
The script is intended to be run with cron.

### First script (search.sh)
Should be ran once a year less one day since the scripts finds pictures that are exactly one year old. However, I run it every month as maybe I add older pictures that were not in the folder before and i want them to be parsed in the database soon.

	@monthly cd /path/to/the/script/ && ./search.sh /directory/of/your/pictures

### Second script (search2.sh)
Should be run every day at a specified time, so that you receive one picture every day by email.
The following line runs the script at 12:30PM.

	30 12 * * * cd /path/to/the/script/ && ./search2.sh

### Third script (search3.sh)
Should never be run as it is started automatically by the second script.

## Required packages
* sendemail (see my repository "sendemail-fix" to fix sendemail and use it with gmail)
* ImageMagick
* awk
* printf
* grep
* sed
* head
* tail
