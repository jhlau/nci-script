#/bin/bash




###########################################
###########################################
#add the following lines to your job script

#IMPORTANT: you need to define how many child processes that will
#be created to use the CPU (one child process = 1 CPU). As a rule of thumb, the number of child
#processes should be half of your requested CPUs.
number_of_cpu_processes=3

kill_child_process() { for c in $@; do kill $c; done }

#spawn a number of child processes to use up the CPU
count=0
children=""

while (($count<=1))
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

###########################################
###########################################

#PBS -P cp1
#PBS -q gpu
#PBS -l walltime=20:00:00
#PBS -l mem=300MB
#PBS -l ncpus=6
#PBS -l ngpus=2

#main job here
#python mnist.py
