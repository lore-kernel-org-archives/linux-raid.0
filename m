From: "Majed B." <majedb@gmail.com>
Subject: Re: Re[6]: raid5: cannot start dirty degraded array
Date: Wed, 23 Dec 2009 17:35:37 +0300
Message-ID: <70ed7c3e0912230635o1dd1d03ewc9f2fa30973b48c7@mail.gmail.com>
References: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
	<52151829.20091223135001@kaneda.iguw.tuwien.ac.at> <70ed7c3e0912230525h25566bd8jae95ffab149caf65@mail.gmail.com>
	<953553783.20091223144402@kaneda.iguw.tuwien.ac.at> <70ed7c3e0912230548v1abacfcciadaab2888018b202@mail.gmail.com>
	<927342042.20091223150200@kaneda.iguw.tuwien.ac.at> <70ed7c3e0912230604m55eb6225sf68a819c6025e7b@mail.gmail.com>
	<1913939922.20091223153028@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1913939922.20091223153028@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You didn't have to specify sda1 during the assemble since you do NOT
want it part of the array (because it's dirty and faulty).

I don't know why your array takes 3 days to resync. My array is 7TB in
side (8x1TB @ RAID5) and it takes about 16 hours.

Check the value of this file:
cat /proc/sys/dev/raid/speed_limit_max

Make it a high number so that when there's no process querying the
disks, the resync process will go for the max speed.
echo '200000' > /proc/sys/dev/raid/speed_limit_max
(200 MB/s)

The file /proc/sys/dev/raid/speed_limit_min specified the minimum
speed at which the array should resync, even when there are other
programs querying the disks.

Make sure you run the above changes just before you issue a resync.
Changes are lost on reboot.

On Wed, Dec 23, 2009 at 5:30 PM, Rainer Fuegenstein
<rfu@kaneda.iguw.tuwien.ac.at> wrote:
> tnx for the info, in the meantime I did:
>
> mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/=
sdd1
>
> there was no mdadm.conf file, so I had to specify all devices and do =
a
> --force
>
>
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdb1[0] sdc1[3] sdd1[1]
> =C2=A0 =C2=A0 =C2=A04395407808 blocks level 5, 64k chunk, algorithm 2=
 [4/3] [UU_U]
>
> unused devices: <none>
>
> md0 is up :-)
>
> I'm about to start backing up the most important data; when this is
> done I assume the proper way to get back to normal again is:
>
> - remove the bad drive from the array: mdadm /dev/md0 -r /dev/sda1
> - physically replace sda with a new drive
> - add it back: mdadm /dev/md0 -a /dev/sda1
> - wait three days for the sync to complete (and keep fingers crossed
> that no other drive fails)
>
> big tnx!
>
>
> MB> sda1 was the only affected member of the array so you should be a=
ble
> MB> to force-assemble the raid5 array and run it in degraded mode.
>
> MB> mdadm -Af /dev/md0
> MB> If that doesn't work for any reason, do this:
> MB> mdadm -Af /dev/md0 /dev/sdb1 /dev/sdd1 /dev/sdc1
>
> MB> You can note the disk order from the output of mdadm -E
>
> MB> On Wed, Dec 23, 2009 at 5:02 PM, Rainer Fuegenstein
> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>>>
>>> MB> My bad, run this: mdadm -E /dev/sd[a-z]1
>>> should have figured this out myself (sorry; currently running in
>>> panic mode ;-) )
>>>
>>> MB> 1 is the partition which most likely you added to the array rat=
her
>>> MB> than the whole disk (which is normal).
>>>
>>> # mdadm -E /dev/sd[a-z]1
>>> /dev/sda1:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 0.90.00
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 81833582:d651e953:48cc579=
7:38b256ea
>>> =C2=A0Creation Time : Mon Mar 31 13:30:45 2008
>>> =C2=A0 =C2=A0 Raid Level : raid5
>>> =C2=A0Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>> =C2=A0 =C2=A0 Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
>>> =C2=A0 Raid Devices : 4
>>> =C2=A0Total Devices : 4
>>> Preferred Minor : 0
>>>
>>> =C2=A0 =C2=A0Update Time : Wed Dec 23 02:54:49 2009
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>> =C2=A0Active Devices : 4
>>> Working Devices : 4
>>> =C2=A0Failed Devices : 0
>>> =C2=A0Spare Devices : 0
>>> =C2=A0 =C2=A0 =C2=A0 Checksum : 6cfa3a64 - correct
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 119530
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>
>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDev=
ice State
>>> this =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=
=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sda1
>>>
>>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 17 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdb1
>>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 49 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd1
>>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda1
>>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 33 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc1
>>> /dev/sdb1:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 0.90.00
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 81833582:d651e953:48cc579=
7:38b256ea
>>> =C2=A0Creation Time : Mon Mar 31 13:30:45 2008
>>> =C2=A0 =C2=A0 Raid Level : raid5
>>> =C2=A0Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>> =C2=A0 =C2=A0 Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
>>> =C2=A0 Raid Devices : 4
>>> =C2=A0Total Devices : 4
>>> Preferred Minor : 0
>>>
>>> =C2=A0 =C2=A0Update Time : Wed Dec 23 10:07:42 2009
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : active
>>> =C2=A0Active Devices : 3
>>> Working Devices : 3
>>> =C2=A0Failed Devices : 1
>>> =C2=A0Spare Devices : 0
>>> =C2=A0 =C2=A0 =C2=A0 Checksum : 6cf8f610 - correct
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 130037
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>
>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDev=
ice State
>>> this =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 17=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdb1
>>>
>>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 17 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdb1
>>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 49 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd1
>>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0faulty remove=
d
>>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 33 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc1
>>> /dev/sdc1:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 0.90.00
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 81833582:d651e953:48cc579=
7:38b256ea
>>> =C2=A0Creation Time : Mon Mar 31 13:30:45 2008
>>> =C2=A0 =C2=A0 Raid Level : raid5
>>> =C2=A0Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>> =C2=A0 =C2=A0 Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
>>> =C2=A0 Raid Devices : 4
>>> =C2=A0Total Devices : 4
>>> Preferred Minor : 0
>>>
>>> =C2=A0 =C2=A0Update Time : Wed Dec 23 10:07:42 2009
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : active
>>> =C2=A0Active Devices : 3
>>> Working Devices : 3
>>> =C2=A0Failed Devices : 1
>>> =C2=A0Spare Devices : 0
>>> =C2=A0 =C2=A0 =C2=A0 Checksum : 6cf8f626 - correct
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 130037
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>
>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDev=
ice State
>>> this =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 33=
 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdc1
