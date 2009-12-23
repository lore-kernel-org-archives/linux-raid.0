From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re[10]: raid5: cannot start dirty degraded array
Date: Wed, 23 Dec 2009 18:03:08 +0100
Message-ID: <512145787.20091223180308@kaneda.iguw.tuwien.ac.at>
References: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
 <52151829.20091223135001@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230525h25566bd8jae95ffab149caf65@mail.gmail.com>
 <953553783.20091223144402@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230548v1abacfcciadaab2888018b202@mail.gmail.com>
 <927342042.20091223150200@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230604m55eb6225sf68a819c6025e7b@mail.gmail.com>
 <1913939922.20091223153028@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230635o1dd1d03ewc9f2fa30973b48c7@mail.gmail.com>
 <10710122978.20091223161328@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230716j5e1d552dqc01a25d8c0e72b26@mail.gmail.com>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912230716j5e1d552dqc01a25d8c0e72b26@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


MB> Is the disk being kicked always on the same port? (port 1 for examp=
le)

not sure how to interpret the syslog messages:

Nov 28 21:24:40 alfred kernel: ata2.00: exception Emask 0x0 SAct 0x0 SE=
rr 0x0 action 0x6 frozen
Nov 28 21:24:40 alfred kernel: ata2.00: cmd b0/da:00:00:4f:c2/00:00:00:=
00:00/00 tag 0
Nov 28 21:24:40 alfred kernel:          res 40/00:00:00:00:00/00:00:00:=
00:00/00 Emask 0x4 (timeout)
Nov 28 21:24:40 alfred kernel: ata2.00: status: { DRDY }
Nov 28 21:24:40 alfred kernel: ata2: soft resetting link
Nov 28 21:24:41 alfred kernel: ata2: SATA link up 3.0 Gbps (SStatus 123=
 SControl 300)
Nov 28 21:24:41 alfred kernel: ata2.00: configured for UDMA/133
Nov 28 21:24:41 alfred kernel: ata2: EH complete
Nov 28 21:24:41 alfred kernel: SCSI device sdb: 2930277168 512-byte hdw=
r sectors (1500302 MB)
Nov 28 21:24:41 alfred kernel: sdb: Write Protect is off
Nov 28 21:24:41 alfred kernel: SCSI device sdb: drive cache: write back
Nov 28 21:24:41 alfred smartd[2770]: Device: /dev/sdd, 1 Offline uncorr=
ectable sectors

the smartd message for sdd appears frequently, that's why I replaced
the drive. the timeout above occured 3 times within the last month for
sdb. guess you are right with either the port or the cable.

tonight it was sda, but I might have disturbed the cable without
noticing when replacing sdd.

MB> If so, then you may have a problem with that specific port. If it
MB> kicks disks randomly, and you're sure that your cables or disks are
MB> healthy, then it's probably time to change the motherboard.

I plan to move to the new atom/pinetrail mainboards as soon as they
are available in january. hope that solves this issue. but will check
the cable anyway.

tnx & cu


MB> Increasing the resync values of min will slow down your server if
MB> you're trying to access it during a resync.

MB> On Wed, Dec 23, 2009 at 6:13 PM, Rainer Fuegenstein
MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>>
>> MB> I don't know why your array takes 3 days to resync. My array is =
7TB in
>> MB> side (8x1TB @ RAID5) and it takes about 16 hours.
>>
>> that's definitely a big mystery. I put this to this list some time a=
go
>> when upgrading the same array from 4*750GB to 4*1500GB by replacing
>> one disk after the other and finally --growing the raid:
>>
>> 1st disk took just a few minutes
>> 2nd disk some hours
>> 3rd disk more than a day
>> 4th disk about 2+ days
>> --grow also took =A02+ days
>>
>> MB> Check the value of this file:
>> MB> cat /proc/sys/dev/raid/speed_limit_max
>>
>> default values are:
>> [root@alfred cdrom]# cat /proc/sys/dev/raid/speed_limit_max
>> 200000
>> [root@alfred cdrom]# cat /proc/sys/dev/raid/speed_limit_min
>> 1000
>>
>> when resyncing (with these default values), the server becomes awful=
y
>> slow (streaming mp3 via smb suffers timeouts).
>>
>> mainboard is an Asus M2N with NFORCE-MCP61 chipset.
>>
>> this server started on an 800MHz asus board with 4*400 GB PATA disks
>> and had this one-disk-failure from the start (every few months). ove=
r the
>> years everything was replaced (power supply, mainboard, disks,
>> controller, pata to sata, ...) but it still kicks out disks (with th=
e
>> current asus M2N board about every two to three weeks).
>>
>> must be cosmic radiation to blame ...
>>
>>
>> MB> Make it a high number so that when there's no process querying t=
he
>> MB> disks, the resync process will go for the max speed.
>> echo '200000' >> /proc/sys/dev/raid/speed_limit_max
>> MB> (200 MB/s)
>>
>> MB> The file /proc/sys/dev/raid/speed_limit_min specified the minimu=
m
>> MB> speed at which the array should resync, even when there are othe=
r
>> MB> programs querying the disks.
>>
>> MB> Make sure you run the above changes just before you issue a resy=
nc.
>> MB> Changes are lost on reboot.
>>
>> MB> On Wed, Dec 23, 2009 at 5:30 PM, Rainer Fuegenstein
>> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>>>> tnx for the info, in the meantime I did:
>>>>
>>>> mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /d=
ev/sdd1
>>>>
>>>> there was no mdadm.conf file, so I had to specify all devices and =
do a
>>>> --force
>>>>
>>>>
>>>> # cat /proc/mdstat
>>>> Personalities : [raid6] [raid5] [raid4]
>>>> md0 : active raid5 sdb1[0] sdc1[3] sdd1[1]
>>>> =A0 =A0 =A04395407808 blocks level 5, 64k chunk, algorithm 2 [4/3]=
 [UU_U]
