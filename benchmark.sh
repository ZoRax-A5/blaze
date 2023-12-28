#!/bin/bash
# roots:        TT   FS     UK       K28       K29       K30       YW       K31       CW
declare -a rts=(12 801109 5699262 254655025 310059974 233665123 35005211 691502068 739935047)

TEST_CPU_SET="taskset -c 24-47,72-95:1"

DATA_PATH=/mnt/nvme2/blaze/

name[0]=twitter
name[1]=friendster
name[2]=ukdomain
name[3]=kron28
name[4]=kron29
name[5]=kron30
name[6]=yahoo

data[0]=${DATA_PATH}/${name[0]}/${name[0]}
data[1]=${DATA_PATH}/${name[1]}/${name[1]}
data[2]=${DATA_PATH}/${name[2]}/${name[2]}
data[3]=${DATA_PATH}/${name[3]}/${name[3]}
data[4]=${DATA_PATH}/${name[4]}/${name[4]}
data[5]=${DATA_PATH}/${name[5]}/${name[5]}
data[6]=${DATA_PATH}/${name[6]}/${name[6]}

# roots:        TT   FS     UK       K28       K29       K30       YW       K31       CW
declare -a rts=(12 801109 5699262 254655025 310059974 233665123 35005211 691502068 739935047)

clear_pagecaches() { 
    echo "zwx.1005" | sudo -S sysctl -w vm.drop_caches=3;
}

log_time=$(date "+%Y%m%d_%H%M%S")
mkdir -p results/logs/${log_time}
profile_memory() {
    cgroup_limit=true
    eval commandargs="$1"
    eval filename="$2"

    commandname=$(echo $commandargs | awk '{print $1}')

    commandargs="${TEST_CPU_SET} ${commandargs}"

    cur_time=$(date "+%Y-%m-%d %H:%M:%S")

    log_dir="../results/logs/${log_time}"

    echo $cur_time "profile run with command: " $commandargs >> ../results/command.log
    echo $cur_time "profile run with command: " $commandargs > ${log_dir}/${filename}.txt

    $commandargs &>> ${log_dir}/${filename}.txt
    pid=$(ps -ef | grep $commandname | grep -v grep | awk '{print $2}')

    echo "pid: " $pid >> ../results/command.log
}

blaze_performance=true

if $blaze_performance; then
    cd build && make -j50

    outputFile="../results/blaze_query_time.csv"
    title="Blaze"
    cur_time=$(date "+%Y-%m-%d %H:%M:%S")
    echo $cur_time "Test ${title} Query Performace" >> ${outputFile}

    for idx in {0,1,2,3,4,5,6};
    do
        echo -n "Data: "
        echo ${data[$idx]}
        echo -n "Root: "
        echo ${rts[$idx]}

        len=1

        # BFS
        for ((mem=0;mem<$len;mem++))
        do
            clear_pagecaches
            commandargs="./bin/bfs -computeWorkers 48 -startNode ${rts[$idx]} ${data[${idx}]}.gr.index ${data[${idx}]}.gr.adj.0"
            filename="${name[${idx}]}_blaze_bfs"

            profile_memory "\${commandargs}" "\${filename}"
            wait
        done

        # BC
        for ((mem=0;mem<$len;mem++))
        do
            clear_pagecaches
            commandargs="./bin/bc -computeWorkers 48 -startNode ${rts[$idx]} ${data[${idx}]}.gr.index ${data[${idx}]}.gr.adj.0 -inIndexFilename ${data[${idx}]}.tgr.index -inAdjFilenames ${data[${idx}]}.tgr.adj.0"
            filename="${name[${idx}]}_blaze_bc"

            profile_memory "\${commandargs}" "\${filename}"
            wait
        done

        # PageRank
        for ((mem=0;mem<$len;mem++))
        do
            clear_pagecaches
            commandargs="./bin/pagerank -computeWorkers 48 -maxIterations 3 ${data[${idx}]}.gr.index ${data[${idx}]}.gr.adj.0"
            filename="${name[${idx}]}_blaze_pr"

            profile_memory "\${commandargs}" "\${filename}"
            wait
        done

        # Components
        for ((mem=0;mem<$len;mem++))
        do
            clear_pagecaches
            commandargs="./bin/wcc -computeWorkers 48 ${data[${idx}]}.gr.index ${data[${idx}]}.gr.adj.0 -inIndexFilename ${data[${idx}]}.tgr.index -inAdjFilenames ${data[${idx}]}.tgr.adj.0"
            filename="${name[${idx}]}_blaze_cc"

            profile_memory "\${commandargs}" "\${filename}"
            wait
        done
    done
fi