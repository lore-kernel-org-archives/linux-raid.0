From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Determining which spindle is out of order
Date: Sun, 07 Nov 2010 15:19:08 +0000
Message-ID: <4CD6C36C.1080200@anonymous.org.uk>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org> <4CD57867.4010207@anonymous.org.uk> <4CD57C17.8020303@turmel.org> <4CD6A141.5090601@anonymous.org.uk> <4CD6A7F0.7030300@turmel.org> <4CD6ACED.9030808@anonymous.org.uk> <4CD6BB2D.5020202@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080005020505010300020101"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD6BB2D.5020202@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080005020505010300020101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/11/2010 14:43, Phil Turmel wrote:
> On 11/07/2010 08:43 AM, John Robinson wrote:
[...]
>> Please don't feel you have to turn this into a project, though.
>
> Too late.  Here's a version that doesn't use udevadm at all...

OK, it's an improvement because after I've changed the find command to 
find '*scsi_host*', it lists my controllers, but finds them all empty. I 
noted that the script was looking for subdirectories called block but 
mine have names like block:sda so I changed the script again to refer to 
'block*' both in the loop in check_host and in the substitution at the 
top of describe_device. There's still something not quite right with 
trying to read CentOS/RHEL 5 / kernel 2.6.18 sysfs, because this was the 
output I got:

[root@beast ~]# ~john/projects/describe_scsi/describe_scsi_2
Controller device @ pci0000:00/0000:00:1f.2 [ahci]
   SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI 
Controller    host7: [Empty]
     host6: [Empty]
     host5: [Empty]
     host4: Unknown /sys/block/sdc/dev
sginfo(open): No such file or directory
file=/dev/4:0:0:0, or no corresponding sg device found
Is sg driver loaded?
     host4: /dev/4:0:0:0 ATA ST31000528AS
sginfo(open): No such file or directory
file=/dev/holders, or no corresponding sg device found
Is sg driver loaded?
     host4: /dev/holders ATA ST31000528AS
sginfo(open): No such file or directory
file=/dev/queue, or no corresponding sg device found
Is sg driver loaded?
     host4: /dev/queue ATA ST31000528AS
     host4: Unknown /sys/block/sdc/range
     host4: Unknown /sys/block/sdc/removable
     host4: /dev/sdc1 ATA ST31000528AS {SN: 9VP4XCQP}
     host4: /dev/sdc2 ATA ST31000528AS {SN: 9VP4XCQP}
     host4: Unknown /sys/block/sdc/size
sginfo(open): No such file or directory
file=/dev/slaves, or no corresponding sg device found
Is sg driver loaded?
     host4: /dev/slaves ATA ST31000528AS
     host4: Unknown /sys/block/sdc/stat
sginfo(open): No such file or directory
file=/dev/block, or no corresponding sg device found
Is sg driver loaded?
     host4: /dev/block ATA ST31000528AS
     host4: Unknown /sys/block/sdc/uevent
     host3: Unknown /sys/block/sdb/dev
sginfo(open): No such file or directory
file=/dev/3:0:0:0, or no corresponding sg device found
Is sg driver loaded?
     host3: /dev/3:0:0:0 ATA SAMSUNG HD103UJ
sginfo(open): No such file or directory
file=/dev/holders, or no corresponding sg device found
Is sg driver loaded?
     host3: /dev/holders ATA SAMSUNG HD103UJ
sginfo(open): No such file or directory
file=/dev/queue, or no corresponding sg device found
Is sg driver loaded?
     host3: /dev/queue ATA SAMSUNG HD103UJ
     host3: Unknown /sys/block/sdb/range
     host3: Unknown /sys/block/sdb/removable
     host3: /dev/sdb1 ATA SAMSUNG HD103UJ {SN: S1PVJ1CQ602162 }
     host3: /dev/sdb2 ATA SAMSUNG HD103UJ {SN: S1PVJ1CQ602162 }
     host3: Unknown /sys/block/sdb/size
sginfo(open): No such file or directory
file=/dev/slaves, or no corresponding sg device found
Is sg driver loaded?
     host3: /dev/slaves ATA SAMSUNG HD103UJ
     host3: Unknown /sys/block/sdb/stat
sginfo(open): No such file or directory
file=/dev/block, or no corresponding sg device found
Is sg driver loaded?
     host3: /dev/block ATA SAMSUNG HD103UJ
     host3: Unknown /sys/block/sdb/uevent
     host2: Unknown /sys/block/sda/dev
sginfo(open): No such file or directory
file=/dev/2:0:0:0, or no corresponding sg device found
Is sg driver loaded?
     host2: /dev/2:0:0:0 ATA Hitachi HDS72101
sginfo(open): No such file or directory
file=/dev/holders, or no corresponding sg device found
Is sg driver loaded?
     host2: /dev/holders ATA Hitachi HDS72101
sginfo(open): No such file or directory
file=/dev/queue, or no corresponding sg device found
Is sg driver loaded?
     host2: /dev/queue ATA Hitachi HDS72101
     host2: Unknown /sys/block/sda/range
     host2: Unknown /sys/block/sda/removable
     host2: /dev/sda1 ATA Hitachi HDS72101 {SN: JP2921HQ0J0PZA}
     host2: /dev/sda2 ATA Hitachi HDS72101 {SN: JP2921HQ0J0PZA}
     host2: Unknown /sys/block/sda/size
sginfo(open): No such file or directory
file=/dev/slaves, or no corresponding sg device found
Is sg driver loaded?
     host2: /dev/slaves ATA Hitachi HDS72101
     host2: Unknown /sys/block/sda/stat
