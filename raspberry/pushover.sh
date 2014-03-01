#!/usr/bin/env sh

##
# File: pushover.sh
# Autor: Giovane Boaviagem Ribeiro (based on script available in: http://ryonsherman.blogspot.com.br/2012/10/shell-script-to-send-pushover.html)
# Thanks, Ryon!
#
# License: GPL
# 
# Usage: 
#	pushover.sh <app_name> <title> <message>
# 
# Visit http://pushover.net to register your user and your applications
##

CONF_FILE="$HOME/.pushover.conf.d"
NUM_PARAMS=$#

#
#
#
_help(){
echo "************************************************"
echo "*"
echo "* Script file to send messages to Pushover"
echo "* Author: Giovane Boaviagem"
echo "* For more informations: http://pushover.net"
echo "*"
echo "* Usage: $0 [options] [parameters]"
echo "* Options:"
echo "*		hp: Displays this message"
echo "*		ad <app_name>: Adds a new app name/key to database"
echo "*		rm <app_name>: Remove the app_name to database"
echo "*		sd <app_name> <title> <message>: Send a message with title"
echo "*"
echo "* Examples:"
echo "*		$0 hp"
echo "*		$0 ad <app_name>"
echo "*		$0 rm <app_name>"
echo "*		$0 sd <app_name> <title> <message>"
echo "************************************************"
}

#
#
#
add_api_key(){
if [ ! $# -eq 1 ] ; then
echo "Invalid # of parameters"
_help
exit
fi

API_NAME=$1

echo "Including the key for app $API_NAME"
echo -n "* Digit the app key: "
read API_KEY
echo "$API_KEY" > $CONF_FILE/$API_NAME
exit
}

#
#
#
rm_api_key(){
if [ ! $# -eq 1 ] ; then
_help
exit
fi

API_NAME=$1

echo -n "Are you sure to remove the key to app $API_NAME (y/n)?"
read option
case $option in
	s) rm $CONF_FILE/$API_NAME ;;
	n) exit ;;
	*) exit ;;
esac
}

#
#
#
send(){
if [ ! $# -eq 3 ] ; then
	echo "Invalid # of parameters"
	_help
	exit
fi

APP_NAME="$1"
TITLE="$2"
MESSAGE="$3"
USER_KEY=`cat $CONF_FILE/_USER_KEY`
DEVICE=`cat $CONF_FILE/_DEVICE`
API_KEY=`cat $CONF_FILE/$APP_NAME`

curl \
-F "token=${API_KEY}" \
-F "user=${USER_KEY}" \
-F "device=${DEVICE}" \
-F "title=${TITLE}" \
-F "message=${MESSAGE}" \
"https://api.pushover.net/1/messages.json" > /dev/null 2>&1
}

if [ ! -e $CONF_FILE ] ; then
_help
mkdir $CONF_FILE
#echo "********************************************************"
echo "* Pushover script"
echo "* Access your profile in http://pushover.net for more"
echo "* informations to obtain your keys."
echo "*"
echo -n "* User key: "
read USER_KEY
echo "$USER_KEY" > $CONF_FILE/_USER_KEY
echo -n "* Device name [optional]: "
read DEVICE
if [ -z $DEVICE ] ; then
	DEVICE=""
fi
echo "$DEVICE" >> $CONF_FILE/_DEVICE
while true; do
echo -n "* Would you like to add api keys (y/n)?"
read option
case $option in
	y) add_api_key ;;
	n) break ;;
	*) echo "** Incorrect option." ;;
esac
done
echo "********************************************************"
exit
fi

case $1 in
	hp) _help ;;
	ad) add_api_key "$2";;
	rm) rm_api_key "$2";;
	sd) send "$2" "$3" "$4";;
	*) echo "Incorrect Option."
		_help 
	;;
esac
