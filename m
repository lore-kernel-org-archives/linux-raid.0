From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: diskinfo script
Date: Tue, 29 Apr 2008 16:28:21 -0400
Message-ID: <481784E5.4090307@tmr.com>
References: <481766E5.8080900@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090406020903030604020408"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <481766E5.8080900@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090406020903030604020408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Bill Davidsen wrote:
> I was playing around doing some prototyping for a more extensive disk 
> info reporter which will be written in perl, and it came to me that 
> this script might be useful to someone, so I'll attach it here. The 
> perl version will generate HTML, and CSV for configuration databases, 
> show mount points, etc. This was an hour or so, mainly playing with 
> the report format. Obviously you need to make it executable.
>
> I want it because I'm frequently asked to look at strange machines, 
> and I want to see what used and how. I could do it all in script, but 
> only to prove I can. ;-)
>
> *Enjoy!*
>
After some immediate feedback, I did an update on this to include some 
patches and requested features. So here is the last version I'll put 
here, with built-in help, examples, the option to use "GiB" instead of 
"GB" if you care, and now should run on sh as well as bash. It currently 
doesn't run on ksh, I have to look for my ksh book and see how to fix 
the problem.

If there is ever a version after this I'll just put it on a website, I 
was dropping this to do something better.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 



--------------090406020903030604020408
Content-Type: text/plain;
 name="diskinfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diskinfo"

#!/bin/bash
#   diskinfo 1.12 2008-04-29 16:07:41-04 davidsen Stable
# tabs=4
#
# display disk info

# this usage function needs to be defined before it's used
Usage() {
	exec 1>&2
	echo -e "\n\n\nDiskInfo usage\n"
	echo -e "    diskinfo [ options ] [ drives ]\n"
	echo "With no arguments diskinfo lists the sizes of devices with"
	echo "names of the format /dev/hd? and /dev/sd?. Options allow"
	echo "display of the size of partitions, and their use by raid"
	echo "(md) arrays, or lvm (dm) devices."
	echo ""
	echo "Options"
	echo " -v  verbose - at the moment just displays version information"
	echo "     rather than more information about the devices."
	echo " -p  partitions - shows information about partitions on the"
	echo "     devices listed, their size and usage."
	echo " -d  debug - does nothing in the released version, just a handy"
	echo "     thing to have if you try to enhance this script."
	echo " -e  european disk size notation, \"MiB\" instead of \"MB,\" etc"
	echo ""
	echo "To specify a subset of drives or drives with alternate names,"
	echo "the drive names may be put on the command line in wildcard"
	echo "notation."
	echo -e "\nENTER to see examples: \c"
	read ans
	echo -e "\n\n"
	echo "Examples:"
	echo "  diskinfo hd[ab] sdb"
	echo "  diskinfo -p sd?"
	echo "  diskinfo -p md1p_*"
	echo -e "\n\n"

	exit 2
}

# option parsing
verbose=0
partitions=false
debug=false
# MB and GB unit notation - someone asked for this
Unit_MB="MB"
Unit_GB="GB"

while getopts "pvde" opt; do
  case "$opt" in
  "p") partitions=true;;
  "v") let verbose+=1;;
  "d") debug=true;;
  "e") # European unit notation
       Unit_MB="MiB"; Unit_GB="GiB";;
  "?") Usage;;
  esac
done
if [ $verbose -gt 0 ]; then
	echo -e 'diskinfo v1.12 Stable  2008-04-29 16:07:41-04 davidsen@tmr.com\n' >&2
fi

# A gigabyte in sectors
Gig_sect=$((2*1024*1024))

# this does the output
do_blkdev() {
	local drive id modelfile
	id="$1"
	drive=$2

	# size in MB or GB as makes sense
	size=$(cat ${drive}/size)
	if [ $size -lt $Gig_sect ]; then
		MB=$(echo "scale=1;$size/2048"|bc)
		UNIT=$Unit_MB
	else
		MB=$(echo "scale=1;$size/(2*1024^2)"|bc)
		UNIT=$Unit_GB
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

--------------090406020903030604020408--
