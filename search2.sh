#!/bin/sh
# PhotoReminder
############### SECONDA PARTE DELLO SCRIPT ###############
# Estrae dati dal database e controlla quali file hanno stessa data di oggi
# e li mette in un databasematch

# Definisce variabili
logfile="photodb.log"
databasematch="photodbmatch.csv"
writeheaderdbmatch="path;date;time;gps"
database="photodb.csv"
OLDIFS=$IFS
IFS=";"
today=$(date +"%Y-%m-%d")

echo "["$(date +"%d-%m-%Y %H:%M:%S")"] - Starting script part 2." >>$logfile

rm $databasematch

# Controlla se il database esiste. Se non esiste lo crea scrivendo header.
# Se esiste controlla se ha un header altrimenti lo crea.
if [[ ! -f "$databasematch" ]]; then
    echo "[$(date +"%d-%m-%Y %H:%M:%S")] - Databasematch deos not exist. Creating databasematch with header." >>$logfile
    echo $writeheaderdbmatch >$databasematch
else
	headerdbmatch=$(head -n1 photodbmatch.csv)
	if [ "$headerdbmatch" = "$writeheaderdbmatch" ] ; then
		:
	else
		sed -i "1s/^/$writeheaderdbmatch\n/" $databasematch
		echo "[$(date +"%d-%m-%Y %H:%M:%S")] - Missing databasematch header. Writing header to databasematch." >>$logfile
	fi
fi

# Controlla se esiste una foto nel database con la data di oggi.
# Se non esiste esce dallo script
if grep -q $today "$database"; then
	:
else
	echo "[$(date +"%d-%m-%Y %H:%M:%S")] - No picture available with today's date ($today). Exiting." >>$logfile
	exit
fi

# Loop per estrarre varie colonne dal database
while read path date time gps
do
	echo "today : $today"
	echo "path : $path"
	echo "date : $date"
	echo "time : $time"
	echo "gps : $gps"
# Controlla per ciascun file se la data della foto corrisponde alla data di oggi
	if [ "`date --date \"$today\" +%s`" -eq "`date --date \"$date\" +%s`" ]; then
		echo "$path;$date;$time;$gps" >>$databasematch
	else
		:
	fi
done < $database
IFS=$OLDIFS

/home/scripts/photo/search3.sh

echo "["$(date +"%d-%m-%Y %H:%M:%S")"] - Script part 2 finished." >>$logfile
