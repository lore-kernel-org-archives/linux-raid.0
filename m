From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Determining which spindle is out of order
Date: Sun, 7 Nov 2010 15:04:32 +0000
Message-ID: <AANLkTikqQw+FR+RG6SL6DHmhO4UdgLnW6gahAJ80pvB5@mail.gmail.com>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com>
	<4CD57048.4020107@turmel.org>
	<4CD57867.4010207@anonymous.org.uk>
	<4CD57C17.8020303@turmel.org>
	<4CD6A141.5090601@anonymous.org.uk>
	<4CD6A7F0.7030300@turmel.org>
	<4CD6ACED.9030808@anonymous.org.uk>
	<4CD6BB2D.5020202@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD6BB2D.5020202@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7 November 2010 14:43, Phil Turmel <philip@turmel.org> wrote:
> On 11/07/2010 08:43 AM, John Robinson wrote:
>> On 07/11/2010 13:21, Phil Turmel wrote:
>>> On 11/07/2010 07:53 AM, John Robinson wrote:
>>>> On 06/11/2010 16:02, Phil Turmel wrote:
>>>>> On 11/06/2010 11:46 AM, John Robinson wrote:
>>>> [...]
>>>>>> Now I need to find udevadm I guess. It must have been introduced=
 since the udev version that comes with RHEL/CentOS 5, which is udev-09=
5-14.21.el5_5.1. rpmfind.net suggests it's only been in since version 1=
18 or so. Never mind :-)
>>>>>
>>>>> Heh. =C2=A0Anyone know the equivalent command in earlier versions=
 of udev?
>>>>
>>>> I think it's `udevinfo` instead of `udevadm info` - the comment in=
 the ChangeLog for udev-117 is "udevadm: merge all udev tools into a si=
ngle binary". But it doesn't work terribly well:
>>>>
>>>> [root@beast describe_scsi]# udevinfo -q all -p /devices/pci0000\:0=
0/0000\:00\:1f.2/
>>>> no record for '/devices/pci0000:00/0000:00:1f.2/' in database
>>>>
>>>> That's unfortunate. But it does know about that device if asked di=
fferently:
>>>>
>>>> [root@beast describe_scsi]# udevinfo -a -p /devices/pci0000\:00/00=
00\:00\:1f.2/
>>>
>>> Hmmm. =C2=A0Can you try both of the above without the trailing slas=
h?
>>
>> Just the same output, however I ask the question:
>>
>> [root@beast ~]# udevinfo -q all -p /devices/pci0000\:00/0000\:00\:1f=
=2E2
>> no record for '/devices/pci0000:00/0000:00:1f.2' in database
>> [root@beast ~]# udevinfo -q all -p /devices/pci0000:00/0000:00:1f.2
>> no record for '/devices/pci0000:00/0000:00:1f.2' in database
>> [root@beast ~]# udevinfo -q all -p /sys/devices/pci0000:00/0000:00:1=
f.2
>> no record for '/devices/pci0000:00/0000:00:1f.2' in database
>> [root@beast ~]#
>>
>> And all with "-a" instead of "-q all" produce the output I posted be=
fore.
>
> The modern udevadm gives me that with --attribute-walk. =C2=A0It's pu=
rpose is to report
> the conditions one might want to use in an udev rule. =C2=A0It doesn'=
t provide the human
> descriptions I'm looking for.
>
>> Please don't feel you have to turn this into a project, though.
>
> Too late. =C2=A0Here's a version that doesn't use udevadm at all...
>
> #! /bin/bash
> #
> # Examine specific system host devices to identify the drives attache=
d
> #
>
> function describe_controller () {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0local device driver modprefix serial slotn=
ame
> =C2=A0 =C2=A0 =C2=A0 =C2=A0driver=3D"`readlink -f \"$1/driver\"`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0driver=3D"`basename $driver`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0modprefix=3D"`cut -d: -f1 <\"$1/modalias\"=
`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0echo "Controller device @ ${1##/sys/device=
s/} [$driver]"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if [[ "$modprefix" =3D=3D "pci" ]] ; then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0slotname=3D"`b=
asename \"$1\"`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo -n " =C2=A0=
`lspci -s $slotname |cut -d\ =C2=A0-f2-`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return
> =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if [[ "$modprefix" =3D=3D "usb" ]] ; then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [[ -f "$1/b=
usnum" ]] ; then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0device=3D"`cat \"$1/busnum\"`:`cat \"$1/devnum\"`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0serial=3D"`cat \"$1/serial\"`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0device=3D"`cat \"$1/../busnum\"`:`cat \"$1/../devnum\"`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0serial=3D"`cat \"$1/../serial\"`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo " =C2=A0`=
lsusb -s $device` {SN: $serial}"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return
> =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> =C2=A0 =C2=A0 =C2=A0 =C2=A0echo -e " =C2=A0`cat \"$1/modalias\"`"
> }
>
> function describe_device () {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0targ=3D${1%/block/*}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0vnd=3D"`cat $targ/vendor`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mdl=3D`cat $targ/model`
> =C2=A0 =C2=A0 =C2=A0 =C2=A0rdev=3D`readlink -f "$1"`
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if [[ -d $rdev ]] ; then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bdev=3D"`basen=
ame $rdev`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sn=3D"`sginfo =
-s /dev/$bdev | \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0sed -rn -e \"/Serial Number/{s%^.+' *(.+) *'.*\\\$%\\\\1%=
;p;q}\"`" &>/dev/null
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [[ -n "$sn"=
 ]] ; then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0echo -e " =C2=A0 =C2=A0$bhost: `echo /dev/$bdev $vnd $mdl=
 {SN: $sn}`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0echo -e " =C2=A0 =C2=A0$bhost: `echo /dev/$bdev $vnd $mdl=
`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo -e " =C2=A0=
 =C2=A0$bhost: Unknown $rdev"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> }
>
> function check_host () {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0local found=3D0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0local pController=3D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0while read shost ; do
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0host=3D`dirnam=
e "$shost"`
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0controller=3D`=
dirname "$host"`
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bhost=3D`basen=
ame "$host"`
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [[ "$contro=
ller" !=3D "$pController" ]] ; then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0pController=3D"$controller"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0describe_controller "$controller"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for dev in $ho=
st/target*/*/block/* ; do
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if [[ "${dev: -1}" =3D=3D '*' ]] ; then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo -e " =C2=A0 =C2=A0$bhost=
: [Empty]"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0describe_device "$dev"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0fi
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0done
> =C2=A0 =C2=A0 =C2=A0 =C2=A0done
> }
>
> find /sys/devices/ -name scsi_host |check_host
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Nice, now it shows the S/N of the devices in my system:


Controller device @ pci0000:00/0000:00:0b.0 [ahci]
  SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b1)
 host0: /dev/sda ATA Corsair CSSD-F60 {SN: 10326505580009990027}
    host1: /dev/sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022443}
    host2: /dev/sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152590}
    host3: /dev/sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188479}
    host4: [Empty]
    host5: [Empty]
Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
  SCSI storage controller: HighPoint Technologies, Inc. RocketRAID
230x 4 Port SATA-II Controller (rev 02)    host6: [Empty]
    host7: /dev/sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800964 }
    host8: /dev/sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000331}
    host9: /dev/sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800850 }

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
