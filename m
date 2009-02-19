From: David Abrahams <dave@boostpro.com>
Subject: State: active vs clean
Date: Thu, 19 Feb 2009 15:19:24 -0500
Message-ID: <87y6w2uqlv.fsf@mcbain.luannocracy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I have two md arrays, as shown below.  When I booted my machine,
/dev/md1 had state "active."  Now it has state "clean."  Can someone
explain:

* What's the distinction?
* Why did the state of /dev/md1 change?
* Where is this information documented?

Thanks very much!

-----

/dev/md0:
        Version : 00.90
  Creation Time : Fri Feb 13 17:02:30 2009
     Raid Level : raid1
     Array Size : 48064 (46.95 MiB 49.22 MB)
  Used Dev Size : 48064 (46.95 MiB 49.22 MB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Feb 19 15:04:48 2009
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           UUID : e7a1a660:7c706227:b85fa97f:bc5a2294
         Events : 0.300

    Number   Major   Minor   RaidDevice State
       0       8       65        0      active sync   /dev/sde1
       1       8       81        1      active sync   /dev/sdf1
       2       8       97        2      active sync   /dev/sdg1
/dev/md1:
        Version : 00.90
  Creation Time : Fri Feb 13 17:03:39 2009
     Raid Level : raid6
     Array Size : 29301888 (27.94 GiB 30.01 GB)
  Used Dev Size : 4883648 (4.66 GiB 5.00 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Thu Feb 19 15:17:02 2009
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           UUID : 928d036a:68316b72:4211c500:2ffb6c4f
         Events : 0.4788

    Number   Major   Minor   RaidDevice State
       0       8       70        0      active sync   /dev/sde6
       1       8       86        1      active sync   /dev/sdf6
       2       8      102        2      active sync   /dev/sdg6
       3       8       48        3      active sync   /dev/sdd
       4       8        6        4      active sync   /dev/sda6
       5       8       22        5      active sync   /dev/sdb6
       6       8       38        6      active sync   /dev/sdc6
       7       8      112        7      active sync   /dev/sdh


-- 
Dave Abrahams
BoostPro Computing
http://www.boostpro.com
