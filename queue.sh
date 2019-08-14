#/bin/bash

#spawn a number of child processes to use up the CPU
count=0
children=""
while (($count<=2))
do
    #spawn a child process
    python -c "while True: pass" &
    #get child process id
    child_pid=$!
    #collect the child processes
    children="$children $child_pid"
    count=$(( count+1 ))
done

#main job here
#python mnist.py

#main job done; kill off the child processes
for c in $children
do
    kill $c
done
