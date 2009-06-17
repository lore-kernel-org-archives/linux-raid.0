From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Resize Raid5 devices
Date: Wed, 17 Jun 2009 16:22:20 +0200
Message-ID: <62E07ACC-0F47-4B5F-94C7-29199ECE46FE@bj-ig.de>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Problem: I would like to grow the member devices of an existing raid5  
without
a 40 hour rebuild.

What happend up to here:
Two or three years before I created a raid5 with 5 300GB disks. A year  
before
I replaced 3 of these disks by 1.5TB models. At this time I decided to
partition these disks to have a 1.2TB partition at the beginning
and a 300GB partition at the end. The 300GB partitions replaced the  
300GB
disks, the 1.2 TB partitions became member of a new raid5 with a  
version 1.2
superblocks. I choose version 1.2 superblocks because they are at the  
beginning
of the disk so I thought I could resize the partition later without  
need to
rebuild the array.

Later has been an hour before ;)

After I added a forth 1.5TB disk to the array yesterday and reshaped the
former 3 disk raid5 to a 4 disk one, I wiped out the 300GB disk raid5,  
set one
of the 1.2TB partitions faulty, removed it from its raid, removed the  
300GB
partition and resized the former 1.2TB partition (in place) to 1.5TB.  
Now I
added this partition to its raid.

It has been recognized as a former member of this raid - so far so  
good - but
for whatever reason the raid subsystem decided to start a complete  
recovery.
So here my question:

What went wrong and what do I have to do to avoid a full recovery for  
the
next disk?

I do not feel well with a degraded raid5 in a 10 hour rebuild ...

Regards
Ralf

PS: no the system is not the fastest - it is optimized for size not for
speed.

DatenGrab:/media # uname -a
Linux DatenGrab 2.6.25.20-0.4-default #1 SMP 2009-06-01 09:57:12 +0200  
i686 i686 i386 GNU/Linux
DatenGrab:/media # mdadm --version
mdadm - v2.6.4 - 19th October 2007
DatenGrab:/media # cat /etc/SuSE-release
openSUSE 11.0 (i586)
VERSION = 11.0

DatenGrab:/media # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1]
md3 : active raid5 sdf1[3] sdi1[0] sdj1[4] sdh1[1]
       3457099008 blocks super 1.2 level 5, 256k chunk, algorithm 2  
[4/4] [UUUU]
       bitmap: 0/275 pages [0KB], 2048KB chunk

DatenGrab:/media # mdadm -f /dev/md3 /dev/sdf1
mdadm: set /dev/sdf1 faulty in /dev/md3

DatenGrab:/media # mdadm -r /dev/md3 /dev/sdf1
mdadm: hot removed /dev/sdf1

DatenGrab:/media # fdisk /dev/sdf
Command (m for help): p

Disk /dev/sdf: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x26583dd9

    Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1      143463  1152366516   fd  Linux raid  
autodetect
/dev/sdf2          143489      182401   312568672+  fd  Linux raid  
autodetect

Command (m for help): d
Partition number (1-4): 2

Command (m for help): d
Selected partition 1

Command (m for help): n
[...]
Command (m for help): p

Disk /dev/sdf: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x26583dd9

    Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1      182386  1465015513+  fd  Linux raid  
autodetect

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.

DatenGrab:/media # mdadm -a /dev/md3 /dev/sdf1
mdadm: re-added /dev/sdf1

DatenGrab:/media # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1]
md3 : active raid5 sdf1[3] sdi1[0] sdj1[4] sdh1[1]
       3457099008 blocks super 1.2 level 5, 256k chunk, algorithm 2  
[4/3] [UUU_]
       [>....................]  recovery =  0.0% (83184/1152366336)  
finish=461.6min speed=41592K/sec
       bitmap: 2/275 pages [8KB], 2048KB chunk

Kernel log:
Jun 17 15:34:46 DatenGrab kernel: raid5: Disk failure on sdf1,  
disabling device.
  Operation continuing on 3 devices
