#!/usr/bin/env bash

result_dir=result
disks=/mnt/nvme2/blaze
threads=48

# Run workloads

# roots:        TT   FS     UK       K28       K29       K30       YW       K31       CW
declare -a rts=(12 801109 5699262 254655025 310059974 233665123 35005211 691502068 739935047)

name[0]=twitter
name[1]=friendster
name[2]=ukdomain
name[3]=kron28
name[4]=kron29
name[5]=kron30
name[6]=yahoo

# BFS
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bfs -d ${name[0]} --start_node ${rts[0]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bfs -d ${name[1]} --start_node ${rts[1]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bfs -d ${name[2]} --start_node ${rts[2]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bfs -d ${name[3]} --start_node ${rts[3]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bfs -d ${name[4]} --start_node ${rts[4]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bfs -d ${name[5]} --start_node ${rts[5]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bfs -d ${name[6]} --start_node ${rts[6]}

# PageRank 
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k pagerank -d ${name[0]} --max_iterations 3
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k pagerank -d ${name[1]} --max_iterations 3
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k pagerank -d ${name[2]} --max_iterations 3
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k pagerank -d ${name[3]} --max_iterations 3
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k pagerank -d ${name[4]} --max_iterations 3
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k pagerank -d ${name[5]} --max_iterations 3
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k pagerank -d ${name[6]} --max_iterations 3

# WCC
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k wcc -d ${name[0]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k wcc -d ${name[1]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k wcc -d ${name[2]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k wcc -d ${name[3]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k wcc -d ${name[4]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k wcc -d ${name[5]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k wcc -d ${name[6]}

# SpMV
# ./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k spmv -d rmat27 --max_iterations 1
# ./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k spmv -d uran27 --max_iterations 1
# ./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k spmv -d twitter --max_iterations 1
# ./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k spmv -d sk2005 --max_iterations 1
# ./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k spmv -d friendster --max_iterations 1
# ./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k spmv -d rmat30 --max_iterations 1

# BC
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bc -d ${name[0]} --start_node ${rts[0]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bc -d ${name[1]} --start_node ${rts[1]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bc -d ${name[2]} --start_node ${rts[2]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bc -d ${name[3]} --start_node ${rts[3]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bc -d ${name[4]} --start_node ${rts[4]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bc -d ${name[5]} --start_node ${rts[5]}
./run.py --result_dir ${result_dir} --disks ${disks} -t ${threads} -k bc -d ${name[6]} --start_node ${rts[6]}
# Produce a csv file
./generate_datafile.py blaze configs/figure7.csv time figure7.csv
