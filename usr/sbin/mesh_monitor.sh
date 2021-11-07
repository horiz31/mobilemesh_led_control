#!/bin/sh
DWELL=${1:-2}
DEV=${2:-/dev/ttyACM2}
CMD=""
SBIN=/usr/sbin

#mmcmd $DEV

LOG() {
	>&2 echo "$*"
}

do_command() {
	 if [ "$CMD" != "$*" ] ; then
		CMD="$*"
		LOG mmcmd $DEV $CMD
		mmcmd $DEV $CMD
	 else
	 	mmcmd $DEV "AT"
	 fi

}

if [[ $(uci get ledcontrol.@ledcontrol[0].enabled) == 1 ]]; then
	do_command MODE TACTICAL
else	
	do_command MODE NORMAL
fi

while true ; do
	sleep $DWELL
	ss=$(iw dev wlan0 station dump | awk -f $SBIN/station.awk)
	if [ -z "$ss" ] ; then
		do_command LED YELLOW FLASH
		continue
	else
		LOG ss=$ss
		any=false
		for ia in `echo "$ss" | cut -f2 -d,` ; do
			if [ $ia -lt 5000 ] ; then
				do_command LED GREEN
				any=true
				break
			fi
		done
		if ! $any ; then
			do_command LED YELLOW
		fi
	fi
done
