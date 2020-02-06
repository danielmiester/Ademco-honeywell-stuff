#!/bin/bash 

checksum () {
    sum=0
    input=$1
    for i in $(seq 1 ${#input})
    do
        dec=$(printf "%d" "'${input:$i-1:1}")
        sum=$(($sum + $dec))

    done
    sum=$(( -($sum % 256) & 0xff ))
    sum=$(printf "%x\n" "$sum")

    if  [ $sum == $2 ]; then
        return 0
    else
        return -1
    fi 
}
get_partitions () {
    echo $1 | tr -d "0" | grep -o .| sort | tr "\n" ","
}

decode_event () {
    EC=${1:0:2} #0-1
    ZN=${1:2:3} #2-4
    US=${1:5:3} #5-7
    P=${1:8:1} #8
    m=${1:9:2} #9-10
    h=${1:11:2} #11-12
    d=${1:13:2} #13-14
    M=${1:15:2} #15-16
    y=${1:17:2} #17-18
    printf "%s-%s-%s %s:%s Zn:%s Prt:%s User:%s - %s\n" "$y" "$M" "$d" "$h" "$m" "$ZN" "$P" "$US" "$(./getCodeName.sh $EC)"
}
interpret_mode_and_data () {
    mode=$1
    data=$2
    echo -n Mode "$mode $data "

    case $mode in 
        XF)
            echo Communication OFF ;;
        XN)
            echo Communication ON ;;
        OK)
            echo Ready ;;
        AA)
            echo Armed Away by User ${data:0:2}, Code ${data:2,4}, partitions $(get_partitions ${data:6}) ;;
        AH)
            echo Armed Home \(Stay\) by User ${data:0:2}, Code ${data:2,4}, partitions $(get_partitions ${data:6}) ;;
        AI)
            echo Armed Instant by User ${data:0:2}, Code ${data:2,4}, partitions $(get_partitions ${data:6}) ;;
        AM)
            echo Armed Maximum by User ${data:0:2}, Code ${data:2,4}, partitions $(get_partitions ${data:6}) ;;
        AD)
            echo Disarmed by User ${data:0:2}, Code ${data:2,4}, partitions $(get_partitions ${data:6}) ;;
        FA)
            echo Force Armed Away by User ${data:0:2}, Code ${data:2,4}, partitions $(get_partitions ${data:6}) ;;
        FH)
            echo Force Armed Home \(Stay\) by User ${data:0:2}, Code ${data:2,4}, partitions $(get_partitions ${data:6}) ;;
        AS) 
            if [ ${#data} -e 0]; then
                echo Arming Status Request
            else
                echo Arming Status Report: $data
            fi
            ;;
        nq)
            echo Event: $(decode_event $data)
            ;;
        *)
            echo Unknown mode:$mode, data:$data
            ;;
    esac
}


while IFS="\r\n" read -r line
do
    echo -n "$line"
    date=$(echo $line | cut -d' ' -f1,2,3)
    message=$(echo $line | cut -d' ' -f4-)
    len=$((0x${message:0:2}))
    chksum=${message: -2}
    message=${message:0: -2}
    checksum "$message" "$chksum"
    if [ $? -eq 0 ]; then
        echo -n -e "\u001b[32m\u2713 \u001b[0m" 
    else
        echo  -n -e "\u001b[31m\u274c\u001b[0m"
    fi 
    data=${message:2: -2}
    M=${data:0:2}
    data=${data:2}
    echo $(interpret_mode_and_data "$M" "$data")

done < "${1:-/dev/stdin}"

