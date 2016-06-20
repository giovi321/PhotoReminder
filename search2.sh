#!/bin/bash
############### SECONDA PARTE DELLO SCRIPT ###############
# Estrae dati dal database e controlla quali file hanno stessa data di oggi
# e li mette in un databasematch

# Definisce variabili
logfile="photodb.log"
databasematch="photodbmatch.csv"
writeheaderdbmatch='path;date;time;gps'
database="photodb.csv"
OLDIFS=$IFS
IFS=";"
today=$(date +"%Y-%m-%d")
#today="2015-04-06"

echo "["$(date +"%d-%m-%Y %H:%M:%S")"] - Starting script part 2." >>$logfile

echo "$writeheaderdbmatch" >$databasematch

# Loop per estrarre varie colonne dal database
while read path date time gps
do
# Controlla per ciascun file se la data della foto corrisponde alla data di oggi
    dates=$(echo $date | cut -c6-10)
    todays=$(date +"%m-%d")
# Se la data della foto corrisponde alla data odierna scrive la linea intera del database in databasematch
    if [[ $todays == $dates ]]; then
        echo "$path;$date;$time;$gps" >>$databasematch
    else
        :
    fi
done < $database
IFS=$OLDIFS

echo "["$(date +"%d-%m-%Y %H:%M:%S")"] - Script part 2 finished." >>$logfile

# Start the third part of the script
./search3.sh
