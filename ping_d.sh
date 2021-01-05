#!/bin/bash

trap '{ echo "Ping deamon stopped." ; echo "SCRIPT ENDING (properly)" >> $file_name; exit 1;}' INT
echo "Monitoring internet connection, press Ctrl-C to interrupt."

PING_STATUS="CONNECTED"

DISCONNECTION_TIME=0

file_name=$(date '+%d_%m_%Y-%H_%M_%S');
file_name="pinglogs_$file_name.txt";
echo "SCRIPT STARTED" >> $file_name

log_connection_status()
{
   NEW_STATUS=$1
   if [[ "$NEW_STATUS" != "$PING_STATUS" ]]
   then
      
	if [[ "$NEW_STATUS" == "CONNECTED" ]]
	then
	    
	    DURATION_MESSAGE="(was offline during $DISCONNECTION_TIME seconds)"
	fi
      dt=$(date '+%d/%m/%Y %H:%M:%S');
      echo "$dt : $NEW_STATUS $DURATION_MESSAGE" >> $file_name
      PING_STATUS=$NEW_STATUS
   fi
}


while true
do
   sleep 1
   dt=$(date '+%d/%m/%Y %H:%M:%S');
   if ping -q -c 1 siim.ml &>/dev/null
   then
      echo -ne "\r$dt status: CONNECTED   "
      log_connection_status "CONNECTED"
      DISCONNECTION_TIME=0
   else
      echo -ne "\r$dt status: DISCONNECTED"
      log_connection_status "DISCONNECTED"
      ((DISCONNECTION_TIME+=1))
   fi
done
exit 0
