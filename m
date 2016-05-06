From: Christopher Jeffry Hamilton <chris@cjhx.net>
Subject: Help! Qnap array crash - trying to recover arrays without OS and syslog
Date: Fri, 6 May 2016 16:14:03 -0400
Message-ID: <CAMf3ejg7aLBMJn4GncitsyoVU=7ZHKTLQLcc6an7Pch0VgOXUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello community!

So, I'm decent with linux but want to tread carefully here as
soft-raid is not my strength.  I'm also searching archives and
googling quite a bit to see if I can solve the problem, but would very
much appreciate any assistance provided from this list.

Setup: I have an older QNAP 809U-RP box which was showing a bad disk
in 1 of the 2 arrays (both RAID 5).  The system was acting funny and I
could not log in so I "soft powered" off the device using the shutdown
button on the enclosure.  Upon power-on it had lost its OS and asked
to "factory reset" or "initialize" --- it noted that "factory reset"
would preserve all data so that is what I chose (This was probably a
bad choice).

What happened was it re-wrote its own OS onto the disks (I believe it
uses the first partition across a few disks).  I believe it left the
later partitions alone; however I also lost /var/log/messages and any
debugging ability in this process.

Here is what I have on that system:

RAID5 (WD 2TB Blacks) - sda, sdb, sdc, sdd, sdh
RAID5 (HGST 4TB) - sde, sdf, sdg


The bad drive should have been in the WD 2TB array.  As was the "QNAP OS"

[/tmp] # uname -a
Linux NASC834B5 3.4.6 #1 SMP Fri Mar 11 10:54:42 CST 2016 x86_64 unknown

[/tmp] # mount
/proc on /proc type proc (rw)
none on /dev/pts type devpts (rw,gid=5,mode=620)
sysfs on /sys type sysfs (rw)
tmpfs on /tmp type tmpfs (rw,size=64M)
tmpfs on /dev/shm type tmpfs (rw)
none on /proc/bus/usb type usbfs (rw)
/dev/sda4 on /mnt/ext type ext3 (rw)
/dev/md9 on /mnt/HDA_ROOT type ext3 (rw,data=ordered)
tmpfs on /mnt/rf/nd type tmpfs (rw,size=1m)


[/tmp] # dmesg |grep sd
[   64.469381] EXT3-fs (sdg1): mounted filesystem with writeback data mode
[   64.529845] EXT3-fs (sdh1): mounted filesystem with writeback data mode
[   64.964243] md: bind<sda1>
[   64.968061] md: bind<sdc1>
[   64.971892] md: bind<sdg1>
[   64.975727] md: bind<sdd1>
[   64.979477] md: bind<sdh1>
[   64.983185] md: bind<sde1>
[   64.986840] md: bind<sdf1>
[   64.990480] md: bind<sdb1>
[   67.399806] md: bind<sda4>
[  110.406857] ufsd: module license 'Commercial product' taints kernel.
[  110.415588] ufsd: driver (lke_9.2.0 QNAP,
build_host("BuildServer37"), acl, ioctl, bdi, sd2(0), fua, bz, rsrc)
loaded at ffffffffa0152000
[  234.350035] md: bind<sda2>
[  249.073911] md: bind<sda3>
[  250.084610] md: unbind<sda3>
[  250.092028] md: export_rdev(sda3)
[  250.116276] md: bind<sda3>
[  250.120499] md/raid:md0: device sda3 operational as raid disk 0
[  250.146663]  disk 0, o:1, dev:sda3
[  251.180995] md: unbind<sda3>
[  251.187031] md: export_rdev(sda3)
[  256.544983] md: bind<sda3>
[  256.548597] md/raid:md0: device sda3 operational as raid disk 0
[  256.573794]  disk 0, o:1, dev:sda3
[  256.607064] md: unbind<sda3>
[  256.613034] md: export_rdev(sda3)
[  261.777279] md: bind<sda3>
[  261.781028] md/raid:md0: device sda3 operational as raid disk 0
[  261.805371]  disk 0, o:1, dev:sda3
[  261.847186] md: unbind<sda3>
[  261.853028] md: export_rdev(sda3)