>>>
>>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 17 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdb1
>>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 49 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd1
>>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0faulty remove=
d
>>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 33 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc1
>>> /dev/sdd1:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 0.90.00
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 81833582:d651e953:48cc579=
7:38b256ea
>>> =C2=A0Creation Time : Mon Mar 31 13:30:45 2008
>>> =C2=A0 =C2=A0 Raid Level : raid5
>>> =C2=A0Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>> =C2=A0 =C2=A0 Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
>>> =C2=A0 Raid Devices : 4
>>> =C2=A0Total Devices : 4
>>> Preferred Minor : 0
>>>
>>> =C2=A0 =C2=A0Update Time : Wed Dec 23 10:07:42 2009
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : active
>>> =C2=A0Active Devices : 3
>>> Working Devices : 3
>>> =C2=A0Failed Devices : 1
>>> =C2=A0Spare Devices : 0
>>> =C2=A0 =C2=A0 =C2=A0 Checksum : 6cf8f632 - correct
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 130037
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>
>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDev=
ice State
>>> this =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 49=
 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdd1
>>>
>>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 17 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdb1
>>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 49 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd1
>>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0faulty remove=
d
>>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 33 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc1
>>> [root@alfred log]#
>>>
>>> MB> You've included the smart report of one disk only. I suggest yo=
u look
>>> MB> at the other disks as well and make sure that they're not repor=
ting
>>> MB> any errors. Also, keep in mind that you should run smart test
>>> MB> periodically (can be configured) and that if you haven't run an=
y test
>>> MB> before, you have to run a long or offline test before making su=
re that
>>> MB> you don't have bad sectors.
>>>
>>> tnx for the hint, will do that as soon as I got my data back (if ev=
er
>>> ...)
>>>
>>>
>>> MB> On Wed, Dec 23, 2009 at 4:44 PM, Rainer Fuegenstein
>>> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>>>>>
>>>>> MB> Give the output of these:
>>>>> MB> mdadm -E /dev/sd[a-z]
>>>>>
>>>>> ]# mdadm -E /dev/sd[a-z]
>>>>> mdadm: No md superblock detected on /dev/sda.
>>>>> mdadm: No md superblock detected on /dev/sdb.
>>>>> mdadm: No md superblock detected on /dev/sdc.
>>>>> mdadm: No md superblock detected on /dev/sdd.
>>>>>
>>>>> I assume that's not a good sign ?!
>>>>>
>>>>> sda was powered on and running after the reboot, a smartctl short=
 test