>>>>
>>>> unused devices: <none>
>>>>
>>>> md0 is up :-)
>>>>
>>>> I'm about to start backing up the most important data; when this i=
s
>>>> done I assume the proper way to get back to normal again is:
>>>>
>>>> - remove the bad drive from the array: mdadm /dev/md0 -r /dev/sda1
>>>> - physically replace sda with a new drive
>>>> - add it back: mdadm /dev/md0 -a /dev/sda1
>>>> - wait three days for the sync to complete (and keep fingers cross=
ed
>>>> that no other drive fails)
>>>>
>>>> big tnx!
>>>>
>>>>
>>>> MB> sda1 was the only affected member of the array so you should b=
e able
>>>> MB> to force-assemble the raid5 array and run it in degraded mode.
>>>>
>>>> MB> mdadm -Af /dev/md0
>>>> MB> If that doesn't work for any reason, do this:
>>>> MB> mdadm -Af /dev/md0 /dev/sdb1 /dev/sdd1 /dev/sdc1
>>>>
>>>> MB> You can note the disk order from the output of mdadm -E
>>>>
>>>> MB> On Wed, Dec 23, 2009 at 5:02 PM, Rainer Fuegenstein
>>>> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>>>>>>
>>>>>> MB> My bad, run this: mdadm -E /dev/sd[a-z]1
>>>>>> should have figured this out myself (sorry; currently running in
>>>>>> panic mode ;-) )
>>>>>>
>>>>>> MB> 1 is the partition which most likely you added to the array =
rather
>>>>>> MB> than the whole disk (which is normal).
>>>>>>
>>>>>> # mdadm -E /dev/sd[a-z]1
>>>>>> /dev/sda1:
>>>>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>>>>> =A0 =A0 =A0 =A0Version : 0.90.00
>>>>>> =A0 =A0 =A0 =A0 =A0 UUID : 81833582:d651e953:48cc5797:38b256ea
>>>>>> =A0Creation Time : Mon Mar 31 13:30:45 2008
>>>>>> =A0 =A0 Raid Level : raid5
>>>>>> =A0Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>>>>> =A0 =A0 Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
>>>>>> =A0 Raid Devices : 4
>>>>>> =A0Total Devices : 4
>>>>>> Preferred Minor : 0
>>>>>>
>>>>>> =A0 =A0Update Time : Wed Dec 23 02:54:49 2009
>>>>>> =A0 =A0 =A0 =A0 =A0State : clean
>>>>>> =A0Active Devices : 4
>>>>>> Working Devices : 4
>>>>>> =A0Failed Devices : 0
>>>>>> =A0Spare Devices : 0
>>>>>> =A0 =A0 =A0 Checksum : 6cfa3a64 - correct
>>>>>> =A0 =A0 =A0 =A0 Events : 119530
>>>>>>
>>>>>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>>>>>> =A0 =A0 Chunk Size : 64K
>>>>>>
>>>>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>>>>> this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A02 =A0=
 =A0 =A0active sync =A0 /dev/sda1
>>>>>>
>>>>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sdb1
>>>>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0active sync =A0 /dev/sdd1
>>>>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A02 =
=A0 =A0 =A0active sync =A0 /dev/sda1
>>>>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A03 =A0=
 =A0 =A0active sync =A0 /dev/sdc1