[/tmp] # mdadm --examine /dev/sd[abcdefghi][1234] >raid.status2
mdadm: No md superblock detected on /dev/sda4.
mdadm: cannot open /dev/sdb2: No such device or address
mdadm: cannot open /dev/sdb3: No such device or address
mdadm: cannot open /dev/sdb4: No such device or address
mdadm: cannot open /dev/sdc2: No such device or address
mdadm: cannot open /dev/sdc3: No such device or address
mdadm: cannot open /dev/sdc4: No such device or address
mdadm: cannot open /dev/sdd2: No such device or address
mdadm: cannot open /dev/sdd3: No such device or address
mdadm: cannot open /dev/sdd4: No such device or address
mdadm: cannot open /dev/sde2: No such device or address
mdadm: cannot open /dev/sde3: No such device or address
mdadm: cannot open /dev/sde4: No such device or address
mdadm: cannot open /dev/sdf2: No such device or address
mdadm: cannot open /dev/sdf3: No such device or address
mdadm: cannot open /dev/sdf4: No such device or address
mdadm: cannot open /dev/sdg2: No such device or address
mdadm: cannot open /dev/sdg3: No such device or address
mdadm: cannot open /dev/sdg4: No such device or address
mdadm: cannot open /dev/sdh2: No such device or address
mdadm: cannot open /dev/sdh3: No such device or address
mdadm: cannot open /dev/sdh4: No such device or address
mdadm: cannot open /dev/sdi1: No such device or address
mdadm: cannot open /dev/sdi2: No such device or address
mdadm: cannot open /dev/sdi3: No such device or address
mdadm: cannot open /dev/sdi4: No such device or address
[/tmp] # cat raid.status2
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 48ad1c97:9f0a7c9f:d8b3b3c6:021a9414
  Creation Time : Fri Apr  6 20:36:20 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 9
>
    Update Time : Fri May  6 19:13:05 2016
          State : clean
Internal Bitmap : present
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 132ffeb0 - correct
         Events : 0.6637531
>
>
      Number   Major   Minor   RaidDevice State
this     1       8        1        1      active sync   /dev/sda1
>
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       65        6      active sync   /dev/sde1
   7     7       8       81        7      active sync   /dev/sdf1
/dev/sda2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 0f2dee7f:5513f0fe:37d369f2:6344ed21
           Name : 8
  Creation Time : Thu May  5 20:53:18 2016
     Raid Level : raid1
   Raid Devices : 2
>
  Used Dev Size : 1060256 (517.79 MiB 542.85 MB)
     Array Size : 1060256 (517.79 MiB 542.85 MB)
   Super Offset : 1060264 sectors
          State : clean
    Device UUID : 2c5feba8:aff78b27:431543f5:aa6655de
>
    Update Time : Thu May  5 20:53:20 2016
       Checksum : 8e374d11 - correct
         Events : 5
>
>
    Array Slot : 0 (0, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed,
failed)
   Array State : U_ 383 failed
