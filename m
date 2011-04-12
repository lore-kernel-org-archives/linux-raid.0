From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Growing 6 HDD RAID5 to 7 HDD RAID5
Date: Tue, 12 Apr 2011 17:56:05 +0100
Message-ID: <BANLkTi=yZkM464MbvEgAjEWPGrR+eieXCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi mailing list,

First, thanks for this great software!

I have a RAID5 setup with on 6x 2TB HDD:

/dev/md0:
        Version : 1.2
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid5
     Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
  Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Apr 12 17:50:25 2011
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : ion:0  (local to host ion)
           UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
         Events : 3035979

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8       17        1      active sync   /dev/sdb1
       4       8       49        2      active sync   /dev/sdd1
       3       8       33        3      active sync   /dev/sdc1
       5       8       65        4      active sync   /dev/sde1
       6       8       97        5      active sync   /dev/sdg1

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdf1[0] sdg1[6] sde1[5] sdc1[3] sdd1[4] sdb1[1]
      9751756800 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
      bitmap: 1/15 pages [4KB], 65536KB chunk

unused devices: <none>


I'm approaching over 6.5TB of data, and with an array this large I'd
like to migrate to RAID6 for a bit more safety. I'm just checking if I
understand this correctly, this is how to do it:

* Add a HDD to the array as a hot spare:
mdadm --manage /dev/md0 --add /dev/sdh1

* Migrate the array to RAID6:
mdadm --grow /dev/md0 --raid-devices 7 --level 6

Cheers,
// Mathias