>>>>> revealed no errors and smartctl -a also looks unsuspicious (see
>>>>> below). the drives are rather new.
>>>>>
>>>>> guess its more likely to be either a problem of the power supply
>>>>> (400W) or communication between controller and disk.
>>>>>
>>>>> /dev/sdd (before it was replaced) reported the following:
>>>>>
>>>>> Dec 20 07:18:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offline =
uncorrectable sectors
>>>>> Dec 20 07:48:53 alfred smartd[2705]: Device: /dev/sdd, 1 Offline =
uncorrectable sectors
>>>>> Dec 20 08:18:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offline =
uncorrectable sectors
>>>>> Dec 20 08:48:55 alfred smartd[2705]: Device: /dev/sdd, 1 Offline =
uncorrectable sectors
>>>>> Dec 20 09:18:53 alfred smartd[2705]: Device: /dev/sdd, 1 Offline =
uncorrectable sectors
>>>>> Dec 20 09:48:58 alfred smartd[2705]: Device: /dev/sdd, 1 Offline =
uncorrectable sectors
>>>>> Dec 20 10:19:01 alfred smartd[2705]: Device: /dev/sdd, 1 Offline =
uncorrectable sectors
>>>>> Dec 20 10:48:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offline =
uncorrectable sectors
>>>>>
>>>>> (what triggered a re-sync of the array)
>>>>>
>>>>>
>>>>> # smartctl -a /dev/sda
>>>>> smartctl version 5.38 [i686-redhat-linux-gnu] Copyright (C) 2002-=
8 Bruce Allen
>>>>> Home page is http://smartmontools.sourceforge.net/
>>>>>
>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>>>>> Device Model: =C2=A0 =C2=A0 WDC WD15EADS-00R6B0
>>>>> Serial Number: =C2=A0 =C2=A0WD-WCAUP0017818
>>>>> Firmware Version: 01.00A01
>>>>> User Capacity: =C2=A0 =C2=A01,500,301,910,016 bytes
>>>>> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0Not in smartctl database [f=
or details use: -P showall]
>>>>> ATA Version is: =C2=A0 8
>>>>> ATA Standard is: =C2=A0Exact ATA specification draft version not =
indicated
>>>>> Local Time is: =C2=A0 =C2=A0Wed Dec 23 14:40:46 2009 CET
>>>>> SMART support is: Available - device has SMART capability.
>>>>> SMART support is: Enabled
>>>>>
>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
>>>>> SMART overall-health self-assessment test result: PASSED
>>>>>
>>>>> General SMART Values:
>>>>> Offline data collection status: =C2=A0(0x82) Offline data collect=
ion activity
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
was completed without error.
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Auto Offline Data Collection: Enabled.
>>>>> Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A0 0) The p=
revious self-test routine completed
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
without error or no self-test has ever
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
been run.
>>>>> Total time to complete Offline
>>>>> data collection: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (40800) seconds.
>>>>> Offline data collection
>>>>> capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0(0x7b) SMART execute Offline immediate.
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Auto Offline data collection on/off support.
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Suspend Offline collection upon new
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
command.
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Offline surface scan supported.
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Self-test supported.
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Conveyance Self-test supported.
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Selective Self-test supported.
>>>>> SMART capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x0=
003) Saves SMART data before entering
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
power-saving mode.
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Supports SMART auto save timer.
>>>>> Error logging capability: =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x01) Error=
 logging supported.
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
General Purpose Logging supported.
>>>>> Short self-test routine
>>>>> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 2) =
minutes.
>>>>> Extended self-test routine
>>>>> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( 255) minut=
es.
>>>>> Conveyance self-test routine
>>>>> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 5) =
minutes.
>>>>> SCT capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
(0x303f) SCT Status supported.
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
SCT Feature Control supported.
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
SCT Data Table supported.
>>>>>
>>>>> SMART Attributes Data Structure revision number: 16
>>>>> Vendor Specific SMART Attributes with Thresholds:
>>>>> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =
=C2=A0 VALUE WORST THRESH TYPE =C2=A0 =C2=A0 =C2=A0UPDATED =C2=A0WHEN_F=
AILED RAW_VALUE
>>>>> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x002f =C2=A0 200 =C2=A0=
 200 =C2=A0 051 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0=
 - =C2=A0 =C2=A0 =C2=A0 0