/dev/sda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 4566ad78:44a12cc5:3e572f10:1012131f
  Creation Time : Sun Jul 10 14:27:42 2011
     Raid Level : raid5
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 7807782400 (7446.08 GiB 7995.17 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
>
    Update Time : Thu May  5 21:03:34 2016
          State : clean
Internal Bitmap : present
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 9d580050 - correct
         Events : 0.17725281
>
         Layout : left-symmetric
     Chunk Size : 64K
>
      Number   Major   Minor   RaidDevice State
this     0       8        3        0      active sync   /dev/sda3
>
   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
   4     4       8      115        4      active sync   /dev/sdh3
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 48ad1c97:9f0a7c9f:d8b3b3c6:021a9414
  Creation Time : Fri Apr  6 20:36:20 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 9
>
    Update Time : Fri May  6 19:13:05 2016
          State : clean
Internal Bitmap : present
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 132ffebe - correct
         Events : 0.6637531
>
>
      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1
>
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       65        6      active sync   /dev/sde1
   7     7       8       81        7      active sync   /dev/sdf1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 48ad1c97:9f0a7c9f:d8b3b3c6:021a9414
  Creation Time : Fri Apr  6 20:36:20 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 9
>
    Update Time : Fri May  6 19:13:05 2016
          State : clean
Internal Bitmap : present
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 132ffed2 - correct
         Events : 0.6637531
>
>
      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1
>
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       65        6      active sync   /dev/sde1
   7     7       8       81        7      active sync   /dev/sdf1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 48ad1c97:9f0a7c9f:d8b3b3c6:021a9414
  Creation Time : Fri Apr  6 20:36:20 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 9
>
    Update Time : Fri May  6 19:13:05 2016
          State : clean
Internal Bitmap : present
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 132ffee6 - correct
         Events : 0.6637531
>
>
      Number   Major   Minor   RaidDevice State
this     4       8       49        4      active sync   /dev/sdd1
>
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       65        6      active sync   /dev/sde1
   7     7       8       81        7      active sync   /dev/sdf1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 48ad1c97:9f0a7c9f:d8b3b3c6:021a9414
  Creation Time : Fri Apr  6 20:36:20 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 9
>
    Update Time : Fri May  6 19:13:05 2016
          State : clean
Internal Bitmap : present
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 132ffefa - correct
         Events : 0.6637531
>
>
      Number   Major   Minor   RaidDevice State
this     6       8       65        6      active sync   /dev/sde1
>
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       65        6      active sync   /dev/sde1
   7     7       8       81        7      active sync   /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 48ad1c97:9f0a7c9f:d8b3b3c6:021a9414
  Creation Time : Fri Apr  6 20:36:20 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 9
>
    Update Time : Fri May  6 19:13:05 2016
          State : clean
Internal Bitmap : present
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 132fff0c - correct
         Events : 0.6637531
>
>
      Number   Major   Minor   RaidDevice State
this     7       8       81        7      active sync   /dev/sdf1
>
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       65        6      active sync   /dev/sde1
   7     7       8       81        7      active sync   /dev/sdf1
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 48ad1c97:9f0a7c9f:d8b3b3c6:021a9414
  Creation Time : Fri Apr  6 20:36:20 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 9
>
    Update Time : Fri May  6 19:13:05 2016
          State : clean
Internal Bitmap : present
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 132fff14 - correct
         Events : 0.6637531
>
>
      Number   Major   Minor   RaidDevice State
this     3       8       97        3      active sync   /dev/sdg1
>
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       65        6      active sync   /dev/sde1
   7     7       8       81        7      active sync   /dev/sdf1
/dev/sdh1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 48ad1c97:9f0a7c9f:d8b3b3c6:021a9414
  Creation Time : Fri Apr  6 20:36:20 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 9
>
    Update Time : Fri May  6 19:13:05 2016
          State : clean
Internal Bitmap : present
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 132fff28 - correct
         Events : 0.6637531
>
>
      Number   Major   Minor   RaidDevice State
this     5       8      113        5      active sync   /dev/sdh1
>
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       65        6      active sync   /dev/sde1
   7     7       8       81        7      active sync   /dev/sdf1


Please let me know if there's something I else I should be looking at
to rebuild these two arrays - I hope recovering the HGST array will be
easy, and ideally I'd get both back.  I have backups of 80% of the
data but not everything and figure this is a good opportunity to rack
my brain and learn more about linux RAID.

Thanks!

Ciao,
-Chris
T: +1.805.628.2126 | F: +1.610.395.6832 | E: chris@cjhx.net
