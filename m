From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Determining which spindle is out of order
Date: Mon, 8 Nov 2010 12:05:37 -0900 (AKST)
Message-ID: <alpine.LNX.2.01.1011081201050.18117@filesrv1.baby-dragons.com>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org> <4CD57867.4010207@anonymous.org.uk> <4CD57C17.8020303@turmel.org> <4CD6A141.5090601@anonymous.org.uk> <4CD6A7F0.7030300@turmel.org> <4CD6ACED.9030808@anonymous.org.uk>
 <4CD6BB2D.5020202@turmel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD6BB2D.5020202@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 	Hello Phil ,

On Sun, 7 Nov 2010, Phil Turmel wrote:

> On 11/07/2010 08:43 AM, John Robinson wrote:
>> On 07/11/2010 13:21, Phil Turmel wrote:
>>> On 11/07/2010 07:53 AM, John Robinson wrote:
>>>> On 06/11/2010 16:02, Phil Turmel wrote:
>>>>> On 11/06/2010 11:46 AM, John Robinson wrote:
>>>> [...]
>>>>>> Now I need to find udevadm I guess. It must have been introduced since the udev version that comes with RHEL/CentOS 5, which is udev-095-14.21.el5_5.1. rpmfind.net suggests it's only been in since version 118 or so. Never mind :-)
>>>>>
>>>>> Heh.  Anyone know the equivalent command in earlier versions of udev?
>>>>
>>>> I think it's `udevinfo` instead of `udevadm info` - the comment in the ChangeLog for udev-117 is "udevadm: merge all udev tools into a single binary". But it doesn't work terribly well:
>>>>
>>>> [root@beast describe_scsi]# udevinfo -q all -p /devices/pci0000\:00/0000\:00\:1f.2/
>>>> no record for '/devices/pci0000:00/0000:00:1f.2/' in database
>>>>
>>>> That's unfortunate. But it does know about that device if asked differently:
>>>>
>>>> [root@beast describe_scsi]# udevinfo -a -p /devices/pci0000\:00/0000\:00\:1f.2/
>>>
>>> Hmmm.  Can you try both of the above without the trailing slash?
>>
>> Just the same output, however I ask the question:
>>
>> [root@beast ~]# udevinfo -q all -p /devices/pci0000\:00/0000\:00\:1f.2
>> no record for '/devices/pci0000:00/0000:00:1f.2' in database
>> [root@beast ~]# udevinfo -q all -p /devices/pci0000:00/0000:00:1f.2
>> no record for '/devices/pci0000:00/0000:00:1f.2' in database
>> [root@beast ~]# udevinfo -q all -p /sys/devices/pci0000:00/0000:00:1f.2
>> no record for '/devices/pci0000:00/0000:00:1f.2' in database
>> [root@beast ~]#
>>
>> And all with "-a" instead of "-q all" produce the output I posted before.
>
> The modern udevadm gives me that with --attribute-walk.  It's purpose is to report
> the conditions one might want to use in an udev rule.  It doesn't provide the human
> descriptions I'm looking for.
>
>> Please don't feel you have to turn this into a project, though.
>
> Too late.  Here's a version that doesn't use udevadm at all...
>
> #! /bin/bash
> #
> # Examine specific system host devices to identify the drives attached
> #
>
> function describe_controller () {
> 	local device driver modprefix serial slotname
> 	driver="`readlink -f \"$1/driver\"`"
> 	driver="`basename $driver`"
> 	modprefix="`cut -d: -f1 <\"$1/modalias\"`"
> 	echo "Controller device @ ${1##/sys/devices/} [$driver]"
> 	if [[ "$modprefix" == "pci" ]] ; then
> 		slotname="`basename \"$1\"`"
> 		echo -n "  `lspci -s $slotname |cut -d\  -f2-`"
> 		return
> 	fi
> 	if [[ "$modprefix" == "usb" ]] ; then
> 		if [[ -f "$1/busnum" ]] ; then
> 			device="`cat \"$1/busnum\"`:`cat \"$1/devnum\"`"
> 			serial="`cat \"$1/serial\"`"
> 		else
> 			device="`cat \"$1/../busnum\"`:`cat \"$1/../devnum\"`"
> 			serial="`cat \"$1/../serial\"`"
> 		fi
> 		echo "  `lsusb -s $device` {SN: $serial}"
> 		return
> 	fi
> 	echo -e "  `cat \"$1/modalias\"`"
> }
>
> function describe_device () {
> 	targ=${1%/block/*}
> 	vnd="`cat $targ/vendor`"
> 	mdl=`cat $targ/model`
> 	rdev=`readlink -f "$1"`
> 	if [[ -d $rdev ]] ; then
> 		bdev="`basename $rdev`"
> 		sn="`sginfo -s /dev/$bdev | \
> 			sed -rn -e \"/Serial Number/{s%^.+' *(.+) *'.*\\\$%\\\\1%;p;q}\"`" &>/dev/null
> 		if [[ -n "$sn" ]] ; then
> 			echo -e "    $bhost: `echo /dev/$bdev $vnd $mdl {SN: $sn}`"
> 		else
> 			echo -e "    $bhost: `echo /dev/$bdev $vnd $mdl`"
> 		fi
> 	else
> 		echo -e "    $bhost: Unknown $rdev"
> 	fi
> }
>
> function check_host () {
> 	local found=0
> 	local pController=
> 	while read shost ; do
> 		host=`dirname "$shost"`
> 		controller=`dirname "$host"`
> 		bhost=`basename "$host"`
> 		if [[ "$controller" != "$pController" ]] ; then
> 			pController="$controller"
> 			describe_controller "$controller"
> 		fi
> 		for dev in $host/target*/*/block/* ; do
> 			if [[ "${dev: -1}" == '*' ]] ; then
> 				echo -e "    $bhost: [Empty]"
> 			else
> 				describe_device "$dev"
> 			fi
> 		done
> 	done
> }
>
> find /sys/devices/ -name scsi_host |check_host


 	I get the following on my (Ancient) Slackware 10.2.0 server .


# linuxraid-check_host-20101108.sh
Controller device @ pci0000:00/0000:00:01.0 [sym53c8xx]
lspci: -f: Invalid slot number
       host0: [Empty]
Controller device @ pci0000:00/0000:00:01.1 [sym53c8xx]
lspci: -f: Invalid slot number
       host1: [Empty]
basename: too few arguments
Try `basename --help' for more information.
Controller device @ pci0000:02/0000:02:02.0 []
lspci: -f: Invalid slot number
       host2: [Empty]


# lspci --version
lspci version 2.1.11

basename --version
basename (GNU coreutils) 5.2.1
...snipped...


# for XXX in `lspci | grep -i scsi | awk '{print $1}'` ; do lspci -v -v -v -v -v -s ${XXX} ; done

00:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 66MHz  Ultra3 
SCSI Adapter (rev 01)
         Subsystem: LSI Logic / Symbios Logic LSI53C1000/1000R/1010R/1010-66 PCI to Ultra160 SCSI Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 72 (4250ns min, 4500ns max), cache line size 08
         Interrupt: pin A routed to IRQ 29
         Region 0: I/O ports at c400 [size=256]
         Region 1: Memory at fe9ff800 (64-bit, non-prefetchable) [size=1K]
         Region 3: Memory at fe9f6000 (64-bit, non-prefetchable) [size=8K]
         Expansion ROM at fe9f0000 [disabled] [size=16K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 66MHz  Ultra3 
SCSI Adapter (rev 01)
         Subsystem: LSI Logic / Symbios Logic LSI53C1000/1000R/1010R/1010-66 PCI to Ultra160 SCSI Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 72 (4250ns min, 4500ns max), cache line size 08
         Interrupt: pin B routed to IRQ 28
         Region 0: I/O ports at c800 [size=256]
         Region 1: Memory at fe9ffc00 (64-bit, non-prefetchable) [size=1K]
         Region 3: Memory at fe9fc000 (64-bit, non-prefetchable) [size=8K]
         Expansion ROM at fe9f8000 [disabled] [size=16K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

# fdisk -l | grep '^Disk'
Disk /dev/sdb: 734.0 GB, 734076600320 bytes
Disk /dev/sda: 18.2 GB, 18210037760 byte

 	Tia ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