>>>>> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0=
027 =C2=A0 177 =C2=A0 145 =C2=A0 021 =C2=A0 =C2=A0Pre-fail =C2=A0Always=
 =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 8133
>>>>> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 100 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=
=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 15
>>>>> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 200 =C2=A0 200=
 =C2=A0 140 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
>>>>> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x002e =C2=A0=
 200 =C2=A0 200 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=
=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>>>> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=
=A0 093 =C2=A0 093 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0=
 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 5272
>>>>> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 100 =C2=A0 253 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=
=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>>>> =C2=A011 Calibration_Retry_Count 0x0032 =C2=A0 100 =C2=A0 253 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0=
 =C2=A0 =C2=A0 0
>>>>> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100=
 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0=
 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 14
>>>>> 192 Power-Off_Retract_Count 0x0032 =C2=A0 200 =C2=A0 200 =C2=A0 0=
00 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 2
>>>>> 193 Load_Cycle_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 200=
 =C2=A0 200 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0=
 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 13
>>>>> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0022 =C2=A0 125 =C2=A0 10=
9 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =
=C2=A0 =C2=A0 =C2=A0 27
>>>>> 196 Reallocated_Event_Count 0x0032 =C2=A0 200 =C2=A0 200 =C2=A0 0=
00 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 0
>>>>> 197 Current_Pending_Sector =C2=A00x0032 =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0=
 =C2=A0 =C2=A0 0
>>>>> 198 Offline_Uncorrectable =C2=A0 0x0030 =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0=
 =C2=A0 =C2=A0 0
>>>>> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x0032 =C2=A0 200 =C2=A0 20=
0 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =
=C2=A0 =C2=A0 =C2=A0 0
>>>>> 200 Multi_Zone_Error_Rate =C2=A0 0x0008 =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0=
 =C2=A0 =C2=A0 0
>>>>>
>>>>> SMART Error Log Version: 1
>>>>> No Errors Logged
>>>>>
>>>>> SMART Self-test log structure revision number 1
>>>>> Num =C2=A0Test_Description =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining =C2=A0LifeTime(hour=
s) =C2=A0LBA_of_first_error
>>>>> # 1 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without er=
ror =C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05272 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 -
>>>>>
>>>>> SMART Selective self-test log data structure revision number 1
>>>>> =C2=A0SPAN =C2=A0MIN_LBA =C2=A0MAX_LBA =C2=A0CURRENT_TEST_STATUS
>>>>> =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0Not_testing
>>>>> =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0Not_testing
>>>>> =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0Not_testing
>>>>> =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0Not_testing
>>>>> =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0Not_testing
>>>>> Selective self-test flags (0x0):
>>>>> =C2=A0After scanning selected spans, do NOT read-scan remainder o=
f disk.
>>>>> If Selective self-test is pending on power-up, resume after 0 min=
ute delay.
>>>>>
>>>>>
>>>>>
>>>>>>>From the errors you show, it seems like one of the disks is dead=
 (sda)
