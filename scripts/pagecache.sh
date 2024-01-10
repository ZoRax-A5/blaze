#!/bin/bash

# This script is used to monitor cache miss performance

pid=$1

# if [ $pid -eq 0 ]; then
# cacheid=$(ps -ef | grep cachetop | grep -v grep | awk '{print $2}')
# kill -SIGINT -$cacheid
# echo $cacheid
# exit
# fi

result_dir="../scripts/results/"

# get the newest directory in ../results/logs/
result_dir=$(ls -td ${result_dir}/*/ | head -1)

# get the newset directory in result_dir
result_dir=$(ls -td ${result_dir}/*/ | head -1)

# get the newest file in result_dir, and remove the suffix
filename=$(ls -t ${result_dir} | head -1 | cut -d'.' -f1)

# Get the cache miss performance for pid
python3 /usr/share/bcc/tools/cachetop -p $pid 1 > ${result_dir}/${filename}.pagecache &