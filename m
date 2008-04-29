From: Bill Davidsen <davidsen@tmr.com>
Subject: diskinfo script
Date: Tue, 29 Apr 2008 14:20:21 -0400
Message-ID: <481766E5.8080900@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090500030108000401010304"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090500030108000401010304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I was playing around doing some prototyping for a more extensive disk 
info reporter which will be written in perl, and it came to me that this 
script might be useful to someone, so I'll attach it here. The perl 
version will generate HTML, and CSV for configuration databases, show 
mount points, etc. This was an hour or so, mainly playing with the 
report format. Obviously you need to make it executable.

I want it because I'm frequently asked to look at strange machines, and 
I want to see what used and how. I could do it all in script, but only 
to prove I can. ;-)

*Enjoy!*

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 



--------------090500030108000401010304
Content-Type: text/plain;
 name="diskinfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diskinfo"

#!/bin/bash
#   diskinfo 1.10 2008-04-29 13:58:39-04 davidsen Testing
#
# display disk info

# option parsing
verbose=0
partitions=false
debug=false

while getopts "pvd" opt; do
  case "$opt" in
  "p") partitions=true;;
  "v") let verbose+=1;;
  "d") debug=true;;
  "?") exit 2;;
  esac
done
if [ $verbose -gt 0 ]; then
	echo -e 'diskinfo v1.10 Testing  2008-04-29 13:58:39-04 davidsen@tmr.com\n' >&2
fi

Gig_sect=$[2*1024*1024]

# this does the output
function do_blkdev
{
	local drive id modelfile
	id="$1"
	drive=$2

	# size in MB or GB as makes sense
	size=$(cat ${drive}/size)
	if [ $size -lt $Gig_sect ]; then
		MB=$(echo "scale=1;$size/2048"|bc)
		UNIT="MB"
	else
		MB=$(echo "scale=1;$size/(2*1024^2)"|bc)
		UNIT="GB"
	fi
	modelfile="${drive}/device/model"
	if [ -f "$modelfile" ]; then
		model=$(cat "${modelfile}")
	else
		if [ -d ${drive}/holders ]; then
			model=$(ls ${drive}/holders)
			[ -n "$model" ] && model="  ($(echo $model))"
		else
			model="undefined"
		fi
	fi
	printf "%-8s %6s %-2s %s\n" "$id" $MB $UNIT "$model"
}

# identify devices
eval DISKS=\${${OPTIND}:-hd? sd?}

# process the block devices
cd /sys/block
for disk in ${DISKS}
do
	if [ -d "${disk}" ]; then
		do_blkdev "$disk" "$disk"
		if $partitions; then
			for ptn in ${disk}/${disk}[1-9]*; do
				if [ -d "$ptn" ]; then
					do_blkdev "  ${ptn##*/}" $ptn
				else
					echo "  no partition table"
				fi
			done
		fi
	fi
done

--------------090500030108000401010304--
