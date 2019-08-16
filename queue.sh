#/bin/bash

#PBS -q gpu
#PBS -l walltime=20:00:00
#PBS -l mem=300MB
#PBS -l ncpus=6
#PBS -l ngpus=2


###################################################################
# add the following lines to your job script
###################################################################

# !!!!! IMPORTANT !!!!!
# You need to define how many child processes (num_child_processes)
# should be created to use the CPUs (one child process = 1 CPU). As
# a rule of thumb,  the number of child processes should be
# (ncpus-ngpus). In this example, we can see above we requested for
# 6 cpus (#PBS -l ncpus=6) and 2 gpus (#PBS -l ngpus=2) so we
# set num_child_processes=4.

num_child_processes=4 #<--- define the number of child processes here

kill_child_process() { for c in $@; do kill $c; done }

#spawn a number of child processes to use up the CPU
count=0
children=""

while (($count<$num_child_processes))
do
    #spawn a child process
    nice -19 python -c "while True: pass" &
    #get child process id
    child_pid=$!
    #collect the child processes
    children="$children $child_pid"
    count=$(( count+1 ))
done

#kill off child processes when the main program finishes
trap "kill_child_process $children" EXIT

###################################################################
# end
###################################################################


#main job script
#module load tensorflow/1.8-cudnn7.1-python3.6
#python mnist.py
