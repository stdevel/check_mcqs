#!/bin/sh
# check_mcqs - check HP MC ServiceGuard quorum server state
#
#

PATH_PLUGINS="/usr/lib64/nagios/plugins"
LOGFILE_QS="/var/log/qs/qs.log"

#print help if -h / --help given
if [ "$1" == "-h" -o "$1" == "--help" ]; then
	echo ''
	echo 'USAGE: check_mcqs [-h/--help] [nodeA,nodeB,...]'
	echo ''
	echo 'Per default check_mcqs only checks whether the qsc binary is running and tcp port 1238 is accessable'
	echo 'It is also possible to assign a list of hosts that need to be connected to the quorum server (specify hosts separated with comma, no spaces).'
	echo 'If this is defined check_mcqs will check the quorum server log file (e.g. /var/log/qs/qs.log) for connected hosts (new lock owners)'
	echo ''
	echo 'Author: Christian Stankowic <info at stankowic hyphen development dot net>'
	echo ''
	exit 0
fi

#check whether the process is running
if [ "$(ps -ef|grep /usr/local/qs/bin/qsc|grep -v grep)" == "" ]; then
	echo "CRITICAL - HP ServiceGuard quorum server not running"
	exit 2
fi

#check whether the port tcp/1238 is accessable
if [ "$($PATH_PLUGINS/check_tcp -p 1238 1>/dev/null 2>&1; echo $?)" != "0" ]; then
	echo "CRITICAL - needed port tcp/1238 is not accessable!"
	exit 2
fi

#check whether needed hosts (parameters to this script) are in logfile (optional)
if [[ "$@" != "" ]]; then
	HOSTS_ONLINE=`grep -i 'New lock owners:' $LOGFILE_QS |tail -n 1|rev|cut -d: -f1|rev|tr -d ' '|tr "," "\n"|sort|tr "\n" ","`
	HOSTS=`echo $@|tr "," "\n"|sort|tr "\n" ","`
	if [ "$(echo $HOSTS_ONLINE|grep `echo $HOSTS`)" == "" ]; then
		MISSING=`echo $HOSTS|sed "s/$HOSTS_ONLINE//g"|tr "," " "`
		echo "CRITICAL - not all required cluster nodes are connected to quorum server! Missing: $MISSING"
		exit 1
	fi
fi

#seems like everything is fine
if [ "$@" ]; then
	echo "OK - quorum server online and all required nodes connected"
else
	echo "OK - quorum server online"
fi
exit 0