>>>>> MB> or dying. It could be just a bad PCB (the controller board of=
 the
>>>>> MB> disk) as it refuses to return SMART data, so you might be abl=
e to
>>>>> MB> rescue data by changing the PCB, if it's that important to ha=
ve that
>>>>> MB> disk.
>>>>>
>>>>> MB> As for the array, you can run a degraded array by force assem=
bling it:
>>>>> MB> mdadm -Af /dev/md0
>>>>> MB> In the command above, mdadm will search on existing disks and
>>>>> MB> partitions, which of them belongs to an array and assemble th=
at array,
>>>>> MB> if possible.
>>>>>
>>>>> MB> I also suggest you install smartmontools package and run smar=
tctl -a
>>>>> MB> /dev/sd[a-z] and see the report for each disk to make sure yo=
u don't
>>>>> MB> have bad sectors or bad cables (CRC/ATA read errors) on any o=
f the
>>>>> MB> disks.
>>>>>
>>>>> MB> On Wed, Dec 23, 2009 at 3:50 PM, Rainer Fuegenstein
>>>>> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>>>>>>> addendum: when going through the logs I found the reason:
>>>>>>>
>>>>>>> Dec 23 02:55:40 alfred kernel: ata1.00: exception Emask 0x0 SAc=
t 0x0 SErr 0x0 action 0x6 frozen
>>>>>>> Dec 23 02:55:40 alfred kernel: ata1.00: cmd ea/00:00:00:00:00/0=
0:00:00:00:00/a0 tag 0
>>>>>>> Dec 23 02:55:40 alfred kernel: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>>>>>> Dec 23 02:55:40 alfred kernel: ata1.00: status: { DRDY }
>>>>>>> Dec 23 02:55:45 alfred kernel: ata1: link is slow to respond, p=
lease be patient (ready=3D0)
>>>>>>> Dec 23 02:55:50 alfred kernel: ata1: device not ready (errno=3D=
-16), forcing hardreset
>>>>>>> Dec 23 02:55:50 alfred kernel: ata1: soft resetting link
>>>>>>> Dec 23 02:55:55 alfred kernel: ata1: link is slow to respond, p=
lease be patient (ready=3D0)
>>>>>>> Dec 23 02:56:00 alfred kernel: ata1: SRST failed (errno=3D-16)
>>>>>>> Dec 23 02:56:00 alfred kernel: ata1: soft resetting link
>>>>>>> Dec 23 02:56:05 alfred kernel: ata1: link is slow to respond, p=
lease be patient (ready=3D0)
>>>>>>> Dec 23 02:56:10 alfred kernel: ata1: SRST failed (errno=3D-16)
>>>>>>> Dec 23 02:56:10 alfred kernel: ata1: soft resetting link
>>>>>>> Dec 23 02:56:15 alfred kernel: ata1: link is slow to respond, p=
lease be patient (ready=3D0)
>>>>>>> Dec 23 02:56:45 alfred kernel: ata1: SRST failed (errno=3D-16)
>>>>>>> Dec 23 02:56:45 alfred kernel: ata1: limiting SATA link speed t=
o 1.5 Gbps
>>>>>>> Dec 23 02:56:45 alfred kernel: ata1: soft resetting link
>>>>>>> Dec 23 02:56:50 alfred kernel: ata1: SRST failed (errno=3D-16)
>>>>>>> Dec 23 02:56:50 alfred kernel: ata1: reset failed, giving up
>>>>>>> Dec 23 02:56:50 alfred kernel: ata1.00: disabled
>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: timing out command, =
waited 30s
>>>>>>> Dec 23 02:56:50 alfred kernel: ata1: EH complete
>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return c=
ode =3D 0x00040000
>>>>>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda,=
 sector 1244700223
>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return c=
ode =3D 0x00040000
>>>>>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda,=
 sector 1554309191
