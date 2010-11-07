From: Phil Turmel <philip@turmel.org>
Subject: Re: Determining which spindle is out of order
Date: Sun, 07 Nov 2010 13:39:21 -0500
Message-ID: <4CD6F259.6080408@turmel.org>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org> <4CD57867.4010207@anonymous.org.uk> <4CD57C17.8020303@turmel.org> <4CD6A141.5090601@anonymous.org.uk> <4CD6A7F0.7030300@turmel.org> <4CD6ACED.9030808@anonymous.org.uk> <4CD6BB2D.5020202@turmel.org> <4CD6C36C.1080200@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000900060607040303000803"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD6C36C.1080200@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000900060607040303000803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/07/2010 10:19 AM, John Robinson wrote:
> On 07/11/2010 14:43, Phil Turmel wrote:
>> On 11/07/2010 08:43 AM, John Robinson wrote:
> [...]
>>> Please don't feel you have to turn this into a project, though.
>>
>> Too late.  Here's a version that doesn't use udevadm at all...
> 
> OK, it's an improvement because after I've changed the find command to find '*scsi_host*', it lists my controllers, but finds them all empty. I noted that the script was looking for subdirectories called block but mine have names like block:sda so I changed the script again to refer to 'block*' both in the loop in check_host and in the substitution at the top of describe_device. There's still something not quite right with trying to read CentOS/RHEL 5 / kernel 2.6.18 sysfs, because this was the output I got:

I think I understand the older sysfs directory format now.

> Hope this helps. I've also attached my edited version of the script.

I did another version, with regular expressions to accommodate the variations.  Please give it a shot.

Regards,

Phil

--------------000900060607040303000803
Content-Type: text/plain;
 name="lsdrv"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsdrv"

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
		echo "  `lspci -s $slotname |cut -d\  -f2-`"
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
	local empty=1
	while read device ; do
		empty=0
		if [[ "$device" =~ ^(.+)/block[/:](.+)$ ]] ; then
			targ="${BASH_REMATCH[1]}"
			bdev="${BASH_REMATCH[2]}"
			vnd="$(< $targ/vendor)"
			mdl="$(< $targ/model)"
			sn="`sginfo -s /dev/$bdev | \
				sed -rn -e \"/Serial Number/{s%^.+' *(.+) *'.*\\\$%\\\\1%;p;q}\"`" &>/dev/null
			if [[ -n "$sn" ]] ; then
				echo -e "    $1: `echo /dev/$bdev $vnd $mdl {SN: $sn}`"
			else
				echo -e "    $1: `echo /dev/$bdev $vnd $mdl`"
			fi
		else
			echo -e "    $1: Unknown $device"
		fi
	done
	[[ $empty -eq 1 ]] && echo -e "    $1: [Empty]"
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
		find $host -regex '.+/target[0-9:]+/[0-9:]+/block[:/][^/]+' |describe_device "$bhost"
	done
}

find /sys/devices/ -regex '.+/scsi_host\(:block\)?' |check_host

--------------000900060607040303000803--
