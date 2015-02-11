From: Dush <tomdush@gmail.com>
Subject: All drive in Raid 5 are in 'spare' mode
Date: Wed, 11 Feb 2015 19:56:30 +0000
Message-ID: <CAL7hTOctZ4tAoPSbO3iFEohRyXuvcY4=6yQj8U-FpoAhV6sT0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have a RAID 5 composed by 4x 500Go hdd but for some days, it's 'inactive'.

I'm not raid expert and I prefer asking before doing an unrecoverable mistake...

Is it possible to fix this raid (md126)?
Is it possible to recover data on it?
Do I have a disk to change or it's "just" a desynchronization between disks?

Thanks for your help

# mdadm --version
mdadm - v3.3.2 - 21st August 2014

Linux Kernel: 3.18.2-2

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : active raid5 sdd2[2] sde2[1] sdc2[0] sdb2[3]
      16530624 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md126 : inactive sde3[1](S) sdd3[4](S) sdc3[0](S) sdb3[3](S)
      1929888000 blocks

unused devices: <none>

# mdadm --examine /dev/sd[a-z]3
mdadm: No md superblock detected on /dev/sda3.
/dev/sdb3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 3327f442:a00b59b2:1397f3c2:236c0edf
  Creation Time : Tue Jan 27 13:03:52 2009
     Raid Level : raid5
  Used Dev Size : 482472000 (460.12 GiB 494.05 GB)
     Array Size : 1447416000 (1380.36 GiB 1482.15 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 126

    Update Time : Wed Jan 21 20:55:48 2015
          State : active
 Active Devices : 3
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 6e656c69 - correct
         Events : 49656

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       19        3      active sync   /dev/sdb3

   0     0       8       35        0      active sync   /dev/sdc3
   1     1       8       67        1      active sync   /dev/sde3
   2     2       0        0        2      faulty removed
   3     3       8       19        3      active sync   /dev/sdb3
   4     4       8       51        4      spare   /dev/sdd3
/dev/sdc3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 3327f442:a00b59b2:1397f3c2:236c0edf
  Creation Time : Tue Jan 27 13:03:52 2009
     Raid Level : raid5
  Used Dev Size : 482472000 (460.12 GiB 494.05 GB)
     Array Size : 1447416000 (1380.36 GiB 1482.15 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 126

    Update Time : Wed Jan 21 23:34:52 2015
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 6e6653d5 - correct
         Events : 49666

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       35        0      active sync   /dev/sdc3

   0     0       8       35        0      active sync   /dev/sdc3
   1     1       8       67        1      active sync   /dev/sde3
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       51        4      spare   /dev/sdd3
/dev/sdd3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 3327f442:a00b59b2:1397f3c2:236c0edf
  Creation Time : Tue Jan 27 13:03:52 2009
     Raid Level : raid5
  Used Dev Size : 482472000 (460.12 GiB 494.05 GB)
     Array Size : 1447416000 (1380.36 GiB 1482.15 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 126

    Update Time : Wed Jan 21 23:34:52 2015
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 6e6653e7 - correct
         Events : 49666

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       51        4      spare   /dev/sdd3

   0     0       8       35        0      active sync   /dev/sdc3
   1     1       8       67        1      active sync   /dev/sde3
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       51        4      spare   /dev/sdd3
/dev/sde3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 3327f442:a00b59b2:1397f3c2:236c0edf
  Creation Time : Tue Jan 27 13:03:52 2009
     Raid Level : raid5
  Used Dev Size : 482472000 (460.12 GiB 494.05 GB)
     Array Size : 1447416000 (1380.36 GiB 1482.15 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 126

    Update Time : Wed Jan 21 23:34:52 2015
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 6e6653f7 - correct
         Events : 49666

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       67        1      active sync   /dev/sde3

   0     0       8       35        0      active sync   /dev/sdc3
   1     1       8       67        1      active sync   /dev/sde3
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       51        4      spare   /dev/sdd3