>>>>>> /dev/sdb1:
>>>>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>>>>> =A0 =A0 =A0 =A0Version : 0.90.00
>>>>>> =A0 =A0 =A0 =A0 =A0 UUID : 81833582:d651e953:48cc5797:38b256ea
>>>>>> =A0Creation Time : Mon Mar 31 13:30:45 2008
>>>>>> =A0 =A0 Raid Level : raid5
>>>>>> =A0Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>>>>> =A0 =A0 Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
>>>>>> =A0 Raid Devices : 4
>>>>>> =A0Total Devices : 4
>>>>>> Preferred Minor : 0
>>>>>>
>>>>>> =A0 =A0Update Time : Wed Dec 23 10:07:42 2009
>>>>>> =A0 =A0 =A0 =A0 =A0State : active
>>>>>> =A0Active Devices : 3
>>>>>> Working Devices : 3
>>>>>> =A0Failed Devices : 1
>>>>>> =A0Spare Devices : 0
>>>>>> =A0 =A0 =A0 Checksum : 6cf8f610 - correct
>>>>>> =A0 =A0 =A0 =A0 Events : 130037
>>>>>>
>>>>>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>>>>>> =A0 =A0 Chunk Size : 64K
>>>>>>
>>>>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>>>>> this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sdb1
>>>>>>
>>>>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sdb1
>>>>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0active sync =A0 /dev/sdd1
>>>>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A02 =
=A0 =A0 =A0faulty removed
>>>>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A03 =A0=
 =A0 =A0active sync =A0 /dev/sdc1
>>>>>> /dev/sdc1:
>>>>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>>>>> =A0 =A0 =A0 =A0Version : 0.90.00
>>>>>> =A0 =A0 =A0 =A0 =A0 UUID : 81833582:d651e953:48cc5797:38b256ea
>>>>>> =A0Creation Time : Mon Mar 31 13:30:45 2008
>>>>>> =A0 =A0 Raid Level : raid5
>>>>>> =A0Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>>>>> =A0 =A0 Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
>>>>>> =A0 Raid Devices : 4
>>>>>> =A0Total Devices : 4
>>>>>> Preferred Minor : 0
>>>>>>
>>>>>> =A0 =A0Update Time : Wed Dec 23 10:07:42 2009
>>>>>> =A0 =A0 =A0 =A0 =A0State : active
>>>>>> =A0Active Devices : 3
>>>>>> Working Devices : 3
>>>>>> =A0Failed Devices : 1
>>>>>> =A0Spare Devices : 0
>>>>>> =A0 =A0 =A0 Checksum : 6cf8f626 - correct
>>>>>> =A0 =A0 =A0 =A0 Events : 130037
>>>>>>
>>>>>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>>>>>> =A0 =A0 Chunk Size : 64K
>>>>>>
>>>>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>>>>> this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A03 =A0=
 =A0 =A0active sync =A0 /dev/sdc1
>>>>>>
>>>>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sdb1
>>>>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0active sync =A0 /dev/sdd1
>>>>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A02 =
=A0 =A0 =A0faulty removed
>>>>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A03 =A0=
 =A0 =A0active sync =A0 /dev/sdc1
>>>>>> /dev/sdd1:
>>>>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>>>>> =A0 =A0 =A0 =A0Version : 0.90.00
>>>>>> =A0 =A0 =A0 =A0 =A0 UUID : 81833582:d651e953:48cc5797:38b256ea
>>>>>> =A0Creation Time : Mon Mar 31 13:30:45 2008
>>>>>> =A0 =A0 Raid Level : raid5
>>>>>> =A0Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>>>>> =A0 =A0 Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
>>>>>> =A0 Raid Devices : 4
>>>>>> =A0Total Devices : 4
>>>>>> Preferred Minor : 0
>>>>>>
>>>>>> =A0 =A0Update Time : Wed Dec 23 10:07:42 2009
>>>>>> =A0 =A0 =A0 =A0 =A0State : active
>>>>>> =A0Active Devices : 3
>>>>>> Working Devices : 3
>>>>>> =A0Failed Devices : 1
>>>>>> =A0Spare Devices : 0
>>>>>> =A0 =A0 =A0 Checksum : 6cf8f632 - correct
>>>>>> =A0 =A0 =A0 =A0 Events : 130037
>>>>>>
>>>>>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>>>>>> =A0 =A0 Chunk Size : 64K
>>>>>>
>>>>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>>>>> this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0active sync =A0 /dev/sdd1
>>>>>>
>>>>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sdb1
>>>>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0active sync =A0 /dev/sdd1
>>>>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A02 =
=A0 =A0 =A0faulty removed
>>>>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A03 =A0=
 =A0 =A0active sync =A0 /dev/sdc1
>>>>>> [root@alfred log]#
>>>>>>
>>>>>> MB> You've included the smart report of one disk only. I suggest=
 you look
