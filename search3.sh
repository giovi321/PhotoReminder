#!/bin/bash
############### TERNZA PARTE DELLO SCRIPT ###############
# Decide quale foto inviare prendendola casualmente dal databasematch
# e la invia per email

# Definisce le variabili
databasematch="photodbmatch.csv"
logfile="photodb.log"
chosenphoto="chosenphoto.csv"

echo "["$(date +"%d-%m-%Y %H:%M:%S")"] - Starting script part 3." >>$logfile

# Sceglie a caso una foto dal databasematch assegnandola alla variabile
tail -n+2 "$databasematch" | sort -R | head -n1 >$chosenphoto

# Definisce le variabili per ciascun dato EXIF della foto
path="$( awk -F "\"*;\"*" '{print $1}' $chosenphoto )" # questa variabile definisce il file (con path) da allegare alla email
echo "$path"
date="$( awk -F "\"*;\"*" '{print $2}' $chosenphoto )"
echo "$date"
time="$( awk -F "\"*;\"*" '{print $3}' $chosenphoto )"
echo "$time"
gps="$( awk -F "\"*;\"*" '{print $4}' $chosenphoto )"
echo "$gps"

# Prepara il link con le coordinate gps da inserire nella email
gpsmaps=$(echo $gps | sed "s/ /+/g")

# Definisce variabili per sendemail
from="someone@somewhere.com"
dest="SomeoneElse@somewhere.com"
smtp="smtp.gmail.com:587" # Default gmail settings
username="UserID"
pass="AVerySafePassword"
message="<html><p>This picture was shot exactly one year ago!</p><p>Picture date: $date</p><p>Picture time: $time</p><p>GPS coordinates (if available): $gps</p><p>Maps link: <a href="https://www.google.com/maps/place/$gpsmaps/">https://www.google.com/maps/place/$gpsmaps/</a></p></html>"
subject="Picture of the day"

sendemail -f $from -t $dest -u $subject -s $smtp -o tls=yes -xu $username -xp $pass -m $message -a "$path" >>$logfile

# Termina log
echo "["$(date +"%d-%m-%Y %H:%M:%S")"] - Script part 3 finished." >>$logfile
