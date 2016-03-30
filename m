From: Peter Knight <madcornishprojectionist@gmail.com>
Subject: Raid 6 failing to assemble after machine power loss now, with 1 disk
 only failed, seems to think its a raid0 array
Date: Wed, 30 Mar 2016 22:19:59 +0100
Message-ID: <CAAgcXJEgLxSaa7x3YO=CuMXS9hPPfPMiUtebQ4RB4F6dmQPd1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I hope someone can explain what is going on and hopefully help me
recover my data.

Machine stopped due to power cut it contains 5 hdd with 2 partitions
on each.  one set of partitions was a raid1 and this came back fine
showing that disk sdd1 was out of date.  the other set of partitions
for raid6 was much less happy.  when looking at it  (/dev/md126) it
seems to indicate it wants raid level0 but it was a raid6 array (which
has 2 spares) and only lost 1 disk.  In case of problems caused by the
out dated partition we zeroed the superblock on the outdated partition
but it still seems to not reassemble the raid6 and says not enough
disks (which there are).

We have tried a manual entry in the /etc/mdadm/mdadm.conf file
specifying this uuid for the device and forcing the raid level to 6
but still no success

What is causing this? and how can I get it reassembled so I can read the data?

Thanks

Peter

Relevant commands and outputs below:

root@Wheal-Peevor:~# cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md126 : inactive sdc2[1](S) sde2[3](S) sdf2[4](S) sdb2[0](S)
      7730171648 blocks

md127 : active raid1 sdc1[1] sde1[3] sdf1[4] sdb1[0]
      20971456 blocks [5/4] [UU_UU]




root@Wheal-Peevor:~# mdadm --detail /dev/md127
/dev/md127:
        Version : 0.90
  Creation Time : Sun Jan  9 14:02:22 2011
     Raid Level : raid1
     Array Size : 20971456 (20.00 GiB 21.47 GB)
  Used Dev Size : 20971456 (20.00 GiB 21.47 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 127
    Persistence : Superblock is persistent

    Update Time : Wed Mar 30 21:51:26 2016
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

           UUID : 504284fe:c53effb7:e9ca3044:bb7815cf (local to host
Wheal-Peevor)
         Events : 0.66830

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       4       0        0        4      removed
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1






root@Wheal-Peevor:~# mdadm --detail /dev/md126
/dev/md126:
        Version : 0.90
     Raid Level : raid0
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

          State : inactive

           UUID : 81186e3e:7abdbb10:e9ca3044:bb7815cf (local to host
Wheal-Peevor)
         Events : 0.2615946

    Number   Major   Minor   RaidDevice

       -       8       18        -        /dev/sdb2
       -       8       34        -        /dev/sdc2
       -       8       66        -        /dev/sde2
       -       8       82        -        /dev/sdf2






root@Wheal-Peevor:~# mdadm --examine /dev/sd[bcef]2
/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 81186e3e:7abdbb10:e9ca3044:bb7815cf (local to host
Wheal-Peevor)
  Creation Time : Sun Jan  9 14:02:38 2011
     Raid Level : raid6
  Used Dev Size : 1932542912 (1843.02 GiB 1978.92 GB)
     Array Size : 5797628736 (5529.05 GiB 5936.77 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 126

    Update Time : Sun Mar 13 10:54:22 2016
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 61abf5fc - correct
         Events : 2615946

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       18        0      active sync   /dev/sdb2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8       34        1      active sync   /dev/sdc2
   2     2       0        0        2      faulty removed
   3     3       8       66        3      active sync   /dev/sde2
   4     4       8       82        4      active sync   /dev/sdf2
/dev/sdc2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 81186e3e:7abdbb10:e9ca3044:bb7815cf (local to host
Wheal-Peevor)
  Creation Time : Sun Jan  9 14:02:38 2011
     Raid Level : raid6
  Used Dev Size : 1932542912 (1843.02 GiB 1978.92 GB)
     Array Size : 5797628736 (5529.05 GiB 5936.77 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 126

    Update Time : Sun Mar 13 10:54:22 2016
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 61abf60e - correct
         Events : 2615946

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       34        1      active sync   /dev/sdc2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8       34        1      active sync   /dev/sdc2
   2     2       0        0        2      faulty removed
   3     3       8       66        3      active sync   /dev/sde2
   4     4       8       82        4      active sync   /dev/sdf2
/dev/sde2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 81186e3e:7abdbb10:e9ca3044:bb7815cf (local to host
Wheal-Peevor)
  Creation Time : Sun Jan  9 14:02:38 2011
     Raid Level : raid6
  Used Dev Size : 1932542912 (1843.02 GiB 1978.92 GB)
     Array Size : 5797628736 (5529.05 GiB 5936.77 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 126

    Update Time : Sun Mar 13 10:54:22 2016
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 61abf632 - correct
         Events : 2615946

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       66        3      active sync   /dev/sde2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8       34        1      active sync   /dev/sdc2
   2     2       0        0        2      faulty removed
   3     3       8       66        3      active sync   /dev/sde2
   4     4       8       82        4      active sync   /dev/sdf2
/dev/sdf2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 81186e3e:7abdbb10:e9ca3044:bb7815cf (local to host
Wheal-Peevor)
  Creation Time : Sun Jan  9 14:02:38 2011
     Raid Level : raid6
  Used Dev Size : 1932542912 (1843.02 GiB 1978.92 GB)
     Array Size : 5797628736 (5529.05 GiB 5936.77 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 126

    Update Time : Sun Mar 13 10:54:22 2016
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 61abf644 - correct
         Events : 2615946

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       82        4      active sync   /dev/sdf2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8       34        1      active sync   /dev/sdc2
   2     2       0        0        2      faulty removed
   3     3       8       66        3      active sync   /dev/sde2
   4     4       8       82        4      active sync   /dev/sdf2
