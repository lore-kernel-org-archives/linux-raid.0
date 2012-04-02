From: Bryan Bush <bbushvt@gmail.com>
Subject: Re: RAID6 grow failed
Date: Sun, 1 Apr 2012 20:44:17 -0400
Message-ID: <CAJ72viMHqGKhMTFDE0LqRZ_5hXm_3R8B9FZ92HPJHbv4BXsEDQ@mail.gmail.com>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
	<20120328151828.6988d3db@notabene.brown>
	<CAJ72viMxgfjhQiqJYVnjBQGfCq7jtegfvUY0nRdj46XDedeSjg@mail.gmail.com>
	<20120328192601.3db82133@notabene.brown>
	<CAJ72viPX1SDL2pPSkGQnujNcaoNmRposJXxaLhDkZDgFxv=-qA@mail.gmail.com>
	<CAJ72viPH9AykY-tafTChcS0ZbP0gGaiKRybafs4C4Yk-8D=g3A@mail.gmail.com>
	<20120401080036.355a8a23@notabene.brown>
	<CAJ72viOGCYrMqvX2=3BzWQZpfDUeNwHEVHbXyaKbrwvrBP6wPQ@mail.gmail.com>
	<CAJ72viPw=QrETGPU5OwBgL-GXfCUfqfbWCSAvp2_yzzxuJeT1w@mail.gmail.com>
	<20120402095425.168e5d94@notabene.brown>
	<CAJ72viOU2O-1rsaJWKbDbR6XS+VYfDuWa8DpN=+w-1BYp7fwNA@mail.gmail.com>
	<20120402102600.4046c483@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120402102600.4046c483@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

my mdadm version is
root@diamond:/# mdadm -V
mdadm - v2.6.7.1 - 15th October 2008

Here is the output from udevadm monitor
KERNEL[1333327039.975612] add      /devices/virtual/block/md1 (block)
KERNEL[1333327039.975652] add      /devices/virtual/bdi/9:1 (bdi)
KERNEL[1333327039.975748] change   /devices/virtual/block/md1 (block)
UDEV  [1333327039.975859] add      /devices/virtual/block/md1 (block)
UDEV  [1333327039.975889] add      /devices/virtual/bdi/9:1 (bdi)
UDEV  [1333327039.976131] change   /devices/virtual/block/md1 (block)
KERNEL[1333327040.022682] change
/devices/pci0000:00/0000:00:13.0/0000:03:00.0/host2/target2:0:0/2:0:0:0=
/block/sdb/sdb1
(block)
KERNEL[1333327040.023186] change
/devices/pci0000:00/0000:00:13.0/0000:03:00.0/host2/target2:1:0/2:1:0:0=
/block/sdc/sdc1
(block)
KERNEL[1333327040.023765] change
/devices/pci0000:00/0000:00:13.0/0000:03:00.0/host2/target2:2:0/2:2:0:0=
/block/sdd/sdd1
(block)
KERNEL[1333327040.023969] change
/devices/pci0000:00/0000:00:13.0/0000:03:00.0/host2/target2:3:0/2:3:0:0=
/block/sde/sde1
(block)
UDEV  [1333327040.033204] change
/devices/pci0000:00/0000:00:13.0/0000:03:00.0/host2/target2:1:0/2:1:0:0=
/block/sdc/sdc1
(block)
KERNEL[1333327040.034437] change
/devices/pci0000:00/0000:00:16.0/0000:04:00.0/host7/target7:0:0/7:0:0:0=
/block/sdh/sdh1
(block)
UDEV  [1333327040.035269] change
/devices/pci0000:00/0000:00:13.0/0000:03:00.0/host2/target2:0:0/2:0:0:0=
/block/sdb/sdb1
(block)
KERNEL[1333327040.044692] change
/devices/pci0000:00/0000:00:16.0/0000:04:00.0/host12/target12:0:0/12:0:=
0:0/block/sdj/sdj1
(block)
KERNEL[1333327040.057077] change
/devices/pci0000:00/0000:00:16.0/0000:04:00.0/host13/target13:0:0/13:0:=
0:0/block/sdk/sdk1
(block)
KERNEL[1333327040.057430] change
/devices/pci0000:00/0000:00:18.0/0000:06:00.0/host17/target17:0:0/17:0:=
0:0/block/sdl/sdl1
(block)
KERNEL[1333327040.057658] change
/devices/pci0000:00/0000:00:18.0/0000:06:00.0/host17/target17:2:0/17:2:=
0:0/block/sdn/sdn1
(block)
KERNEL[1333327040.057888] change
/devices/pci0000:00/0000:00:18.0/0000:06:00.0/host17/target17:3:0/17:3:=
0:0/block/sdo/sdo1
(block)
UDEV  [1333327040.067716] change
/devices/pci0000:00/0000:00:18.0/0000:06:00.0/host17/target17:0:0/17:0:=
0:0/block/sdl/sdl1
(block)
UDEV  [1333327040.235203] change
/devices/pci0000:00/0000:00:13.0/0000:03:00.0/host2/target2:3:0/2:3:0:0=
/block/sde/sde1
(block)
UDEV  [1333327040.269335] change
/devices/pci0000:00/0000:00:18.0/0000:06:00.0/host17/target17:3:0/17:3:=
0:0/block/sdo/sdo1
(block)
UDEV  [1333327040.422753] change
/devices/pci0000:00/0000:00:16.0/0000:04:00.0/host7/target7:0:0/7:0:0:0=
/block/sdh/sdh1
(block)
UDEV  [1333327040.457015] change
/devices/pci0000:00/0000:00:13.0/0000:03:00.0/host2/target2:2:0/2:2:0:0=
/block/sdd/sdd1
(block)
UDEV  [1333327040.480483] change
/devices/pci0000:00/0000:00:18.0/0000:06:00.0/host17/target17:2:0/17:2:=
0:0/block/sdn/sdn1
(block)
UDEV  [1333327040.633694] change
/devices/pci0000:00/0000:00:16.0/0000:04:00.0/host12/target12:0:0/12:0:=
0:0/block/sdj/sdj1
(block)
UDEV  [1333327040.845071] change
/devices/pci0000:00/0000:00:16.0/0000:04:00.0/host13/target13:0:0/13:0:=
0:0/block/sdk/sdk1
(block)

