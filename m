From: Jens Arnfelt <jens.arnfelt@ab-innovation.dk>
Subject: System halt when re-inserting a HotSwap SCSI in Soft RAID1
Date: Fri, 20 Sep 2002 14:33:13 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D8B1589.70502@ab-innovation.dk>
References: <Pine.LNX.4.44.0209162301200.24650-100000@ddx.a2000.nu>	<001d01c25ef9$6bc25240$900d0d93@M02WS17219>	<15752.23100.95651.59572@notabene.cse.unsw.edu.au>	<00f001c2600c$3dd29480$6a01a8c0@bmoon> <15754.29612.582936.661082@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi There!

I have two scsi disk with idendical partitiontables (see below) 
installed on a SCA HotSwap enable Fujitsu-Siemens server.

As a test I've removed one of the disks and the /dev/md0 went in 
degraded mode as expected. (se snip from /var/log/messages below)

... but what about /dev/md1 which also have a partition on /dev/sdb 
which I've removed?????
Nothing. And when I check "/proc/mdstat" the /dev/md1 seames to be 
running without error.... strange.

Note:
---------
Later investigation have show, that /dev/md1 would go into degraded mode 
if I've coppyed some data to it. (See fstab below).
Problem is that I have intended /dev/md1 as a partition for swap.
This is nesseray to really have a High Avalible (HA) system.
---------

The real problems start when I re-insert the /dev/sda.
The systems stops all activity on HD after some errore in the 
/var/log/messages and a hard reset is only option.

The system can however boot up. A look at /proc/mdstat shows that the 
/dev/md0 (still) and /dev/md1 is now correctly set as working in 
degraded mode.
If I now run "raidhotadd /dev/md0 /dev/sdb1" and "raidhotadd /dev/md0 
/dev/sdb1" evething rebuilts nicesly.

Later experiments have shown that I have to power off the system, insert 
the disk and boot.
This is however not the intended use of a HotSwap system.


BTW
SCSI card: 53c1010 Ultra3 SCSI Adapter from Symbios
uname -a => "Linux ABI1 2.4.18-4GB #1 Wed Sep 18 16:33:24 CEST 2002 i686 
SuSE 8.0 Raid" with RAID1, jbd and ext3 compiled into the kernel.
RAID: raidtools-0.90-349




--------------- snip /var/log/messages -------
Sep 19 14:25:57 ABI1 kernel: SCSI disk error : host 0 channel 0 id 1 lun 
0 return code = 100ff
Sep 19 14:25:57 ABI1 kernel: I/O error: dev 08:11, sector 37992
Sep 19 14:25:57 ABI1 kernel: raid1: Disk failure on sdb1, disabling device.
Sep 19 14:25:57 ABI1 kernel: Operation continuing on 1 devices
Sep 19 14:25:57 ABI1 kernel: md: recovery thread got woken up ...
Sep 19 14:25:57 ABI1 kernel: md: updating md0 RAID superblock on device
Sep 19 14:25:57 ABI1 kernel: md: (skipping faulty sdb1 )
Sep 19 14:25:57 ABI1 kernel: md: sda1 [events: 00000036]<6>(write) 
sda1's sb offset: 6816640
Sep 19 14:25:57 ABI1 kernel: SCSI disk error : host 0 channel 0 id 1 lun 
0 return code = 100ff
Sep 19 14:25:57 ABI1 kernel: I/O error: dev 08:11, sector 38000
Sep 19 14:25:58 ABI1 kernel: md0: no spare disk to reconstruct array! -- 
continuing in degraded mode
Sep 19 14:25:58 ABI1 kernel: md: recovery thread finished ...
--------------- /var/log/messages snip -------




----------------- output of "cat /proc/mdstat" before failer start 
--------------------
Personalities : [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid1 sdb1[1] sda1[0]
6816640 blocks [2/2] [UU]

md1 : active raid1 sdb2[1] sda2[0]
2107328 blocks [2/2] [UU]
----------------- output of "cat /proc/mdstat" before failer end 
--------------------

----------------- output of "cat /proc/mdstat" AFTER failer 
start--------------------
Personalities : [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid1 sdb1[1](F) sda1[0]
6816640 blocks [2/1] [U_]

md1 : active raid1 sdb2[1] sda2[0]
2107328 blocks [2/2] [UU]

unused devices: <none>
----------------- output of "cat /proc/mdstat" before AFTER end 
--------------------




----------------- output of "sfdisk -cl" start --------------------
Disk /dev/sda: 8715 cylinders, 64 heads, 32 sectors/track
Units = cylinders of 1048576 bytes, blocks of 1024 bytes, counting from 0

Device Boot Start End #cyls #blocks Id System
/dev/sda1 0+ 6656 6657- 6816752 fd Linux raid autodetect
/dev/sda2 6657 8714 2058 2107392 fd Linux raid autodetect
/dev/sda3 0 - 0 0 0 Empty
/dev/sda4 0 - 0 0 0 Empty

Disk /dev/sdb: 8715 cylinders, 64 heads, 32 sectors/track
Units = cylinders of 1048576 bytes, blocks of 1024 bytes, counting from 0

Device Boot Start End #cyls #blocks Id System
/dev/sdb1 0+ 6656 6657- 6816752 fd Linux raid autodetect
/dev/sdb2 6657 8714 2058 2107392 fd Linux raid autodetect
/dev/sdb3 0 - 0 0 0 Empty
/dev/sdb4 0 - 0 0 0 Empty
----------------- output of "sfdisk -cl" end--------------------



------ raidtab start ------------
raiddev /dev/md0
raid-level 1
nr-raid-disks 2
nr-spare-disks 0
persistent-superblock 1
chunk-size 4
device /dev/sda1
raid-disk 0
device /dev/sdb1
raid-disk 1

raiddev /dev/md1
raid-level 1
nr-raid-disks 2
nr-spare-disks 0
persistent-superblock 1
chunk-size 4
device /dev/sda2
raid-disk 0
device /dev/sdb2
raid-disk 1
------ raidtab end ------------


----------- /etc/fstab start -----------
/dev/md0 / ext3 defaults 1 2
/dev/md1 /data ext3 defaults 1 2
devpts /dev/pts devpts defaults 0 0
/dev/cdrom /media/cdrom auto ro,noauto,user,exec 0 0
/dev/dvd /media/dvd auto ro,noauto,user,exec 0 0
/dev/fd0 /media/floppy auto noauto,user,sync 0 0
usbdevfs /proc/bus/usb usbdevfs noauto 0 0
proc /proc proc defaults 0 0
----------- /etc/fstab end -----------

PS.. Sorry for the spelling ;-D

