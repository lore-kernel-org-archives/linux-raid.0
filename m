From: Phil Turmel <philip@turmel.org>
Subject: Re: Determining which spindle is out of order
Date: Sun, 07 Nov 2010 09:43:57 -0500
Message-ID: <4CD6BB2D.5020202@turmel.org>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org> <4CD57867.4010207@anonymous.org.uk> <4CD57C17.8020303@turmel.org> <4CD6A141.5090601@anonymous.org.uk> <4CD6A7F0.7030300@turmel.org> <4CD6ACED.9030808@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD6ACED.9030808@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/2010 08:43 AM, John Robinson wrote:
> On 07/11/2010 13:21, Phil Turmel wrote:
>> On 11/07/2010 07:53 AM, John Robinson wrote:
>>> On 06/11/2010 16:02, Phil Turmel wrote:
>>>> On 11/06/2010 11:46 AM, John Robinson wrote:
>>> [...]
>>>>> Now I need to find udevadm I guess. It must have been introduced since the udev version that comes with RHEL/CentOS 5, which is udev-095-14.21.el5_5.1. rpmfind.net suggests it's only been in since version 118 or so. Never mind :-)
>>>>
>>>> Heh.  Anyone know the equivalent command in earlier versions of udev?
>>>
>>> I think it's `udevinfo` instead of `udevadm info` - the comment in the ChangeLog for udev-117 is "udevadm: merge all udev tools into a single binary". But it doesn't work terribly well:
>>>
>>> [root@beast describe_scsi]# udevinfo -q all -p /devices/pci0000\:00/0000\:00\:1f.2/
>>> no record for '/devices/pci0000:00/0000:00:1f.2/' in database
>>>
>>> That's unfortunate. But it does know about that device if asked differently:
>>>
>>> [root@beast describe_scsi]# udevinfo -a -p /devices/pci0000\:00/0000\:00\:1f.2/
>>
>> Hmmm.  Can you try both of the above without the trailing slash?
> 
> Just the same output, however I ask the question:
> 
> [root@beast ~]# udevinfo -q all -p /devices/pci0000\:00/0000\:00\:1f.2
> no record for '/devices/pci0000:00/0000:00:1f.2' in database
> [root@beast ~]# udevinfo -q all -p /devices/pci0000:00/0000:00:1f.2
> no record for '/devices/pci0000:00/0000:00:1f.2' in database
> [root@beast ~]# udevinfo -q all -p /sys/devices/pci0000:00/0000:00:1f.2
> no record for '/devices/pci0000:00/0000:00:1f.2' in database
> [root@beast ~]#
> 
> And all with "-a" instead of "-q all" produce the output I posted before.

The modern udevadm gives me that with --attribute-walk.  It's purpose is to report
the conditions one might want to use in an udev rule.  It doesn't provide the human
descriptions I'm looking for.

> Please don't feel you have to turn this into a project, though.

Too late.  Here's a version that doesn't use udevadm at all...

#! /bin/bash
#
# Examine specific system host devices to identify the drives attached
#

function describe_controller () {
	local device driver modprefix serial slotname
	driver="`readlink -f \"$1/driver\"`"
	driver="`basename $driver`"
	modprefix="`cut -d: -f1 <\"$1/modalias\"`"
	echo "Controller device @ ${1##/sys/devices/} [$driver]"
	if [[ "$modprefix" == "pci" ]] ; then
		slotname="`basename \"$1\"`"
		echo -n "  `lspci -s $slotname |cut -d\  -f2-`"
		return
	fi
	if [[ "$modprefix" == "usb" ]] ; then
		if [[ -f "$1/busnum" ]] ; then
			device="`cat \"$1/busnum\"`:`cat \"$1/devnum\"`"
			serial="`cat \"$1/serial\"`"
		else
			device="`cat \"$1/../busnum\"`:`cat \"$1/../devnum\"`"
			serial="`cat \"$1/../serial\"`"
		fi
		echo "  `lsusb -s $device` {SN: $serial}"
		return
	fi
	echo -e "  `cat \"$1/modalias\"`"
}

function describe_device () {
	targ=${1%/block/*}
	vnd="`cat $targ/vendor`"
	mdl=`cat $targ/model`
	rdev=`readlink -f "$1"`
	if [[ -d $rdev ]] ; then
		bdev="`basename $rdev`"
		sn="`sginfo -s /dev/$bdev | \
			sed -rn -e \"/Serial Number/{s%^.+' *(.+) *'.*\\\$%\\\\1%;p;q}\"`" &>/dev/null
		if [[ -n "$sn" ]] ; then
			echo -e "    $bhost: `echo /dev/$bdev $vnd $mdl {SN: $sn}`"
		else
			echo -e "    $bhost: `echo /dev/$bdev $vnd $mdl`"
		fi
	else
		echo -e "    $bhost: Unknown $rdev"
	fi
}

function check_host () {
	local found=0
	local pController=
	while read shost ; do
		host=`dirname "$shost"`
		controller=`dirname "$host"`
		bhost=`basename "$host"`
		if [[ "$controller" != "$pController" ]] ; then
			pController="$controller"
			describe_controller "$controller"
		fi
		for dev in $host/target*/*/block/* ; do
			if [[ "${dev: -1}" == '*' ]] ; then
				echo -e "    $bhost: [Empty]"
			else
				describe_device "$dev"
			fi
		done
	done
}

find /sys/devices/ -name scsi_host |check_host