When I use mdadm 3.2.1 I get
root@diamond:~/mdadm/mdadm-3.2.1# ./mdadm -A --verbose /dev/md1
/dev/sd[onjlkuhedcb]1
mdadm: looking for devices for /dev/md1
mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 4.
mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 5.
mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 6.
mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 7.
mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 12.
mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 10.
mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 8.
mdadm: /dev/sdl1 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sdn1 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdo1 is identified as a member of /dev/md1, slot 3.
mdadm: device 8 in /dev/md1 has wrong state in superblock, but
/dev/sdk1 seems ok
mdadm: device 10 in /dev/md1 has wrong state in superblock, but
/dev/sdj1 seems ok
mdadm: device 12 in /dev/md1 has wrong state in superblock, but
/dev/sdh1 seems ok
mdadm: no uptodate device for slot 1 of /dev/md1
mdadm: added /dev/sdn1 to /dev/md1 as 2
mdadm: added /dev/sdo1 to /dev/md1 as 3
mdadm: added /dev/sdb1 to /dev/md1 as 4
mdadm: added /dev/sdc1 to /dev/md1 as 5
mdadm: added /dev/sdd1 to /dev/md1 as 6
mdadm: added /dev/sde1 to /dev/md1 as 7
mdadm: added /dev/sdk1 to /dev/md1 as 8
mdadm: no uptodate device for slot 9 of /dev/md1
mdadm: added /dev/sdj1 to /dev/md1 as 10
mdadm: no uptodate device for slot 11 of /dev/md1
mdadm: added /dev/sdh1 to /dev/md1 as 12
mdadm: added /dev/sdl1 to /dev/md1 as 0
mdadm: /dev/md1 assembled from 10 drives - not enough to start the arra=
y.