>>>>>> MB> at the other disks as well and make sure that they're not re=
porting
>>>>>> MB> any errors. Also, keep in mind that you should run smart tes=
t
>>>>>> MB> periodically (can be configured) and that if you haven't run=
 any test
>>>>>> MB> before, you have to run a long or offline test before making=
 sure that
>>>>>> MB> you don't have bad sectors.
>>>>>>
>>>>>> tnx for the hint, will do that as soon as I got my data back (if=
 ever
>>>>>> ...)
>>>>>>
>>>>>>
>>>>>> MB> On Wed, Dec 23, 2009 at 4:44 PM, Rainer Fuegenstein
>>>>>> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>>>>>>>>
>>>>>>>> MB> Give the output of these:
>>>>>>>> MB> mdadm -E /dev/sd[a-z]
>>>>>>>>
>>>>>>>> ]# mdadm -E /dev/sd[a-z]
>>>>>>>> mdadm: No md superblock detected on /dev/sda.
>>>>>>>> mdadm: No md superblock detected on /dev/sdb.
>>>>>>>> mdadm: No md superblock detected on /dev/sdc.
>>>>>>>> mdadm: No md superblock detected on /dev/sdd.
>>>>>>>>
>>>>>>>> I assume that's not a good sign ?!
>>>>>>>>
>>>>>>>> sda was powered on and running after the reboot, a smartctl sh=
ort test
>>>>>>>> revealed no errors and smartctl -a also looks unsuspicious (se=
e
>>>>>>>> below). the drives are rather new.
>>>>>>>>
>>>>>>>> guess its more likely to be either a problem of the power supp=
ly
>>>>>>>> (400W) or communication between controller and disk.
>>>>>>>>
>>>>>>>> /dev/sdd (before it was replaced) reported the following:
>>>>>>>>
>>>>>>>> Dec 20 07:18:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offli=
ne uncorrectable sectors
>>>>>>>> Dec 20 07:48:53 alfred smartd[2705]: Device: /dev/sdd, 1 Offli=
ne uncorrectable sectors
>>>>>>>> Dec 20 08:18:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offli=
ne uncorrectable sectors
>>>>>>>> Dec 20 08:48:55 alfred smartd[2705]: Device: /dev/sdd, 1 Offli=
ne uncorrectable sectors
>>>>>>>> Dec 20 09:18:53 alfred smartd[2705]: Device: /dev/sdd, 1 Offli=
ne uncorrectable sectors
>>>>>>>> Dec 20 09:48:58 alfred smartd[2705]: Device: /dev/sdd, 1 Offli=
ne uncorrectable sectors
>>>>>>>> Dec 20 10:19:01 alfred smartd[2705]: Device: /dev/sdd, 1 Offli=
ne uncorrectable sectors
>>>>>>>> Dec 20 10:48:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offli=
ne uncorrectable sectors
>>>>>>>>
>>>>>>>> (what triggered a re-sync of the array)
>>>>>>>>
>>>>>>>>
>>>>>>>> # smartctl -a /dev/sda
>>>>>>>> smartctl version 5.38 [i686-redhat-linux-gnu] Copyright (C) 20=
02-8 Bruce Allen
>>>>>>>> Home page is http://smartmontools.sourceforge.net/
>>>>>>>>
>>>>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>>>>>>>> Device Model: =A0 =A0 WDC WD15EADS-00R6B0
>>>>>>>> Serial Number: =A0 =A0WD-WCAUP0017818
>>>>>>>> Firmware Version: 01.00A01
>>>>>>>> User Capacity: =A0 =A01,500,301,910,016 bytes
>>>>>>>> Device is: =A0 =A0 =A0 =A0Not in smartctl database [for detail=
s use: -P showall]
>>>>>>>> ATA Version is: =A0 8
>>>>>>>> ATA Standard is: =A0Exact ATA specification draft version not =
indicated
>>>>>>>> Local Time is: =A0 =A0Wed Dec 23 14:40:46 2009 CET
>>>>>>>> SMART support is: Available - device has SMART capability.
>>>>>>>> SMART support is: Enabled
>>>>>>>>
>>>>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
>>>>>>>> SMART overall-health self-assessment test result: PASSED
>>>>>>>>
>>>>>>>> General SMART Values:
>>>>>>>> Offline data collection status: =A0(0x82) Offline data collect=
ion activity
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0was completed without error.
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0Auto Offline Data Collection: Enabled.
>>>>>>>> Self-test execution status: =A0 =A0 =A0( =A0 0) The previous s=
elf-test routine completed
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0without error or no self-test has ever
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0been run.
>>>>>>>> Total time to complete Offline
>>>>>>>> data collection: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (40800) secon=
ds.
>>>>>>>> Offline data collection
>>>>>>>> capabilities: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(0x7b) SM=
ART execute Offline immediate.
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0Auto Offline data collection on/off support.
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0Suspend Offline collection upon new
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0command.
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0Offline surface scan supported.
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0Self-test supported.
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0Conveyance Self-test supported.
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0Selective Self-test supported.
>>>>>>>> SMART capabilities: =A0 =A0 =A0 =A0 =A0 =A0(0x0003) Saves SMAR=
T data before entering
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0power-saving mode.
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0Supports SMART auto save timer.
>>>>>>>> Error logging capability: =A0 =A0 =A0 =A0(0x01) Error logging =
supported.
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0General Purpose Logging supported.
>>>>>>>> Short self-test routine
>>>>>>>> recommended polling time: =A0 =A0 =A0 =A0( =A0 2) minutes.
>>>>>>>> Extended self-test routine
>>>>>>>> recommended polling time: =A0 =A0 =A0 =A0( 255) minutes.
>>>>>>>> Conveyance self-test routine
>>>>>>>> recommended polling time: =A0 =A0 =A0 =A0( =A0 5) minutes.
>>>>>>>> SCT capabilities: =A0 =A0 =A0 =A0 =A0 =A0 =A0(0x303f) SCT Stat=
us supported.
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0SCT Feature Control supported.
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0SCT Data Table supported.
>>>>>>>>
>>>>>>>> SMART Attributes Data Structure revision number: 16
>>>>>>>> Vendor Specific SMART Attributes with Thresholds:
>>>>>>>> ID# ATTRIBUTE_NAME =A0 =A0 =A0 =A0 =A0FLAG =A0 =A0 VALUE WORST=
 THRESH TYPE =A0 =A0 =A0UPDATED =A0WHEN_FAILED RAW_VALUE
