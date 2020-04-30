arr=()
me=$( id -u )

ps -Afc >> process.txt
input=process.txt

for i in $(cat $input | awk '{print $7}' | sort -r | grep -v "TIME"); do arr+=("$i"); done
high_cpu_time="${arr[0]}"


while IFS= read -r line
do
    process=$line
    #echo $process
    if [[ "$process" == *"$high_cpu_time"* ]]
    then 
        proc_arr=()
        
        for a in $process; do proc_arr+=("$a"); done
        
        output_arr=()
        
        for i in $( printf "Process Name is: ${proc_arr[7]}\n | "); do output_arr+= $( printf "\n") && output_arr+=$i && output_arr+=" "; done
        for i in $( printf "Process ID is: ${proc_arr[1]}\n | "); do output_arr+= $( printf "\n") && output_arr+=$i && output_arr+=" "; done
        for i in $( printf "Start time is: ${proc_arr[4]}\n | "); do output_arr+= $( printf "\n") && output_arr+=$i && output_arr+=" "; done
        for i in $( printf "CPU Time is: ${high_cpu_time}\n | "); do output_arr+= $( printf "\n") && output_arr+=$i && output_arr+=" "; done
        
        me=$( id -u )
        
    fi

done < "$input"

printf "\nHere are the stats around the longest running process: \n\n" > process_log.txt
echo $output_arr >> process_log.txt
printf "\n\nHere is a list of processes owned by my user:\n" >> process_log.txt
ps -Afc | grep $me >> process_log.txt

cat process_log.txt