sginfo(open): No such file or directory
file=/dev/block, or no corresponding sg device found
Is sg driver loaded?
     host2: /dev/block ATA Hitachi HDS72101
     host2: Unknown /sys/block/sda/uevent
Controller device @ pci0000:00/0000:00:1e.0/0000:05:01.1 [aic7xxx]
   SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (rev 
01)    host9: [Empty]
Controller device @ pci0000:00/0000:00:1e.0/0000:05:01.0 [aic7xxx]
   SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (rev 
01)    host8: [Empty]
Controller device @ pci0000:00/0000:00:1c.4/0000:03:00.0 [pata_marvell]
   IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II 
Controller (rev b2)    host1: [Empty]
     host0: Unknown /sys/block/sr0/dev
sginfo(open): No such file or directory
file=/dev/0:0:0:0, or no corresponding sg device found
Is sg driver loaded?
     host0: /dev/0:0:0:0 HL-DT-ST DVD-RAM GH22NP20
sginfo(open): No such file or directory
file=/dev/holders, or no corresponding sg device found
Is sg driver loaded?
     host0: /dev/holders HL-DT-ST DVD-RAM GH22NP20
sginfo(open): No such file or directory
file=/dev/queue, or no corresponding sg device found
Is sg driver loaded?
     host0: /dev/queue HL-DT-ST DVD-RAM GH22NP20
     host0: Unknown /sys/block/sr0/range
     host0: Unknown /sys/block/sr0/removable
     host0: Unknown /sys/block/sr0/size
sginfo(open): No such file or directory
file=/dev/slaves, or no corresponding sg device found
Is sg driver loaded?
     host0: /dev/slaves HL-DT-ST DVD-RAM GH22NP20
     host0: Unknown /sys/block/sr0/stat
sginfo(open): No such file or directory
file=/dev/block, or no corresponding sg device found
Is sg driver loaded?
     host0: /dev/block HL-DT-ST DVD-RAM GH22NP20
     host0: Unknown /sys/block/sr0/uevent
[root@beast ~]#

So it's finding my drives but also trying to describe_device lots of 
wrong things - maybe need a different expansion for the loop in check_host?

Hopefully the below will give you a better idea of what the sysfs layout 
is like on CentOS/RHEL 5:

[root@beast 0000:00:1f.2]# pwd
/sys/devices/pci0000:00/0000:00:1f.2
[root@beast 0000:00:1f.2]# ls -F
broken_parity_status  enable  host7/      resource0  subsystem@
bus@                  host2/  irq         resource1  subsystem_device
class                 host3/  local_cpus  resource2  subsystem_vendor
config                host4/  modalias    resource3  uevent
device                host5/  power/      resource4  vendor
driver@               host6/  resource    resource5
[root@beast 0000:00:1f.2]# ls -FR host2
host2:
power/  scsi_host:host2@  target2:0:0/  uevent

host2/power:
state  wakeup

host2/target2:0:0:
2:0:0:0/  power/  uevent

host2/target2:0:0/2:0:0:0:
block:sda@      iocounterbits  queue_type            state
bus@            iodone_cnt     rescan                subsystem@
delete          ioerr_cnt      rev                   sw_activity
device_blocked  iorequest_cnt  scsi_device:2:0:0:0@  timeout
dh_state        model          scsi_disk:2:0:0:0@    type
driver@         power/         scsi_generic:sg1@     uevent
generic@        queue_depth    scsi_level            vendor

host2/target2:0:0/2:0:0:0/power:
state  wakeup

host2/target2:0:0/power:
state  wakeup
[root@beast 0000:00:1f.2]# ls -FR host2/target2\:0\:0/2\:0\:0\:0/block\:sda/
host2/target2:0:0/2:0:0:0/block:sda/:
dev      holders/  range      sda1/  size     stat        uevent
device@  queue/    removable  sda2/  slaves/  subsystem@

host2/target2:0:0/2:0:0:0/block:sda/holders:

host2/target2:0:0/2:0:0:0/block:sda/queue:
iosched/  max_hw_sectors_kb  nr_requests    scheduler
iostats   max_sectors_kb     read_ahead_kb

host2/target2:0:0/2:0:0:0/block:sda/queue/iosched:
back_seek_max      fifo_expire_sync  slice_async     slice_sync
back_seek_penalty  quantum           slice_async_rq
fifo_expire_async  queued            slice_idle

host2/target2:0:0/2:0:0:0/block:sda/sda1:
dev  holders/  size  start  stat  subsystem@  uevent

host2/target2:0:0/2:0:0:0/block:sda/sda1/holders:
md0@

host2/target2:0:0/2:0:0:0/block:sda/sda2:
dev  holders/  size  start  stat  subsystem@  uevent

host2/target2:0:0/2:0:0:0/block:sda/sda2/holders:
md1@

host2/target2:0:0/2:0:0:0/block:sda/slaves:
[root@beast 0000:00:1f.2]#


Hope this helps. I've also attached my edited version of the script.

Many thanks,

John.

--------------080005020505010300020101
Content-Type: text/plain;
 name="describe_scsi_2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="describe_scsi_2"

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
	targ=${1%/block*/*}
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
		for dev in $host/target*/*/block*/* ; do
			if [[ "${dev: -1}" == '*' ]] ; then
				echo -e "    $bhost: [Empty]"
			else
				describe_device "$dev"
			fi
		done
	done
}

find /sys/devices/ -name *scsi_host* |check_host

--------------080005020505010300020101--
