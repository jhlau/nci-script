#/bin/bash

#spawn a number of child processes to use up the CPU
count=0
children=""

trap "echo $children" EXIT

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

#main job here
#python mnist.py
sleep 180

#main job done; kill off the child processes
for c in $children
do
    kill $c
done