>>>>>>>> =A01 Raw_Read_Error_Rate =A0 =A0 0x002f =A0 200 =A0 200 =A0 05=
1 =A0 =A0Pre-fail =A0Always =A0 =A0 =A0 - =A0 =A0 =A0 0
>>>>>>>> =A03 Spin_Up_Time =A0 =A0 =A0 =A0 =A0 =A00x0027 =A0 177 =A0 14=
5 =A0 021 =A0 =A0Pre-fail =A0Always =A0 =A0 =A0 - =A0 =A0 =A0 8133
>>>>>>>> =A04 Start_Stop_Count =A0 =A0 =A0 =A00x0032 =A0 100 =A0 100 =A0=
 000 =A0 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 15
>>>>>>>> =A05 Reallocated_Sector_Ct =A0 0x0033 =A0 200 =A0 200 =A0 140 =
=A0 =A0Pre-fail =A0Always =A0 =A0 =A0 - =A0 =A0 =A0 0
>>>>>>>> =A07 Seek_Error_Rate =A0 =A0 =A0 =A0 0x002e =A0 200 =A0 200 =A0=
 000 =A0 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
>>>>>>>> =A09 Power_On_Hours =A0 =A0 =A0 =A0 =A00x0032 =A0 093 =A0 093 =
=A0 000 =A0 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 5272
>>>>>>>> =A010 Spin_Retry_Count =A0 =A0 =A0 =A00x0032 =A0 100 =A0 253 =A0=
 000 =A0 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
>>>>>>>> =A011 Calibration_Retry_Count 0x0032 =A0 100 =A0 253 =A0 000 =A0=
 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
>>>>>>>> =A012 Power_Cycle_Count =A0 =A0 =A0 0x0032 =A0 100 =A0 100 =A0=
 000 =A0 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 14
>>>>>>>> 192 Power-Off_Retract_Count 0x0032 =A0 200 =A0 200 =A0 000 =A0=
 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 2
>>>>>>>> 193 Load_Cycle_Count =A0 =A0 =A0 =A00x0032 =A0 200 =A0 200 =A0=
 000 =A0 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 13
>>>>>>>> 194 Temperature_Celsius =A0 =A0 0x0022 =A0 125 =A0 109 =A0 000=
 =A0 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 27
>>>>>>>> 196 Reallocated_Event_Count 0x0032 =A0 200 =A0 200 =A0 000 =A0=
 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
>>>>>>>> 197 Current_Pending_Sector =A00x0032 =A0 200 =A0 200 =A0 000 =A0=
 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
>>>>>>>> 198 Offline_Uncorrectable =A0 0x0030 =A0 200 =A0 200 =A0 000 =A0=
 =A0Old_age =A0 Offline =A0 =A0 =A0- =A0 =A0 =A0 0
>>>>>>>> 199 UDMA_CRC_Error_Count =A0 =A00x0032 =A0 200 =A0 200 =A0 000=
 =A0 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
