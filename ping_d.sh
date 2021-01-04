#!/bin/bash

trap '{ echo "Ping deamon stopped." ; exit 1; }' INT
echo "Monitoring internet connection, press Ctrl-C to interrupt."

PING_STATUS="CONNECTED"

file_name=$(date '+%d_%m_%Y-%H_%M_%S');
file_name="pinglogs_$file_name.txt";
echo "SCRIPT STARTED" >> $file_name

log_connection_status()
{
   NEW_STATUS=$1
   if [[ "$NEW_STATUS" != "$PING_STATUS" ]]
   then
      dt=$(date '+%d/%m/%Y %H:%M:%S');
      echo "$dt : $NEW_STATUS" >> $file_name
      PING_STATUS=$NEW_STATUS
   fi
}


while true
do
   sleep 1
   dt=$(date '+%d/%m/%Y %H:%M:%S');
   if ping -q -c 1 siim.ml &>/dev/null
   then
      echo -ne "\r$dt status: CONNECTED"
      log_connection_status "CONNECTED"
   else
      echo -ne "\r$dt status: DISCONNECTED"
      log_connection_status "DISCONNECTED"
   fi
done
exit 0