Should I try to force it?  Worried it might make things worse.
Thanks
-Bryan



On Sun, Apr 1, 2012 at 8:26 PM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 1 Apr 2012 20:02:57 -0400 Bryan Bush <bbushvt@gmail.com> wrot=
e:
>
>> root@diamond:/# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md1 : inactive sdk1[13](S) sdj1[11](S) sdh1[9](S) sdo1[3](S)
>> sdd1[6](S) sde1[7](S) sdn1[2](S) sdl1[0](S) sdb1[4](S) sdc1[8](S)
>> =A0 =A0 =A0 19535134315 blocks super 1.2
>>
>> md0 : active raid5 sdg1[3] sda1[0] sdf1[1] sdq1[2]
>> =A0 =A0 =A0 2929686528 blocks level 5, 256k chunk, algorithm 2 [4/4]=
 [UUUU]
>>
>> unused devices: <none>
>> root@diamond:/# mdadm -S /dev/md1
>> mdadm: stopped /dev/md1
>> root@diamond:/# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md0 : active raid5 sdg1[3] sda1[0] sdf1[1] sdq1[2]
>> =A0 =A0 =A0 2929686528 blocks level 5, 256k chunk, algorithm 2 [4/4]=
 [UUUU]
>>
>> unused devices: <none>
>> root@diamond:/# mdadm -A --verbose /dev/md1 /dev/sd[onjlkuhedcb]1
>> mdadm: looking for devices for /dev/md1
>> mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 4.
>> mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 5.
>> mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 6.
>> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 7.
>> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 12.
>> mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 10.
>> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 8.
>> mdadm: /dev/sdl1 is identified as a member of /dev/md1, slot 0.
>> mdadm: /dev/sdn1 is identified as a member of /dev/md1, slot 2.
>> mdadm: /dev/sdo1 is identified as a member of /dev/md1, slot 3.
>> mdadm: device 8 in /dev/md1 has wrong state in superblock, but
>> /dev/sdk1 seems ok
>> mdadm: device 10 in /dev/md1 has wrong state in superblock, but
>> /dev/sdj1 seems ok
>> mdadm: device 12 in /dev/md1 has wrong state in superblock, but
>> /dev/sdh1 seems ok
>> mdadm: SET_ARRAY_INFO failed for /dev/md1: Device or resource busy
>> root@diamond:/# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md1 : inactive sdk1[13](S) sdj1[11](S) sdd1[6](S) sdh1[9](S)
>> sdo1[3](S) sde1[7](S) sdn1[2](S) sdl1[0](S) sdc1[8](S) sdb1[4](S)
>> =A0 =A0 =A0 19535134315 blocks super 1.2
>>
>> md0 : active raid5 sdg1[3] sda1[0] sdf1[1] sdq1[2]
>> =A0 =A0 =A0 2929686528 blocks level 5, 256k chunk, algorithm 2 [4/4]=
 [UUUU]
>>
>> unused devices: <none>
>>
>>
>> Output from /var/log/messages for the mdadm -A
>> Apr =A01 20:00:57 diamond kernel: [106978.432900] md: md1 stopped.
>> Apr =A01 20:00:57 diamond kernel: [106978.493151] md: bind<sdc1>
>> Apr =A01 20:00:57 diamond kernel: [106978.494551] md: bind<sdb1>
>> Apr =A01 20:00:57 diamond kernel: [106978.496256] md: bind<sdd1>
>> Apr =A01 20:00:57 diamond kernel: [106978.516939] md: array md1 alre=
ady has disks!
>
> That is where SET_ARRAY_INFO is failing ... but why does md1 already =
have
> disks I wonder...
>
> either mdadm has some weird bug - what version are you running???
>
> or something else is messing with md1.
>
> Maybe udev is noticing those devices again for some reason and trying=
 to add
> them to the array independently.
> You could run
> =A0 udevadm monitor
>
> at the same time and see what happens.
> Also look in /lib/udev/rules.d or /etc/udev/rules.d to find an entry =
that
> run "mdadm -I" or "mdadm --incremental" and =A0try commenting that en=
try out.
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
