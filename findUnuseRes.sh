#!/bin/bash

if [ $# -ne 2 ]; then
    echo "$0 <res-path> <code-path>"
    exit 1
fi

res_path=$1
code_path=$2

files=$(find ${res_path})

for file in $files
do
    fileName=$(echo ${file} | awk -F '/' '{print $NF}')
    result=$(grep "$fileName" $code_path/* -rl)
    if [ "$result" == "" ]; then
        formatStr=$(echo $fileName | sed "s/[0-9]\+/%d/g")
        result=$(grep "$formatStr" $code_path/* -rl)
        if [ "$result" == "" ]; then
            fields=($(echo "$fileName" | tr _ " "))
            count=${#fields[@]}
            if [ $count -eq 2 ]; then
                formatStr=${fields[0]:0:-1}%s_${fields[1]}
                result=$(grep "$formatStr" $code_path/* -rl)

                formatStrEx=${fields[0]}_%s${fields[1]:1}
                result_ex=$(grep "$formatStr" $code_path/* -rl)

                if [ "$result" == "" ] && [ "$result_ex" == "" ]; then
                    result=$(grep "$fileName" $res_path/* -rl)
                    if [ "$result" == "" ]; then
                        echo $file
                    fi
                fi
            else
                result=$(grep "$fileName" $res_path/* -rl)
                if [ "$result" == "" ]; then
                    echo $file
                fi
            fi
        fi
    fi
done

