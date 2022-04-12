#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
if [ "$1" = "--help" ]
then
	printf "${GREEN}--help   Print flags description${NC}\n"
	printf "${GREEN}-p       Start scan ports${NC}\n"
	exit
fi
start_check (){
	printf "${GREEN}Start check users with empty password${NC}\n"
	sleep 2
	users=`awk -F":" '($2 == "") {print $1}' /etc/shadow`
	printf "${RED}Warning!${NC} User without password: ${BLUE}${users}${NC}\n"
	if [ -n "$2" ]
	then
		ports=$2
	else
		ports=2000
	fi
	if [ "$1" = "-p" ]
	then
		sleep 2
		printf "${GREEN}Start check open ports${NC}\n"
		for PORT in $(seq 20 $ports); do
			if [[ `lsof -i:$PORT` ]]
			then
				printf "${RED}port $PORT is open${NC}\n"
			fi
		done
	fi
	ssh_conf="/etc/ssh/ssh_config"
	IFS=$'\n#'    
	for var in $(cat $ssh_conf); do
		if [ "$var" = "   PasswordAuthentication yes" ]
		then
			printf "${RED}Warning!${NC} PasswordAuthentication ${BLUE}enable${NC}\n"
		fi
	done
	exit
}
start_check "$1" $2
