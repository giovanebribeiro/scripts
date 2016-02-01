#!/bin/bash

FILE3="/tmp/transmission.txt"
echo "Transmission finished downloading \"$TR_TORRENT_NAME\" on $TR_TIME_LOCALTIME" > $FILE3
INPUT=`cat $FILE3`
/usr/local/bin/pushover sd transmission "Torrent Done!" "$INPUT"