Jun 17 15:34:55 DatenGrab kernel: RAID5 conf printout:
Jun 17 15:34:55 DatenGrab kernel:  --- rd:4 wd:3
Jun 17 15:34:55 DatenGrab kernel:  disk 0, o:1, dev:sdi1
Jun 17 15:34:55 DatenGrab kernel:  disk 1, o:1, dev:sdh1
Jun 17 15:34:55 DatenGrab kernel:  disk 2, o:1, dev:sdj1
Jun 17 15:34:55 DatenGrab kernel:  disk 3, o:0, dev:sdf1
Jun 17 15:34:55 DatenGrab kernel: RAID5 conf printout:
Jun 17 15:34:55 DatenGrab kernel:  --- rd:4 wd:3
Jun 17 15:34:55 DatenGrab kernel:  disk 0, o:1, dev:sdi1
Jun 17 15:34:55 DatenGrab kernel:  disk 1, o:1, dev:sdh1Jun 17  
15:34:55 DatenGrab kernel:  disk 2, o:1, dev:sdj1
Jun 17 15:34:55 DatenGrab kernel: md: unbind<sdf1>
Jun 17 15:34:55 DatenGrab kernel: md: export_rdev(sdf1)
Jun 17 15:37:54 DatenGrab kernel: sd 6:0:0:0: [sdf] 2930277168 512- 
byte hardware sectors (1500302 MB)
Jun 17 15:37:54 DatenGrab kernel: sd 6:0:0:0: [sdf] Write Protect is off
Jun 17 15:37:54 DatenGrab kernel: sd 6:0:0:0: [sdf] Mode Sense: 00 3a  
00 00Jun 17 15:37:54 DatenGrab kernel: sd 6:0:0:0: [sdf] Write cache:  
enabled, read c
ache: enabled, doesn't support DPO or FUA
Jun 17 15:37:54 DatenGrab kernel:  sdf: sdf1
Jun 17 15:37:56 DatenGrab kernel: sd 6:0:0:0: [sdf] 2930277168 512- 
byte hardware sectors (1500302 MB)
Jun 17 15:37:56 DatenGrab kernel: sd 6:0:0:0: [sdf] Write Protect is off
Jun 17 15:37:56 DatenGrab kernel: sd 6:0:0:0: [sdf] Mode Sense: 00 3a  
00 00
Jun 17 15:37:56 DatenGrab kernel: sd 6:0:0:0: [sdf] Write cache:  
enabled, read c
ache: enabled, doesn't support DPO or FUA
Jun 17 15:37:56 DatenGrab kernel:  sdf: sdf1

Jun 17 15:38:15 DatenGrab kernel: md: bind<sdf1>
Jun 17 15:38:15 DatenGrab kernel: RAID5 conf printout:
Jun 17 15:38:15 DatenGrab kernel:  --- rd:4 wd:3
Jun 17 15:38:15 DatenGrab kernel:  disk 0, o:1, dev:sdi1
Jun 17 15:38:15 DatenGrab kernel:  disk 1, o:1, dev:sdh1
Jun 17 15:38:15 DatenGrab kernel:  disk 2, o:1, dev:sdj1
Jun 17 15:38:15 DatenGrab kernel:  disk 3, o:1, dev:sdf1
Jun 17 15:38:15 DatenGrab kernel: md: recovery of RAID array md3
Jun 17 15:38:15 DatenGrab kernel: md: minimum _guaranteed_  speed:  
1000 KB/sec/disk.
Jun 17 15:38:15 DatenGrab kernel: md: using maximum available idle IO  
bandwidth (but not more than 200000 KB/sec) for recovery.
Jun 17 15:38:15 DatenGrab kernel: md: using 128k window, over a total  
of 1152366

-- 
Van Roy's Law: -------------------------------------------------------
        An unbreakable toy is useful for breaking other toys.



