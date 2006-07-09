From: Karl Voit <news@Karl-Voit.at>
Subject: only 4 spares and no access to my data
Date: Sun, 9 Jul 2006 18:59:56 +0000 (UTC)
Message-ID: <loom.20060709T205013-455@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I created a sw-raid md0 and a LVM above with four 250GB Samsung SATA
disks a couple of months ago. I am not an raid expert but I thought I
could handle it with a little help of my friends from grml: Andreas
jimmy Gredler and Michael mika Prokop.

,----
|      md0  <future mds>      (PV:s on partitions or whole disks) 
|        \   /   
|         \ /      
|        datavg             (VG)
|           |     
|           |    
|        datalv           (LV)
|           |                                  
|         ext3         (filesystem) 
`----

HW: Promise FastTrack SATA controller on an P3-board. (A previously
used - and preferred - Dawicontrol DC-150 did not work at all: I could
not access the hdds.)

Approximately once a month, there was a short timeout that caused a
disk to be removed from the raid. A SMART-check and a resync (hot-add)
solved the problem so far.

,----[ syslog ]
| May  1 23:12:51 ned kernel: ata2: command timeout
| May  1 23:12:51 ned kernel: ata2: translated ATA stat/err 0x25/00\
 to SCSI
SK/ASC/ASCQ 0x4/00/00
| May  1 23:12:51 ned kernel: ata2: status=0x25 { DeviceFault\
 CorrectedError Error }
| May  1 23:12:51 ned kernel: SCSI error : <1 0 0 0> return code =\
 0x8000002
| May  1 23:12:51 ned kernel: sdb: Current: sense key: Hardware Error
| May  1 23:12:51 ned kernel: Additional sense: No additional sense\
 information
| May  1 23:12:51 ned kernel: end_request: I/O error, dev sdb, sector\
 179281983
| May  1 23:12:51 ned kernel: raid5: Disk failure on sdb1, disabling\
 device.
Operation continuing on 3 devices
| May  1 23:12:51 ned kernel: RAID5 conf printout:
| May  1 23:12:51 ned kernel: --- rd:4 wd:3 fd:1
| May  1 23:12:51 ned kernel: disk 0, o:1, dev:sda1
| May  1 23:12:51 ned kernel: disk 1, o:0, dev:sdb1
| May  1 23:12:51 ned kernel: disk 2, o:1, dev:sdc1
| May  1 23:12:51 ned kernel: disk 3, o:1, dev:sdd1
| May  1 23:12:51 ned kernel: RAID5 conf printout:
| May  1 23:12:51 ned kernel: --- rd:4 wd:3 fd:1
| May  1 23:12:51 ned kernel: disk 0, o:1, dev:sda1
| May  1 23:12:51 ned kernel: disk 2, o:1, dev:sdc1
| May  1 23:12:51 ned kernel: disk 3, o:1, dev:sdd1
`----

But two weeks ago, there were another timeout during such a resync and
that was the beginning of my problem.

Short summary (for the impatient)
=============

sda and sdb were removed, hot adding did not work out and I
accidentally thought, that removing and adding the drives again could
solve my problem. Bad idea.

Now I am not able to get the raid working: all drives are marked as
spares and they can't be assembled:


root@ned ~ # mdadm --examine /dev/sd[abcd]1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 15f07005:037e4abf:70f51389:83dde0ed
  Creation Time : Sun Jan 29 21:35:05 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul  2 17:23:03 2006
          State : clean
 Active Devices : 0
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 4
       Checksum : 4eb2dfe6 - correct
         Events : 0.1652541

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8        1        4      spare   /dev/sda1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8        1        4      spare   /dev/sda1
   5     5       8       33        5      spare   /dev/sdc1
   6     6       8       17        6      spare   /dev/sdb1
   7     7       8       49        7      spare   /dev/sdd1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 15f07005:037e4abf:70f51389:83dde0ed
  Creation Time : Sun Jan 29 21:35:05 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul  2 17:23:03 2006
          State : clean
 Active Devices : 0
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 4
       Checksum : 4eb2dffa - correct
         Events : 0.1652541

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       17        6      spare   /dev/sdb1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8        1        4      spare   /dev/sda1
   5     5       8       33        5      spare   /dev/sdc1
   6     6       8       17        6      spare   /dev/sdb1
   7     7       8       49        7      spare   /dev/sdd1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 15f07005:037e4abf:70f51389:83dde0ed
  Creation Time : Sun Jan 29 21:35:05 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul  2 17:23:03 2006
          State : clean
 Active Devices : 0
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 4
       Checksum : 4eb2e008 - correct
         Events : 0.1652541

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       33        5      spare   /dev/sdc1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8        1        4      spare   /dev/sda1
   5     5       8       33        5      spare   /dev/sdc1
   6     6       8       17        6      spare   /dev/sdb1
   7     7       8       49        7      spare   /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 15f07005:037e4abf:70f51389:83dde0ed
  Creation Time : Sun Jan 29 21:35:05 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul  2 17:23:03 2006
          State : clean
 Active Devices : 0
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 4
       Checksum : 4eb2e01c - correct
         Events : 0.1652541

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8       49        7      spare   /dev/sdd1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8        1        4      spare   /dev/sda1
   5     5       8       33        5      spare   /dev/sdc1
   6     6       8       17        6      spare   /dev/sdb1
   7     7       8       49        7      spare   /dev/sdd1
root@ned ~ #


root@grml ~ # date;cat /proc/mdstat
Di Jul  4 21:36:15 CEST 2006
Personalities : [linear] [raid0] [raid1] [raid10] [raid5] [raid4]\
 [raid6]
[multipath]
unused devices: <none>
root@grml ~ # mdadm --detail /dev/md0
mdadm: md device /dev/md0 does not appear to be active.
1 root@grml ~ # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1\
 /dev/sdc1 /dev/sdd1    
mdadm: /dev/md0 assembled from 0 drives and 4 spares - not enough to\
 start the array.
1 root@grml ~ # mdadm --stop /dev/md0       
     
root@grml ~ # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1\
/dev/sdc1 /dev/sdd1 --force
mdadm: /dev/md0 assembled from 0 drives and 4 spares - not\
 enough to start the
array.
1 root@grml ~ # mdadm --zero-superblock /dev/sda     
     
mdadm: Couldn't open /dev/sda for write - not zeroing
1 root@grml ~ # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1\
 /dev/sdc1 /dev/sdd1 --run
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
1 root@grml ~ #


Andreas Gredler suggested following lines as a last attempt but risk
of loosing data which I want to avoid:

mdadm --stop /dev/md0
mdadm --zero-superblock /dev/sda
mdadm --zero-superblock /dev/sdb
mdadm --zero-superblock /dev/sdc
mdadm --zero-superblock /dev/sdd
mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1\
 /dev/sdd1 --force
mdadm --create -n 4 -l 5 /dev/md0 missing /dev/sdb1\
 /dev/sdc1 /dev/sdd1

Is there another solution to get to my data?

Thank you!



Background history (the whole story - directors cut)
==================

I published the whole story (as much as I could log during my reboots
and so on) on the web:

              http://paste.debian.net/8779

It is avaliable for 72h from now on. If you want to read it
afterwards, please write me an email and I send the log to you.

Please feel free to visit this page and do not hesitate to write me,
what I can also check!


mdadm-version: 1.12.0-1
uname: Linux ned 2.6.13-grml #1 Tue Oct 4 18:24:46 CEST 2005\
       i686 GNU/Linux