>>>>>>>> 200 Multi_Zone_Error_Rate =A0 0x0008 =A0 200 =A0 200 =A0 000 =A0=
 =A0Old_age =A0 Offline =A0 =A0 =A0- =A0 =A0 =A0 0
>>>>>>>>
>>>>>>>> SMART Error Log Version: 1
>>>>>>>> No Errors Logged
>>>>>>>>
>>>>>>>> SMART Self-test log structure revision number 1
>>>>>>>> Num =A0Test_Description =A0 =A0Status =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0Remaining =A0LifeTime(hours) =A0LBA_of_first_error
>>>>>>>> # 1 =A0Short offline =A0 =A0 =A0 Completed without error =A0 =A0=
 =A0 00% =A0 =A0 =A05272 =A0 =A0 =A0 =A0 -
>>>>>>>>
>>>>>>>> SMART Selective self-test log data structure revision number 1
>>>>>>>> =A0SPAN =A0MIN_LBA =A0MAX_LBA =A0CURRENT_TEST_STATUS
>>>>>>>> =A0 =A01 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
>>>>>>>> =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
>>>>>>>> =A0 =A03 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
>>>>>>>> =A0 =A04 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
>>>>>>>> =A0 =A05 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
>>>>>>>> Selective self-test flags (0x0):
>>>>>>>> =A0After scanning selected spans, do NOT read-scan remainder o=
f disk.
>>>>>>>> If Selective self-test is pending on power-up, resume after 0 =
minute delay.
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>>>From the errors you show, it seems like one of the disks is d=
ead (sda)
>>>>>>>> MB> or dying. It could be just a bad PCB (the controller board=
 of the
>>>>>>>> MB> disk) as it refuses to return SMART data, so you might be =
able to
>>>>>>>> MB> rescue data by changing the PCB, if it's that important to=
 have that
>>>>>>>> MB> disk.
>>>>>>>>
>>>>>>>> MB> As for the array, you can run a degraded array by force as=
sembling it:
>>>>>>>> MB> mdadm -Af /dev/md0
>>>>>>>> MB> In the command above, mdadm will search on existing disks =
and
>>>>>>>> MB> partitions, which of them belongs to an array and assemble=
 that array,
>>>>>>>> MB> if possible.
>>>>>>>>
>>>>>>>> MB> I also suggest you install smartmontools package and run s=
martctl -a
>>>>>>>> MB> /dev/sd[a-z] and see the report for each disk to make sure=
 you don't
