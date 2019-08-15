#/bin/bash


###################################################################
# add the following lines to your job script
###################################################################

# !!!!! IMPORTANT !!!!!
# You need to define how many child processes (num_child_processes)
# should be created to use the CPUs (one child process = 1 CPU). As
# a rule of thumb,  the number of child processes should be half of
# your requested CPUs. In this example, we can see below we requested
# for 6 cpus (#PBS -l ncpus=6); so we define num_child_processes=3.
# If you're requesting for an odd number of cpus (e.g. #PBS -l ncpus=3),
# round the number up (e.g. num_child_processes=2).

num_child_processes=3 #<--- define the number of child processes here

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

#PBS -P cp1
#PBS -q gpu
#PBS -l walltime=20:00:00
#PBS -l mem=300MB
#PBS -l ncpus=6
#PBS -l ngpus=2

#python mnist.py