>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return c=
ode =3D 0x00040000
>>>>>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda,=
 sector 1554309439
>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return c=
ode =3D 0x00040000
>>>>>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda,=
 sector 572721343
>>>>>>> Dec 23 02:56:50 alfred kernel: raid5: Disk failure on sda1, dis=
abling device. Operation continuing on 3 devices
>>>>>>> Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
>>>>>>> Dec 23 02:56:50 alfred kernel: =C2=A0--- rd:4 wd:3 fd:1
>>>>>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 0, o:1, dev:sdb1
>>>>>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 1, o:1, dev:sdd1
>>>>>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 2, o:0, dev:sda1
>>>>>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 3, o:1, dev:sdc1
>>>>>>> Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
>>>>>>> Dec 23 02:56:50 alfred kernel: =C2=A0--- rd:4 wd:3 fd:1
>>>>>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 0, o:1, dev:sdb1
>>>>>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 1, o:1, dev:sdd1
>>>>>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 3, o:1, dev:sdc1
>>>>>>> Dec 23 03:22:57 alfred smartd[2692]: Device: /dev/sda, not capa=
ble of SMART self-check
>>>>>>> Dec 23 03:22:57 alfred smartd[2692]: Sending warning via mail t=
o root ...
>>>>>>> Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to root: =
successful
>>>>>>> Dec 23 03:22:58 alfred smartd[2692]: Device: /dev/sda, failed t=
o read SMART Attribute Data
>>>>>>> Dec 23 03:22:58 alfred smartd[2692]: Sending warning via mail t=
o root ...
>>>>>>> Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to root: =
successful
>>>>>>> Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, not capa=
ble of SMART self-check
>>>>>>> Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, failed t=
o read SMART Attribute Data
>>>>>>> Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, not capa=
ble of SMART self-check
>>>>>>> Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, failed t=
o read SMART Attribute Data
>>>>>>> Dec 23 04:52:57 alfred smartd[2692]: Device: /dev/sda, not capa=
ble of SMART self-check
>>>>>>> =C2=A0[...]
>>>>>>> Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, not capa=
ble of SMART self-check
>>>>>>> Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, failed t=
o read SMART Attribute Data
>>>>>>> =C2=A0(crash here)
>>>>>>>
>>>>>>>
>>>>>>> RF> hi,
>>>>>>>
>>>>>>> RF> got a "nice" early christmas present this morning: after a =
crash, the raid5
>>>>>>> RF> (consisting of 4*1.5TB WD caviar green SATA disks) won't st=
art :-(
>>>>>>>
>>>>>>> RF> the history:
>>>>>>> RF> sometimes, the raid kicked out one disk, started a resync (=
which
>>>>>>> RF> lasted for about 3 days) and was fine after that. a few day=
s ago I
>>>>>>> RF> replaced drive sdd (which seemed to cause the troubles) and=
 synced the
>>>>>>> RF> raid again which finished yesterday in the early afternoon.=
 at 10am
>>>>>>> RF> today the system crashed and the raid won't start:
>>>>>>>
>>>>>>> RF> OS is Centos 5
>>>>>>> RF> mdadm - v2.6.9 - 10th March 2009
>>>>>>> RF> Linux alfred 2.6.18-164.6.1.el5xen #1 SMP Tue Nov 3 17:53:4=
7 EST 2009 i686 athlon i386 GNU/Linux
>>>>>>>
>>>>>>>
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: Autodetecting RAID array=
s.
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: autorun ...
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: considering sdd1 ...
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sdd1 ...
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sdc1 ...
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sdb1 ...
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sda1 ...
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: created md0
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sda1>
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdb1>
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdc1>
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdd1>
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: running: <sdd1><sdc1><sd=
b1><sda1>
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: kicking non-fresh sda1 f=
rom array!
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sda1>
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sda1)
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: md0: raid array is not c=
lean -- starting background reconstruction
>>>>>>> RF> =C2=A0 =C2=A0 (no reconstruction is actually started, disks=
 are idle)
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: automatically using b=
est checksumming function: pIII_sse
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: =C2=A0 =C2=A0pIII_sse =C2=A0=
: =C2=A07085.000 MB/sec
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: using function: pIII_=
sse (7085.000 MB/sec)
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x1 =C2=A0 =C2=A0=
896 MB/s
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x2 =C2=A0 =C2=A0=
972 MB/s
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x4 =C2=A0 =C2=A0=
893 MB/s
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x8 =C2=A0 =C2=A0=
934 MB/s
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx1 =C2=A0 =C2=A0 1=
845 MB/s
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx2 =C2=A0 =C2=A0 3=
250 MB/s
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x1 =C2=A0 =C2=A01=
799 MB/s
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x2 =C2=A0 =C2=A03=
067 MB/s
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x1 =C2=A0 =C2=A02=
980 MB/s
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x2 =C2=A0 =C2=A04=
015 MB/s
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: using algorithm sse2x=
2 (4015 MB/s)
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: raid6 personality regist=
ered for level 6
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: raid5 personality regist=
ered for level 5
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: raid4 personality regist=
ered for level 4
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdd1 operation=
al as raid disk 1
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdc1 operation=
al as raid disk 3
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdb1 operation=
al as raid disk 0
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: cannot start dirty de=
graded array for md0
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: RAID5 conf printout:
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: =C2=A0--- rd:4 wd:3 fd:1
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: =C2=A0disk 0, o:1, dev:sdb1
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: =C2=A0disk 1, o:1, dev:sdd1
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: =C2=A0disk 3, o:1, dev:sdc1
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: failed to run raid se=
t md0
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: pers->run() failed ...
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: do_md_run() returned -5
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: md0 stopped.
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdd1>
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdd1)
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdc1>
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdc1)
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdb1>
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdb1)
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: ... autorun DONE.
>>>>>>> RF> Dec 23 12:30:19 alfred kernel: device-mapper: multipath: ve=
rsion 1.0.5 loaded
>>>>>>>
>>>>>>> RF> # cat /proc/mdstat
>>>>>>> RF> Personalities : [raid6] [raid5] [raid4]
>>>>>>> RF> unused devices: <none>
>>>>>>>
>>>>>>> RF> filesystem used on top of md0 is xfs.
>>>>>>>
>>>>>>> RF> please advice what to do next and let me know if you need f=
urther
>>>>>>> RF> information. really don't want to lose 3TB worth of data :-=
(
>>>>>>>
>>>>>>>
>>>>>>> RF> tnx in advance.
>>>>>>>
>>>>>>> RF> --
>>>>>>> RF> To unsubscribe from this list: send the line "unsubscribe l=
inux-raid" in
>>>>>>> RF> the body of a message to majordomo@vger.kernel.org
>>>>>>> RF> More majordomo info at =C2=A0http://vger.kernel.org/majordo=
mo-info.html
>>>>>>>
>>>>>>>
>>>>>>> ---------------------------------------------------------------=
---------------
>>>>>>> Unix gives you just enough rope to hang yourself -- and then a =
couple of more
>>>>>>> feet, just to be sure.
>>>>>>> (Eric Allman)
>>>>>>> ---------------------------------------------------------------=
---------------
>>>>>>>
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
-raid" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-i=
nfo.html
>>>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> -----------------------------------------------------------------=
-------------
>>>>> Unix gives you just enough rope to hang yourself -- and then a co=
uple of more
>>>>> feet, just to be sure.
>>>>> (Eric Allman)
>>>>> -----------------------------------------------------------------=
-------------
>>>>>
>>>>>
>>>
>>>
>>>
>>>
>>>
>>> -------------------------------------------------------------------=
-----------
>>> Unix gives you just enough rope to hang yourself -- and then a coup=
le of more
>>> feet, just to be sure.
>>> (Eric Allman)
>>> -------------------------------------------------------------------=
-----------
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>
>
>
>
>
> ---------------------------------------------------------------------=
---------
> Unix gives you just enough rope to hang yourself -- and then a couple=
 of more
> feet, just to be sure.
> (Eric Allman)
> ---------------------------------------------------------------------=
---------
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