>>>>>>>> MB> have bad sectors or bad cables (CRC/ATA read errors) on an=
y of the
>>>>>>>> MB> disks.
>>>>>>>>
>>>>>>>> MB> On Wed, Dec 23, 2009 at 3:50 PM, Rainer Fuegenstein
>>>>>>>> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>>>>>>>>>> addendum: when going through the logs I found the reason:
>>>>>>>>>>
>>>>>>>>>> Dec 23 02:55:40 alfred kernel: ata1.00: exception Emask 0x0 =
SAct 0x0 SErr 0x0 action 0x6 frozen
>>>>>>>>>> Dec 23 02:55:40 alfred kernel: ata1.00: cmd ea/00:00:00:00:0=
0/00:00:00:00:00/a0 tag 0
>>>>>>>>>> Dec 23 02:55:40 alfred kernel: =A0 =A0 =A0 =A0 =A0res 40/00:=
00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>>>>>>>>> Dec 23 02:55:40 alfred kernel: ata1.00: status: { DRDY }
>>>>>>>>>> Dec 23 02:55:45 alfred kernel: ata1: link is slow to respond=
, please be patient (ready=3D0)
>>>>>>>>>> Dec 23 02:55:50 alfred kernel: ata1: device not ready (errno=
=3D-16), forcing hardreset
>>>>>>>>>> Dec 23 02:55:50 alfred kernel: ata1: soft resetting link
>>>>>>>>>> Dec 23 02:55:55 alfred kernel: ata1: link is slow to respond=
, please be patient (ready=3D0)
>>>>>>>>>> Dec 23 02:56:00 alfred kernel: ata1: SRST failed (errno=3D-1=
6)
>>>>>>>>>> Dec 23 02:56:00 alfred kernel: ata1: soft resetting link
>>>>>>>>>> Dec 23 02:56:05 alfred kernel: ata1: link is slow to respond=
, please be patient (ready=3D0)
>>>>>>>>>> Dec 23 02:56:10 alfred kernel: ata1: SRST failed (errno=3D-1=
6)
>>>>>>>>>> Dec 23 02:56:10 alfred kernel: ata1: soft resetting link
>>>>>>>>>> Dec 23 02:56:15 alfred kernel: ata1: link is slow to respond=
, please be patient (ready=3D0)
>>>>>>>>>> Dec 23 02:56:45 alfred kernel: ata1: SRST failed (errno=3D-1=
6)
>>>>>>>>>> Dec 23 02:56:45 alfred kernel: ata1: limiting SATA link spee=
d to 1.5 Gbps
>>>>>>>>>> Dec 23 02:56:45 alfred kernel: ata1: soft resetting link
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: ata1: SRST failed (errno=3D-1=
6)
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: ata1: reset failed, giving up
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: ata1.00: disabled
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: timing out comman=
d, waited 30s
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: ata1: EH complete
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: retur=
n code =3D 0x00040000
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev s=
da, sector 1244700223
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: retur=
n code =3D 0x00040000
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev s=
da, sector 1554309191
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: retur=
n code =3D 0x00040000
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev s=
da, sector 1554309439
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: retur=
n code =3D 0x00040000
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev s=
da, sector 572721343
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: raid5: Disk failure on sda1, =
disabling device. Operation continuing on 3 devices
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: =A0--- rd:4 wd:3 fd:1
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: =A0disk 0, o:1, dev:sdb1
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: =A0disk 1, o:1, dev:sdd1
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: =A0disk 2, o:0, dev:sda1
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: =A0disk 3, o:1, dev:sdc1
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: =A0--- rd:4 wd:3 fd:1
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: =A0disk 0, o:1, dev:sdb1
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: =A0disk 1, o:1, dev:sdd1
>>>>>>>>>> Dec 23 02:56:50 alfred kernel: =A0disk 3, o:1, dev:sdc1
>>>>>>>>>> Dec 23 03:22:57 alfred smartd[2692]: Device: /dev/sda, not c=
apable of SMART self-check
>>>>>>>>>> Dec 23 03:22:57 alfred smartd[2692]: Sending warning via mai=
l to root ...
>>>>>>>>>> Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to roo=
t: successful
>>>>>>>>>> Dec 23 03:22:58 alfred smartd[2692]: Device: /dev/sda, faile=
d to read SMART Attribute Data
>>>>>>>>>> Dec 23 03:22:58 alfred smartd[2692]: Sending warning via mai=
l to root ...
>>>>>>>>>> Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to roo=
t: successful
>>>>>>>>>> Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, not c=
apable of SMART self-check
>>>>>>>>>> Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, faile=
d to read SMART Attribute Data
>>>>>>>>>> Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, not c=
apable of SMART self-check
>>>>>>>>>> Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, faile=
d to read SMART Attribute Data
>>>>>>>>>> Dec 23 04:52:57 alfred smartd[2692]: Device: /dev/sda, not c=
apable of SMART self-check
>>>>>>>>>> =A0[...]
>>>>>>>>>> Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, not c=
apable of SMART self-check
>>>>>>>>>> Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, faile=
d to read SMART Attribute Data
>>>>>>>>>> =A0(crash here)
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> RF> hi,
>>>>>>>>>>
>>>>>>>>>> RF> got a "nice" early christmas present this morning: after=
 a crash, the raid5
