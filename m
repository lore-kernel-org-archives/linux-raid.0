From: "Philippe PIOLAT" <piolat@getalinks.fr>
Subject: fd partitions gone from 2 discs, md happy with it and reconstructs... bye bye datas
Date: Tue, 4 Jan 2011 10:11:10 +0100
Message-ID: <00ce01cbabef$54037fc0$fc0a7f40$@getalinks.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: fr
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey gurus, need some help badly with this one.
I run a server with a 6Tb md raid5 volume built over 7*1Tb disks.
I've had to shut down the server lately and when it went back up, 2 out of
the 7 disks used for the raid volume had lost its conf :

dmesg :
[   10.184167]  sda: sda1 sda2 sda3 // System disk
[   10.202072]  sdb: sdb1
[   10.210073]  sdc: sdc1
[   10.222073]  sdd: sdd1
[   10.229330]  sde: sde1
[   10.239449]  sdf: sdf1
[   11.099896]  sdg: unknown partition table
[   11.255641]  sdh: unknown partition table

All 7 disks have same geometry and were configured alike :

dmesg :
Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x1e7481a5

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1      121601   976760001   fd  Linux raid
autodetect

All 7 disks (sdb1, sdc1, sdd1, sde1, sdf1, sdg1, sdh1) were used in a md
raid5 xfs volume.
When booting, md, which was (obviously) out of sync kicked in and
automatically started rebuilding over the 7 disks, including the two
"faulty" ones; xfs tried to do some shenanigans as well:

dmesg :
 [   19.566941] md: md0 stopped.
[   19.817038] md: bind<sdc1>
[   19.817339] md: bind<sdd1>
[   19.817465] md: bind<sde1>
[   19.817739] md: bind<sdf1>
[   19.817917] md: bind<sdh>
[   19.818079] md: bind<sdg>
[   19.818198] md: bind<sdb1>
[   19.818248] md: md0: raid array is not clean -- starting background
reconstruction
[   19.825259] raid5: device sdb1 operational as raid disk 0
[   19.825261] raid5: device sdg operational as raid disk 6
[   19.825262] raid5: device sdh operational as raid disk 5
[   19.825264] raid5: device sdf1 operational as raid disk 4
[   19.825265] raid5: device sde1 operational as raid disk 3
[   19.825267] raid5: device sdd1 operational as raid disk 2
[   19.825268] raid5: device sdc1 operational as raid disk 1
[   19.825665] raid5: allocated 7334kB for md0
[   19.825667] raid5: raid level 5 set md0 active with 7 out of 7 devices,
algorithm 2
[   19.825669] RAID5 conf printout:
[   19.825670]  --- rd:7 wd:7
[   19.825671]  disk 0, o:1, dev:sdb1
[   19.825672]  disk 1, o:1, dev:sdc1
[   19.825673]  disk 2, o:1, dev:sdd1
[   19.825675]  disk 3, o:1, dev:sde1
[   19.825676]  disk 4, o:1, dev:sdf1
[   19.825677]  disk 5, o:1, dev:sdh
[   19.825679]  disk 6, o:1, dev:sdg
[   19.899787] PM: Starting manual resume from disk
[   28.663228] Filesystem "md0": Disabling barriers, not supported by the
underlying device
[   28.663228] XFS mounting filesystem md0
[   28.884433] md: resync of RAID array md0
[   28.884433] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[   28.884433] md: using maximum available idle IO bandwidth (but not more
than 200000 KB/sec) for resync.
[   28.884433] md: using 128k window, over a total of 976759936 blocks.
[   29.025980] Starting XFS recovery on filesystem: md0 (logdev: internal)
[   32.680486] XFS: xlog_recover_process_data: bad clientid
[   32.680495] XFS: log mount/recovery failed: error 5
[   32.682773] XFS: log mount failed

I ran fdisk and flagged sdg1 and sdh1 as fd.
I tried to reassemble the array but it didnt work: no matter what was in
mdadm.conf, it still uses sdg and sdh instead of sdg1 and sdh1.
I checked in /dev and I see no sdg1 and and sdh1, shich explains why it wont
use it.
I just don't know why those partitions are gone from /dev and how to readd
those...

blkid :
/dev/sda1: LABEL="boot" UUID="519790ae-32fe-4c15-a7f6-f1bea8139409"
TYPE="ext2" 
/dev/sda2: TYPE="swap" 
/dev/sda3: LABEL="root" UUID="91390d23-ed31-4af0-917e-e599457f6155"
TYPE="ext3" 
/dev/sdb1: UUID="2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE="mdraid" 
/dev/sdc1: UUID="2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE="mdraid" 
/dev/sdd1: UUID="2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE="mdraid" 
/dev/sde1: UUID="2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE="mdraid" 
/dev/sdf1: UUID="2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE="mdraid" 
/dev/sdg: UUID="2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE="mdraid" 
/dev/sdh: UUID="2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE="mdraid" 

fdisk -l :
Disk /dev/sda: 40.0 GB, 40020664320 bytes
255 heads, 63 sectors/track, 4865 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x8c878c87

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          12       96358+  83  Linux
/dev/sda2              13         134      979965   82  Linux swap / Solaris
/dev/sda3             135        4865    38001757+  83  Linux

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x1e7481a5

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1      121601   976760001   fd  Linux raid
autodetect

Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xc9bdc1e9

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      121601   976760001   fd  Linux raid
autodetect

Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xcc356c30

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1      121601   976760001   fd  Linux raid
autodetect

Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xe87f7a3d

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1      121601   976760001   fd  Linux raid
autodetect

Disk /dev/sdf: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xb17a2d22

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1      121601   976760001   fd  Linux raid
autodetect

Disk /dev/sdg: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x8f3bce61

   Device Boot      Start         End      Blocks   Id  System
/dev/sdg1               1      121601   976760001   fd  Linux raid
autodetect

Disk /dev/sdh: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xa98062ce

   Device Boot      Start         End      Blocks   Id  System
/dev/sdh1               1      121601   976760001   fd  Linux raid
autodetect

I really dont know what happened nor how to recover from this mess.
Needless to say the 5TB or so worth of data sitting on those disks are very
valuable to me...

Any idea any one?
Did anybody ever experienced a similar situation or know how to recover from
it ?

Can someone help me? I'm really desperate... :x

