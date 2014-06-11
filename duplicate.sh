#!/bin/bash
SOURCE_DB_HOST=""
SOURCE_DB_USER=""
SOURCE_DB_PASSWORD=""
SOURCE_DB_NAME=""

DEST_DB_HOST=""
DEST_DB_USER=""
DEST_DB_PASSWORD=""
DEST_DB_NAME=""

# Stop editing !

spinner() {
    local pid=$!
    local delay=0.5
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

MYSQL=$(which mysql)
AWK=$(which awk)
GREP=$(which grep)
MYSQLDUMP=$(which mysqldump)
 
TABLES=$($MYSQL -h $DEST_DB_HOST -u $DEST_DB_USER -p$DEST_DB_PASSWORD $DEST_DB_NAME -e 'show tables' | $AWK '{ print $1}' | $GREP -v '^Tables' )
 
for t in $TABLES
do
	echo "Dropping $t table"
	$MYSQL -h $DEST_DB_HOST -u $DEST_DB_USER -p$DEST_DB_PASSWORD $DEST_DB_NAME -e "DROP TABLE $t"
done

echo "All tables from $DEST_DB_NAME database have been dropped"

echo "Copying structure and data from $SOURCE_DB_NAME database to $DEST_DB_NAME database"

$MYSQLDUMP -h $SOURCE_DB_HOST -u $SOURCE_DB_USER -p$SOURCE_DB_PASSWORD $SOURCE_DB_NAME | $MYSQL -h $DEST_DB_HOST -u $DEST_DB_USER -p$DEST_DB_PASSWORD $DEST_DB_NAME & spinner $!

echo "Success"
