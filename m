From: hgichon <kpkim@gluesys.com>
Subject: Re: rescue an alien md raid5
Date: Tue, 24 Feb 2009 09:56:28 +0900
Message-ID: <49A345BC.1010206@gluesys.com>
References: <200902231013.46082.harry.mangalam@uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200902231013.46082.harry.mangalam@uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Harry Mangalam <harry.mangalam@uci.edu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I read USRobotics 8700 feature.

# Supports linear storage use (all drives as one logical drive) or use 
multiple drives as primary and back-up storage
# Dynamic logical drive sizing - Add an additional drive, when needed, and 
it will be integrated into the logical drive with no effect on data

maybe... there is no lvm layer?
try vgscan / vgchange -ay

best regards.

-kpkim

Harry Mangalam wrote:
> Here's an unusual (long) tale of woe.
>
> We had a USRobotics 8700 NAS appliance with 4 SATA disks in RAID5:
>  <http://www.usr.com/support/product-template.asp?prod=8700>
> which was a fine (if crude) ARM-based Linux NAS until it stroked out 
> at some point, leaving us with a degraded RAID5 and comatose NAS 
> device.
>
> We'd like to get the files back of course and I've moved the disks to 
> a Linux PC, hooked them up to a cheap Silicon Image 4x SATA 
> controller and brought up the whole frankenmess with mdadm.  It 
> reported a clean but degraded array:
>
> ===============================================================
>
> root@pnh-rcs:/# mdadm --detail /dev/md0
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Wed Feb 14 16:30:17 2007
>      Raid Level : raid5
>      Array Size : 1464370176 (1396.53 GiB 1499.52 GB)
>   Used Dev Size : 488123392 (465.51 GiB 499.84 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>
>     Update Time : Fri Dec 12 20:26:27 2008
>           State : clean, degraded
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>            UUID : 7a60cd58:ad85ebdc:3b55d79a:a33c7fe6
>          Events : 0.264294
>
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       8       35        1      active sync   /dev/sdc3
>        2       8       51        2      active sync   /dev/sdd3
>        3       8       67        3      active sync   /dev/sde3
> ===============================================================
>
>
> The original 500G Maxtor disks were formatted in 3 partitions as 
> follows:
>
> (for /dev/sd[bcde])
> disk sdb was bad so I had to replace it.
>
> ===============================================================
> Disk /dev/sdc: 500.1 GB, 500107862016 bytes
> 16 heads, 63 sectors/track, 969021 cylinders
> Units = cylinders of 1008 * 512 = 516096 bytes
> Disk identifier: 0x00000000
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1         261      131543+  83  Linux
> /dev/sdc2             262         522      131544   82  Linux swap / 
> Solaris
> /dev/sdc3             523      969022   488123496+  89  Unknown
> ===============================================================
>
>
> I formatted the replacement (different make/layout - Seagate) as a 
> single partition:
> /dev/sdb1:
> ===============================================================
> Disk /dev/sdb: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x21d01216
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1       60801   488384001   83  Linux
> ===============================================================
>
> and tried to rebuild the raid by stopping the raid, removing the bad 
> disk, adding the new disk.  It came up and reported that it was 
> rebuilding.  After several hours, it rebuilt and reported itself 
> clean (altho during a reboot, it became /dev/md1 instead of md0)
>
> ===============================================================
> $ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
> [raid4] [raid10]
> md1 : active raid5 sdb1[0] sde3[3] sdd3[2] sdc3[1]
>       1464370176 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
> ===============================================================
>
>
> ===============================================================
> $ mdadm --detail /dev/md1
> /dev/md1:
>         Version : 00.90.03
>   Creation Time : Wed Feb 14 16:30:17 2007
>      Raid Level : raid5
>      Array Size : 1464370176 (1396.53 GiB 1499.52 GB)
>   Used Dev Size : 488123392 (465.51 GiB 499.84 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 1
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Feb 23 09:06:27 2009
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>            UUID : 7a60cd58:ad85ebdc:3b55d79a:a33c7fe6
>          Events : 0.265494
>
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>        1       8       35        1      active sync   /dev/sdc3
>        2       8       51        2      active sync   /dev/sdd3
>        3       8       67        3      active sync   /dev/sde3
> ===============================================================
>
>
> The docs and files on the USR web site imply that the native 
> filesystem was originally XFS, but when i try to mount it as such, I 
> can't:
>
> mount -vvv -t xfs /dev/md1 /mnt
> mount: fstab path: "/etc/fstab"
> mount: lock path:  "/etc/mtab~"
> mount: temp path:  "/etc/mtab.tmp"
> mount: no LABEL=, no UUID=, going to mount /dev/md1 by path
> mount: spec:  "/dev/md1"
> mount: node:  "/mnt"
> mount: types: "xfs"
> mount: opts:  "(null)"
> mount: mount(2) syscall: source: "/dev/md1", target: "/mnt", 
> filesystemtype: "xfs", mountflags: -1058209792, data: (null)
> mount: wrong fs type, bad option, bad superblock on /dev/md1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>
> and when I check dmesg:
> [  245.008000] SGI XFS with ACLs, security attributes, realtime, large 
> block numbers, no debug enabled
> [  245.020000] SGI XFS Quota Management subsystem
> [  245.020000] XFS: SB read failed
> [  327.696000] md: md0 stopped.
> [  327.696000] md: unbind<sdc1>
> [  327.696000] md: export_rdev(sdc1)
> [  327.696000] md: unbind<sde1>
> [  327.696000] md: export_rdev(sde1)
> [  327.696000] md: unbind<sdd1>
> [  327.696000] md: export_rdev(sdd1)
> [  439.660000] XFS: bad magic number
> [  439.660000] XFS: SB validate failed
>
> repeated attempts repeat the last 2 lines above.  This implies that 
> the superblock is bad and xfs_repair also reports that:
> xfs_repair /dev/md1
>         - creating 2 worker thread(s)
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!
>
> attempting to find secondary superblock...
> ...... <lots of ...>  ... 
> ..found candidate secondary superblock...
> unable to verify superblock, continuing...
> <lots of ...>  ... 
> ...found candidate secondary superblock...
> unable to verify superblock, continuing...
> <lots of ...>  ... 
>
>
> So my question is what should I do now?  Were those 1st 2 partitions 
> (that I didn't create on the replacement disk) important?  Should I 
> try to remove the replaced disk, create 3 partitions,  and try again, 
> or am I just well and truly hosed?
>
>   

