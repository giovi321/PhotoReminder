#!/bin/sh
# PhotoReminder
############### TERNZA PARTE DELLO SCRIPT ###############
# Decide quale foto inviare prendendola casualmente dal databasematch
# e la invia per email

# Definisce le variabili
databasematch="photodbmatch.csv"
logfile="photodb.log"

echo "["$(date +"%d-%m-%Y %H:%M:%S")"] - Starting script part 3." >>$logfile

# Sceglie a caso una foto dal databasematch assegnandola alla variabile
chosenphoto=$(tail -n+2 "$databasematch" | sort -R | head -n1)

# Definisce le variabili per ciascun dato EXIF della foto
path="$( cut -d ';' -f 1 <<< $chosenphoto )" # questa variabile definisce il file (con path) da allegare alla email
echo "$path"
date="$( cut -d ';' -f 2 <<< $chosenphoto )"
echo "$date"
time="$( cut -d ';' -f 3 <<< $chosenphoto )"
echo "$time"
gps="$( cut -d ';' -f 4 <<< $chosenphoto )"
echo "$gps"

# Prepara il link con le coordinate gps da inserire nella email
gpsmaps=$(echo $gps | sed "s/ /+/g")

# Define variables for sendemail
# Change those variables according to your email provider settings and your preferences
from="someone@somewhere.com"
dest="someoneelse@somewhere.com"
smtp="smtp.gmail.com:587" # Default gmail settings
username="someone@somewhere.com"
pass="VerySecurePassword"
message="<html><p>This picture was shot exactly one year ago!</p><p>Picture date: $date</p><p>Picture time: $time</p><p>GPS coordinates (if available): $gps</p><p>Maps link: <a href="https://www.google.com/maps/place/$gpsmaps/">https://www.google.com/maps/place/$gpsmaps/</a></p></html>"
subject="Picture of the day"

sendemail -f $from -t $dest -u $subject -s $smtp -o tls=yes -xu $username -xp $pass -m $message -a $"path" >>$logfile

# Termina log
echo "["$(date +"%d-%m-%Y %H:%M:%S")"] - Script part 3 finished." >>$logfile
