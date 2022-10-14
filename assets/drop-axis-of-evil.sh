#!/bin/bash
if [ "$(iptables -S | wc -l)" -lt 1000 ]; then
	### Block all traffic from AFGHANISTAN (af) and CHINA (CN). Use ISO code ###
	rm -f /tmp/dropall

	ISO="cn ru"
	 
	### Set PATH ###
	IPT=/sbin/iptables
	WGET=/usr/bin/wget
	EGREP=/bin/egrep
	 
	### No editing below ###
	SPAMLIST="countrydrop"
	ZONEROOT="/root/iptables"
	DLROOT="http://www.ipdeny.com/ipblocks/data/countries"
	 
	cleanOldRules(){
	$IPT -F
	$IPT -X
	$IPT -t nat -F
	$IPT -t nat -X
	$IPT -t mangle -F
	$IPT -t mangle -X
	$IPT -P INPUT ACCEPT
	$IPT -P OUTPUT ACCEPT
	$IPT -P FORWARD ACCEPT
	}
	 
	# create a dir
	[ ! -d $ZONEROOT ] && /bin/mkdir -p $ZONEROOT
	 
	# clean old rules
	cleanOldRules
	 
	# create a new iptables list
	$IPT -N $SPAMLIST
	 
	for c  in $ISO
	do
		# local zone file
		tDB=$ZONEROOT/$c.zone
	 
		# get fresh zone file
		$WGET -O $tDB $DLROOT/$c.zone
	 
		# country specific log message
		SPAMDROPMSG="$c Country Drop"
	 
		# get 
		BADIPS=$(egrep -v "^#|^$" $tDB)
		for ipblock in $BADIPS
		do
	#	   echo "Dropping $ipblock"
		   echo "$IPT -A $SPAMLIST -s $ipblock -j DROP" >>/tmp/dropall
		done
	done
	 
	# Drop everything 
	echo "$IPT -I INPUT -j $SPAMLIST" >>/tmp/dropall
	echo "$IPT -I OUTPUT -j $SPAMLIST" >>/tmp/dropall
	echo "$IPT -I FORWARD -j $SPAMLIST" >>/tmp/dropall
	 
	# call your other iptable script
	# /path/to/other/iptables.sh
	 
	echo "OK, now source /tmp/dropall"
	. /tmp/dropall
else
    echo "axis of evil already dropped, skipping..."
fi
exit 0

