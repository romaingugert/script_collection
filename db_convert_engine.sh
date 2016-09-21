#/usr/bin/env bash

DB="MYDB" # DBNAME
REQUEST="SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '$DB' AND ENGINE = 'MyISAM'"
DEFAULT_EXTRA_FILE="./my.cnf" # MYSQL CONF FILE

echo "mysql --defaults-extra-file=$DEFAULT_EXTRA_FILE --skip-column-names -B -D
$DB -e '$REQUEST'"
TABLES=$(mysql --defaults-extra-file=$DEFAULT_EXTRA_FILE --skip-column-names -B
-D $DB -e "$REQUEST")
for T in $TABLES
do
    mysql --defaults-extra-file=$DEFAULT_EXTRA_FILE -D $DB -e "ALTER TABLE $T ENGINE='InnoDB'"
done
