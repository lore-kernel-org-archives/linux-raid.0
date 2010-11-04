From: Tom Carlson <twigathy@gmail.com>
Subject: Re: Determining which spindle is out of order
Date: Thu, 4 Nov 2010 09:29:33 +0000
Message-ID: <AANLkTinfgqGTH4M3Gp-kSqcLyTX+gY=Ji=8K1LOvUURF@mail.gmail.com>
References: <loom.20101103T115828-494@post.gmane.org>
	<4CD1DA2E.5060205@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD1DA2E.5060205@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Nat Makarevitch <Shelso@makarevitch.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Really great little script there -- thank you! I have saved for use in
my (Currently offline) fileserver :-)

Thanks,

T

On 3 November 2010 21:54, Phil Turmel <philip@turmel.org> wrote:
> On 11/3/2010 2:13 PM, Nat Makarevitch wrote:
>> Hi,
>>
>> After a spindle (physical hard disk, a "drive") failure in a "md" RA=
ID array,
>> how can we know which spindle must be replaced?
>>
>> We want to avoid extracting a working spindle by mistakenly thinking=
 it is the
>> faulty one...
>
> I wrote a little script that would tell me device name and serial num=
ber for each host port on my motherboard, along with anything else that=
 lists a scsi host in sysfs. =C2=A0Output like so:
>
> Controller device @ pci0000:00/0000:00:1c.1/0000:06:00.0 [ahci]
> =C2=A0RAID bus controller: Marvell Technology Group Ltd. 88SE6145 SAT=
A II PCI-E controller (rev a1)
> =C2=A0 =C2=A0host4: [Empty]
> =C2=A0 =C2=A0host5: /dev/sdd ATA WDC WD5000AAKS-7 {SN: WD-WMAWF137066=
8}
> =C2=A0 =C2=A0host6: [Empty]
> =C2=A0 =C2=A0host7: [Empty]
> =C2=A0 =C2=A0host8: [Empty]
> Controller device @ pci0000:00/0000:00:1f.1 [ata_piix]
> =C2=A0IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Contr=
oller (rev 01)
> =C2=A0 =C2=A0host9: [Empty]
> =C2=A0 =C2=A0host10: [Empty]
> Controller device @ pci0000:00/0000:00:1f.2 [ahci]
> =C2=A0SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SAT=
A AHCI Controller (rev 01)
> =C2=A0 =C2=A0host0: /dev/sda ATA ST31000333AS {SN: 9TE1LTW0}
> =C2=A0 =C2=A0host1: /dev/sdb ATA ST31000333AS {SN: 9TE1MAJT}
> =C2=A0 =C2=A0host2: /dev/sdc ATA ST31000333AS {SN: 9TE1MV1R}
> =C2=A0 =C2=A0host3: /dev/sr0 HL-DT-ST BD-RE GBW-H20L
>
> Shows me my empty ports, too. =C2=A0As long as I keep my cables strai=
ght to my hot-swap bays, getting the right drive is a snap.
>
> HTH,
>
> Phil
>
> I hereby release the following script into the public domain:
>
> #! /bin/bash
> #
> # Examine specific system host devices to identify the drives attache=
d
> #
>
> function describe_controller () {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unset SUBSYSTEM PCI_ID DEVICE PCI_SLOT_NAM=
E Manufacturer Product Serial
> =C2=A0 =C2=A0 =C2=A0 =C2=A0eval `udevadm info --query=3Dall --path=3D=
"$1" |grep '^E: ' |cut -c 4-`
> =C2=A0 =C2=A0 =C2=A0 =C2=A0echo "Controller device @ ${1##/sys/device=
s/} [$DRIVER]"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if [[ -n "$PCI_SLOT_NAME" ]] ; then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo -e " =C2=A0=
`lspci -s $PCI_SLOT_NAME |cut -d\ =C2=A0-f2-`"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if [[ "${MODALIAS:0:4}" =3D=3D "usb:" ]] ;=
 then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0eval `lsusb -D=
 ${DEVICE/proc/dev/} |sed -r -n -e 's% *i(Manufacturer|Product|Serial) =
+[0-9]+ +(.+) *$%\1=3D"\2"%;tFND;b;:FND;p'`
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo -e " =C2=A0=
[$Manufacturer] $Product {SN: $Serial}"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
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
-s /dev/$bdev |sed -r -n -e \"/Serial Number/{s%^.+' *(.+) *'.*\\\$%\\\=
\1%;p;q}\"`" &>/dev/null
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
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
