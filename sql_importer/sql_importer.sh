#!/bin/bash

function make_sql_query() {
    echo "insert into "$1""$2" values "$3""
}

function proccess_csv() {
    local field_names=$(head -1 $1 | awk -f proccess_record.awk )
    local entries_without_last=$(sed -n -e '$d; 2,$p;' "$1" | awk -f proccess_table.awk)
    local last_entry=$(tail -1 "$1" | awk -f proccess_record.awk)
    local entries="$entries_without_last$last_entry"
    
    make_sql_query "$2" "$field_names" "$entries"
}

function proccess_csv_with_title() {
    local title=$(head -2 "$1")
    local tablename=$(echo "$title" | head -1)
    local field_names=$(echo "$title" | tail -1 | awk -f proccess_record.awk )
    local entries_without_last=$(sed -n -e '$d; 3,$p;' "$1" | awk -f proccess_table.awk)
    local last_entry=$(tail -1 "$1" | awk -f proccess_record.awk)
    local entries="$entries_without_last$last_entry"
    
    make_sql_query "$tablename" "$field_names" "$entries"
}

tablename=""
filename=""

while [ -n "$1" ] && [ -z "$filename"]
do
    case "$1" in
        -t) tablename="$2"
        shift;;
        *) filename="$1"
            shift
        break;;
    esac
    shift
done

if [ -z "$1" ]
then
    if [ -n "$tablename" ]
    then
        proccess_csv "$filename" "$tablename"
    else
        proccess_csv_with_title "$filename"
    fi
else
    echo "Wrong arguments"
fi
