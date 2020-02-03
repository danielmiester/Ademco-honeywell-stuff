#!/bin/bash 

input="/var/log/ademco"

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

get_event_code () {
    case $1 in
        01)
            echo Fire Alarm  ;;
        02)
            echo Fire Alarm Restore  ;;
        03)
            echo Trouble  ;;
        04)
            echo Trouble Restore  ;;
        05)
            echo Bypass  ;;
        06)
            echo Bypass Restore  ;;
        07)
            echo Close \(Arm\)  ;;
        08)
            echo Open \(Disarm\)  ;;
        0D)
            echo Manual Trigger Test Report  ;;
        0E)
            echo Send a Power-Up Report  ;;
        0F)
            echo Exit Error By User  ;;
        11)
            echo Duress Alarm  ;;
        12)
            echo Duress Restore  ;;
        13)
            echo Telco Line 1 Trouble  ;;
        14)
            echo Telco Line 1 Trouble Restore  ;;
        15)
            echo Bell 1 Disable \(Bypass\)  ;;
        16)
            echo Bell 1 Bypass Restore  ;;
        17)
            echo Remote Close \(Arm\)  ;;
        18)
            echo Remote Open \(Open\)  ;;
        19)
            echo Pager Failed  ;;
        1A)
            echo Pager Restore  ;;
        1B)
            echo AC Loss Dialer Report  ;;
        1C)
            echo AC Restore  ;;
        1D)
            echo Periodic Test Report  ;;
        1E)
            echo Exception Schedule Change   ;;
        1F)
            echo Exit Error By Zone  ;;
        21)
            echo Silent Alarm  ;;
        22)
            echo Silent Alarm Restore  ;;
        23)
            echo Telco Line 2 Trouble  ;;
        24)
            echo Telco Line 2 Trouble Restore  ;;
        25)
            echo Bell 2 Disable \(Bypass\)  ;;
        26)
            echo Bell 2 Bypass Restore  ;;
        27)
            echo Quick Arm \(Close\)  ;;
        29)
            echo System Low Battery  ;;
        2A)
            echo System Low Battery Restore  ;;
        2B)
            echo Access Denial \(General\)  ;;
        2C)
            echo ACS Module AC Loss  ;;
        2D)
            echo Walk Test  ;;
        2E)
            echo Access Schedule Change  ;;
        2F)
            echo Fire Walk Test  ;;
        31)
            echo Audible Alarm  ;;
        32)
            echo Audible Alarm Restore  ;;
        33)
            echo Earth Ground Trouble  ;;
        34)
            echo Earth Ground Trouble Restore  ;;
        35)
            echo Auxiliary Relay Disable \(Bypass\)  ;;
        36)
            echo Auxiliary Relay Bypass Restore  ;;
        37)
            echo Keyswitch Close \(Arm\)  ;;
        38)
            echo Keyswitch Open \(Disarm\)  ;;
        3B)
            echo Door Prop Open  ;;
        3C)
            echo ACS Module Low Battery   ;;
        3D)
            echo Walk Test Exit  ;;
        3E)
            echo Send a Power-Up Report  ;;
        3F)
            echo Fire Walk Test Exit  ;;
        41)
            echo Perimeter Alarm  ;;
        42)
            echo Perimeter Alarm Restore  ;;
        43)
            echo Supervisory Alarm  ;;
        44)
            echo Supervisory Alarm Restore  ;;
        45)
            echo Dialer Disable \(Bypass\)  ;;
        46)
            echo Dialer Bypass Restore  ;;
        47)
            echo Partial Arm  ;;
        48)
            echo Callback Requested  ;;
        4B)
            echo Door Prop Open Restore  ;;
        4C)
            echo Access Point Bypass  ;;
        4D)
            echo Event Log 50 % Full  ;;
        4E)
            echo Program Changed  ;;
        51)
            echo Interior Alarm  ;;
        52)
            echo Interior Alarm Restore  ;;
        53)
            echo Expansion Module Tamper  ;;
        54)
            echo Expansion Module Tamper Restore  ;;
        55)
            echo Vent Zone Bypass  ;;
        56)
            echo Vent Zone Bypass Restore  ;;
        57)
            echo ACM Fail  ;;
        58)
            echo ACM Fail Restore  ;;
        59)
            echo Battery Test Fail  ;;
        5A)
            echo Battery Test Fail Restore  ;;
        5B)
            echo Access Granted  ;;
        5C)
            echo ACS Module Reset  ;;
        5D)
            echo Event Log 90 % Full  ;;
        5E)
            echo Auto-Arm Fail  ;;
        5F)
            echo Cancel By User  ;;
        61)
            echo 24 Hour Zone Alarm  ;;
        62)
            echo 24 Hour Zone Alarm Restore  ;;
        63)
            echo Loss of RF Supervision  ;;
        64)
            echo RF Supervision Restore  ;;
        65)
            echo ACS Test Entry  ;;
        66)
            echo ACS Test Exit  ;;
        67)
            echo Auto-Arm  ;;
        68)
            echo Auto Disarm  ;;
        69)
            echo RF Jam Fail  ;;
        6A)
            echo RF Jam Restore  ;;
        6B)
            echo Egress Denied \(General\)  ;;
        6C)
            echo Access Point Relay Supervision Fail  ;;
        6D)
            echo Event Log Overwrite  ;;
        6E)
            echo Off-Normal Report  ;;
        6F)
            echo Fire Drill Begin  ;;
        71)
            echo Day/Night Alarm  ;;
        72)
            echo Day/Night Alarm Restore  ;;
        73)
            echo RPM Supervision Trouble  ;;
        74)
            echo RPM Supervision Trouble Restore  ;;
        76)
            echo Engineer Reset  ;;
        77)
            echo Dialer Shutdown Restore  ;;
        78)
            echo Dialer Shutdown  ;;
        79)
            echo System Shutdown  ;;
        7A)
            echo System Shutdown Restore  ;;
        7B)
            echo Door Forced Open  ;;
        7C)
            echo ACS Module Self-Test Fail  ;;
        7D)
            echo Event Log Reset  ;;
        7E)
            echo Fire Point Tested OK  ;;
        7F)
            echo Fire Drill End  ;;
        81)
            echo Entry/Exit Alarm  ;;
        82)
            echo Entry/Exit Alarm Restore  ;;
        83)
            echo ACS Relay Supervision Trouble  ;;
        84)
            echo ACS Relay Supervision Restore  ;;
        85)
            echo UCS Fail  ;;
        86)
            echo UCS Fail Restore  ;;
        87)
            echo Log System Shutdown Restore  ;;
        88)
            echo Log System Shutdown  ;;
        89)
            echo RF Low Battery  ;;
        8A)
            echo RF Low Battery Restore  ;;
        8B)
            echo Door Forced Open Restore  ;;
        8C)
            echo Access Point DSM Shunt  ;;
        8D)
            echo Time Clock Reset  ;;
        8E)
            echo Fire Point Not Tested  ;;
        91)
            echo Polling Loop Short Alarm  ;;
        92)
            echo Polling Loop Short Alarm Restore  ;;
        93)
            echo Polling Loop Short Trouble  ;;
        94)
            echo Polling Loop Short Trouble Restore  ;;
        95)
            echo ACS Relay/Trigger Disable  ;;
        96)
            echo ACS Relay/Trigger Enable  ;;
        97)
            echo ACS Reader Disable  ;;
        98)
            echo ACS Reader Enable  ;;
        99)
            echo ACS Zone Alarm  ;;
        9A)
            echo ACS Zone Alarm Restore  ;;
        9B)
            echo Egress Granted  ;;
        9C)
            echo Access Point DSM Unshunt  ;;
        9D)
            echo Time Clock Error   ;;
        9E)
            echo Recent Close By User  ;;
        A1)
            echo RF Expansion Module Fail  ;;
        A2)
            echo RF Expansion Module Fail Restore  ;;
        A3)
            echo Expansion Module Fail  ;;
        A4)
            echo Expansion Module Fail Restore  ;;
        A5)
            echo ACS Zone Shunt  ;;
        A6)
            echo ACS Zone Unshunt  ;;
        A7)
            echo Access Point RTE Trouble  ;;
        A8)
            echo Access Point RTE Trouble Restore  ;;
        A9)
            echo Access Point DSM Trouble  ;;
        AA)
            echo Access Point DSM Trouble Restore  ;;
        AB)
            echo Access Point RTE Shunt  ;;
        AC)
            echo Access Point RTE Unshunt  ;;
        AD)
            echo Program Mode Entry  ;;
        AE)
            echo Listen-In To Follow  ;;
        B1)
            echo 24 Hour Auxiliary Alarm  ;;
        B2)
            echo 24 Hour Auxiliary Alarm Restore  ;;
        B3)
            echo Sensor Tamper  ;;
        B4)
            echo Sensor Tamper Restore  ;;
        B5)
            echo Cross Zone Trouble  ;;
        B6)
            echo Cross Zone Trouble Restore  ;;
        B7)
            echo Arm STAY  ;;
        BB)
            echo ACS Program Entry  ;;
        BC)
            echo ACS Module AC Restore  ;;
        BD)
            echo Program Mode Exit  ;;
        BE)
            echo Fire Point Tested Failed  ;;
        C1)
            echo Smoke Alarm  ;;
        C2)
            echo Smoke Alarm Restore  ;;
        C3)
            echo Fire Trouble  ;;
        C4)
            echo Fire Trouble Restore  ;;
        C7)
            echo Fail To Close  ;;
        C8)
            echo Fail To Open  ;;
        C9)
            echo Hi Sensitivity Signal \(Smoke\)  ;;
        CA)
            echo Hi Sensitivity Signal Restore \(Smoke\)  ;;
        CB)
            echo ACS Program Exit  ;;
        CC)
            echo ACS Module Low Battery Restore  ;;
        CD)
            echo User Code Added  ;;
        D1)
            echo Waterflow Alarm  ;;
        D2)
            echo Waterflow Alarm Restore  ;;
        D3)
            echo Fail To Communicate  ;;
        D4)
            echo Communication Restore  ;;
        D7)
            echo Late Close  ;;
        D8)
            echo Late Open  ;;
        D9)
            echo Low Sensitivity Signal  ;;
        DA)
            echo Low Sensitivity Signal Restore  ;;
        DB)
            echo ACS Threat Change  ;;
        DC)
            echo ACS Point Unbypass  ;;
        DD)
            echo User Code Deleted  ;;
        E1)
            echo Fire Supervisory Alarm  ;;
        E2)
            echo Fire Supervisory Alarm Restore  ;;
        E3)
            echo Bell 1 Trouble  ;;
        E4)
            echo Bell 1 Trouble Restore  ;;
        E7)
            echo Early Close  ;;
        E8)
            echo Early Open  ;;
        E9)
            echo Hi Sensitivity Signal \(PIR\)  ;;
        EA)
            echo Hi Sensitivity Signal Restore \(PIR\)  ;;
        EB)
            echo Duress Access Grant  ;;
        EC)
            echo Access Point Relay Supervision Restore  ;;
        ED)
            echo User Code Changed  ;;
        F3)
            echo Bell 2 Trouble  ;;
        F4)
            echo Bell 2 Trouble Restore  ;;
        F5)
            echo Faults  ;;
        F6)
            echo Fault Restore  ;;
        F9)
            echo Low Sensitivity Signal \(PIR\)  ;;
        FA)
            echo Low Sensitivity Signal Restore \(PIR\)  ;;
        FB)
            echo Duress Egress Grant  ;;
        FC)
            echo ACS Self-Test Fail Restore  ;;
        FD)
            echo Fail To Print  ;;
        FE)
            echo Fail To Print Restore   ;;

        *)
            echo Unknown Code $1 ;;
    esac
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
    printf "%s-%s-%s %s:%s Zn:%s Prt:%s User:%s - %s\n" "$y" "$M" "$d" "$h" "$m" "$ZN" "$P" "$US" "$(get_event_code $EC)"
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

done < "$input"

