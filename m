From: =?UTF-8?Q?Tor_Arne_Vestb=C3=B8?= <torarnv@gmail.com>
Subject: RAID5 disk failure during rebuild of spare, any chance of recovery
 when one of the failed devices is suspected to be intact?
Date: Sun, 15 Aug 2010 20:52:45 +0200
Message-ID: <AANLkTimiGhkzSBgt73fLZmoOcGf5Yyui-1WjkPLVVR6v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hey,

Hoping for some crisis help here :)

Array consists of /dev/sd[bcdef]1 where b-e were active devices and
sdf1 was a spare.

After installing Ubunuty 10.04 and trying to reassemble the array it
got reassembled without sdb1, so mdadm started reconstructing the
array onto the spare sdf1. While this was going on, sdd failed, and
was pulled out as faulty. Now things look like this:

# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90
  Creation Time : Sun Mar  2 22:52:53 2008
     Raid Level : raid5
     Array Size : 2197715712 (2095.91 GiB 2250.46 GB)
  Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Aug 15 20:32:59 2010
          State : clean, degraded
 Active Devices : 2
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : a0186556:4ffb5a2a:822f8875:94ae7d2c
         Events : 0.24708

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1
       2       0        0        2      removed
       3       8       65        3      active sync   /dev/sde1

       4       8       17        -      spare   /dev/sdb1
       5       8       81        -      spare   /dev/sdf1
       6       8       49        -      faulty spare   /dev/sdd1


Mounting the array does not work :/

Normally a RAID5 with two lost devices is unrecoverable, as far as
I've understood it, but in this case i suspect that sdb1 is fully
intact, and that it was just for some reason picked up when the array
was first assembled.

If that's the case, is there any way i can "promote" sdb1 from spare
to active without rebuilding it (which would not work since the array
is messed up)? Basically reassembling the array as if sdb1, sdc1 and
sde1 were okey? and then rebuild the sdf1 spare?

Thanks!
