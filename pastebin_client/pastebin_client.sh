#!/bin/bash

api_upload_endpoint="https://pastebin.com/api/api_post.php"
api_download_endpoint="https://pastebin.com/raw/"

function upload() {
    api_option="paste"
    api_dev_key=$PASTEBIN_TOKEN
    api_paste_code="$1"
    api_paste_format="$2"
    
    link=$(curl -s -d "api_option=$api_option&api_dev_key=$api_dev_key&api_paste_code=$api_paste_code&api_paste_format=$api_paste_format" $api_upload_endpoint)
    echo ${link##*/}
}

function download() {
    curl -s "$api_download_endpoint$1"
}

function get_pastebin_format() {
    case "$1" in
        asm) echo "asm"
        ;;
        
        awk) echo "awk"
        ;;
        
        bash) echo "bash"
        ;;
        
        c) echo "c"
        ;;
        
        cs) echo "csharp"
        
        cpp) echo "cpp"
        ;;
        
        py) echo "python"
        ;;
        
        java) echo "java"
        ;;
        
        js) echo "javascript"
        ;;
        
        kt) echo "kotlin"
        ;;
        
        php) echo "php"
        ;;
        
        sql) echo "sql"
        ;;
        
        xml) echo "xml"
        ;;
        
        rs) echo "rust"
        ;;
}

function print() {
    if [ -n "$2" ]
    then
        echo "$1" > "$2"
    else
        echo "$1"
    fi
}

function read() {
    if [ -n "$1" ]
    then 
        cat "$1"
    else
        cat
    fi
}

if [ -n "$PASTEBIN_TOKEN" ]
then

    while [ -n "$1" ]
    do
        case "$1" in
            -f) input_file="$2"
            shift ;;
            
            -t) format="$2"
            shift ;;
        
            -o) output_file="$2"
            shift ;;
        
            *) 
            break ;;
        esac
        shift
    done
    
    if [ -n "$1" ] && [ -z "$format" ] && [ -z "$input_file" ]
    then
        code=$(download "$1")
        print "$code" "$output_file"
    else
        if  [ -z "$1" ]
        then
            code="$(read "$input_file")"
            if [ -z "$format" ]
            then
                if [ -z "$input_file" ]
                then
                    input_file="text"
                else
                    input_file="$(get_pastebin_format ${input_file##*.})"
                fi
            fi
            id=$(upload "$code" "$format")
            print "$id" "$output_file"
        else
            echo "Wrong command arguments"
        fi
    fi
else
    echo "PASTEBIN_TOKEN is not set"
fi
