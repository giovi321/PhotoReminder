#!/bin/sh
# PhotoReminder
############### PRIMA PARTE DELLO SCRIPT ###############
# Genera il database

# Definisce variabili
logfile="photodb.log"
database="photodb.csv"
writeheaderdb="path;date;time;gps"

# Inizia log
echo "[$(date +"%d-%m-%Y %H:%M:%S")] - Starting script part 1." >>$logfile

# Controlla se il database esiste. Se non esiste lo crea scrivendo header.
# Se esiste controlla se ha un header altrimenti lo crea.
if [[ ! -f "$database" ]]; then
    echo "[$(date +"%d-%m-%Y %H:%M:%S")] - Database deos not exist. Creating database with header." >>$logfile
    touch $database
    echo $writeheaderdb >$database
    printf "\n" >>$database
else
	headerdb=$(head -n1 photodb.csv)
	if [ "$headerdb" = "$writeheaderdb" ] ; then
		:
	else
		echo "[$(date +"%d-%m-%Y %H:%M:%S")] - Missing database header. Writing header to database." >>$logfile
		sed -i "1s/^/$writeheaderdb\n/" $database
	fi
fi

# Definisce lista files come array
file_list=()
while IFS= read -d $'\0' -r file ; do
    file_list=("${file_list[@]}" "$file")
done < <(find -L "$1" -iname *.jpg -print0)

# Loop per estrarre informazioni
for file in "${file_list[@]}" ; do
# Estrae dir e nome file
    echo -n "$file"";" >>$database
# Estrae data e ora da EXIF info
    identify -verbose -quiet "$file" | grep -e "exif:DateTimeOriginal" | sed "s/exif:DateTimeOriginal: /$nul/g" | sed "s/    /$nul/g" | sed "s/ /;/g" | sed "s/:/-/g" | sed "s/ /;/g" | tr -d '\n' >>$database
# Inserisce separatore csv
    echo -n ";" >>$database
# Estrae dati GPS da EXIF info
	identify -verbose -quiet "$file" | grep -e "exif:GPSLatitude:" -e "exif:GPSLatitudeRef:" -e "exif:GPSLongitude:" -e "exif:GPSLongitudeRef:" | sed "s/    /$nul/g" | sed "s/exif:GPSLatitudeRef: /$nul/g" | sed "s/exif:GPSLongitude:/$nul/g" | sed "s/exif:GPSLongitudeRef: /$nul/g" | sed "s/exif:GPSLatitude: /$nul/g" | sed "s/\/1/$nul/g" | sed "s/,/$nul/g" | tr -d '\n' >>$database
# Scrive nuova linea
    printf "\n" >>$database
done

# Pulisce il database dalle linee vuote
grep '[^[:blank:]]' < $database > database.temp
mv database.temp $database

echo "["$(date +"%d-%m-%Y %H:%M:%S")"] - Script part 1 finished." >>$logfile