>>>>>>>>>> RF> (consisting of 4*1.5TB WD caviar green SATA disks) won't=
 start :-(
>>>>>>>>>>
>>>>>>>>>> RF> the history:
>>>>>>>>>> RF> sometimes, the raid kicked out one disk, started a resyn=
c (which
>>>>>>>>>> RF> lasted for about 3 days) and was fine after that. a few =
days ago I
>>>>>>>>>> RF> replaced drive sdd (which seemed to cause the troubles) =
and synced the
>>>>>>>>>> RF> raid again which finished yesterday in the early afterno=
on. at 10am
>>>>>>>>>> RF> today the system crashed and the raid won't start:
>>>>>>>>>>
>>>>>>>>>> RF> OS is Centos 5
>>>>>>>>>> RF> mdadm - v2.6.9 - 10th March 2009
>>>>>>>>>> RF> Linux alfred 2.6.18-164.6.1.el5xen #1 SMP Tue Nov 3 17:5=
3:47 EST 2009 i686 athlon i386 GNU/Linux
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: Autodetecting RAID ar=
rays.
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: autorun ...
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: considering sdd1 ...
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: =A0adding sdd1 ...
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: =A0adding sdc1 ...
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: =A0adding sdb1 ...
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: =A0adding sda1 ...
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: created md0
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sda1>
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdb1>
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdc1>
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdd1>
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: running: <sdd1><sdc1>=
<sdb1><sda1>
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: kicking non-fresh sda=
1 from array!
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sda1>
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sda1)
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: md0: raid array is no=
t clean -- starting background reconstruction
>>>>>>>>>> RF> =A0 =A0 (no reconstruction is actually started, disks ar=
e idle)
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: automatically usin=
g best checksumming function: pIII_sse
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: =A0 =A0pIII_sse =A0: =A07=
085.000 MB/sec
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: using function: pI=
II_sse (7085.000 MB/sec)
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x1 =A0 =A0896=
 MB/s
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x2 =A0 =A0972=
 MB/s
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x4 =A0 =A0893=
 MB/s
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x8 =A0 =A0934=
 MB/s
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx1 =A0 =A0 1845=
 MB/s
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx2 =A0 =A0 3250=
 MB/s
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x1 =A0 =A01799=
 MB/s
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x2 =A0 =A03067=
 MB/s
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x1 =A0 =A02980=
 MB/s
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x2 =A0 =A04015=
 MB/s
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid6: using algorithm ss=
e2x2 (4015 MB/s)
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: raid6 personality reg=
istered for level 6
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: raid5 personality reg=
istered for level 5
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: raid4 personality reg=
istered for level 4
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdd1 operat=
ional as raid disk 1
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdc1 operat=
ional as raid disk 3
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdb1 operat=
ional as raid disk 0
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: cannot start dirty=
 degraded array for md0
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: RAID5 conf printout:
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: =A0--- rd:4 wd:3 fd:1
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: =A0disk 0, o:1, dev:sdb1
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: =A0disk 1, o:1, dev:sdd1
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: =A0disk 3, o:1, dev:sdc1
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: raid5: failed to run raid=
 set md0
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: pers->run() failed ..=
=2E
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: do_md_run() returned =
-5
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: md0 stopped.
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdd1>
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdd1)
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdc1>
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdc1)
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdb1>
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdb1)
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: ... autorun DONE.
>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: device-mapper: multipath:=
 version 1.0.5 loaded
>>>>>>>>>>
>>>>>>>>>> RF> # cat /proc/mdstat
>>>>>>>>>> RF> Personalities : [raid6] [raid5] [raid4]
>>>>>>>>>> RF> unused devices: <none>
>>>>>>>>>>
>>>>>>>>>> RF> filesystem used on top of md0 is xfs.
>>>>>>>>>>
>>>>>>>>>> RF> please advice what to do next and let me know if you nee=
d further
>>>>>>>>>> RF> information. really don't want to lose 3TB worth of data=
 :-(
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> RF> tnx in advance.
>>>>>>>>>>
>>>>>>>>>> RF> --
>>>>>>>>>> RF> To unsubscribe from this list: send the line "unsubscrib=
e linux-raid" in
>>>>>>>>>> RF> the body of a message to majordomo@vger.kernel.org
>>>>>>>>>> RF> More majordomo info at =A0http://vger.kernel.org/majordo=
mo-info.html
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> ------------------------------------------------------------=
------------------
>>>>>>>>>> Unix gives you just enough rope to hang yourself -- and then=
 a couple of more
>>>>>>>>>> feet, just to be sure.
>>>>>>>>>> (Eric Allman)
>>>>>>>>>> ------------------------------------------------------------=
------------------
>>>>>>>>>>
>>>>>>>>>> --
>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe li=
nux-raid" in
>>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-i=
nfo.html
>>>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> --------------------------------------------------------------=
----------------
>>>>>>>> Unix gives you just enough rope to hang yourself -- and then a=
 couple of more
>>>>>>>> feet, just to be sure.
>>>>>>>> (Eric Allman)
>>>>>>>> --------------------------------------------------------------=
----------------
>>>>>>>>
>>>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> ----------------------------------------------------------------=
--------------
>>>>>> Unix gives you just enough rope to hang yourself -- and then a c=
ouple of more
>>>>>> feet, just to be sure.
>>>>>> (Eric Allman)
>>>>>> ----------------------------------------------------------------=
--------------
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-=
raid" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.=
html
>>>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> ------------------------------------------------------------------=
------------
>>>> Unix gives you just enough rope to hang yourself -- and then a cou=
ple of more
>>>> feet, just to be sure.
>>>> (Eric Allman)
>>>> ------------------------------------------------------------------=
------------
>>>>
>>>>
>>
>>
>>
>>
>>
>> --------------------------------------------------------------------=
----------
>> Unix gives you just enough rope to hang yourself -- and then a coupl=
e of more
>> feet, just to be sure.
>> (Eric Allman)
>> --------------------------------------------------------------------=
----------
>>
>>





-----------------------------------------------------------------------=
-------
Unix gives you just enough rope to hang yourself -- and then a couple o=
f more=20
feet, just to be sure.
(Eric Allman)
-----------------------------------------------------------------------=
-------

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
