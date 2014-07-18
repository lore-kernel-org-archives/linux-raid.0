From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Unable to reduce raid size.
Date: Fri, 18 Jul 2014 10:50:54 +0200
Message-ID: <53C8DFEE.7000000@megasoft.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a strange issue, I cannot reduce the size of a degraded raid 5:

strace mdadm -vv --grow /dev/md125 --size=2778726400

Fails with:
Stace:
    open("/sys/block/md125/md/dev-sdb4/size", O_WRONLY) = 4
    write(4, "2778726400", 10)              = -1 EBUSY (Device or resource busy)
    close(4)
Stdout:
    component size of /dev/md125 unchanged at 2858285568K
Stderr:
    <nothing>


Any suggestions ?
Note: I can work around this bug, by moving partitions around a bit, and not requiring the size reduction.
However I suspect a bug/undocumented border case that should be resolved?


Things I tried:
---------------
- Disable bcache udev rules (as it was appearing in each attempt, maybe it got triggered during resize, seems not to be the case).
- I have tried the same with loop files -> this works fine even with bcache (and the udev rules disabled)
- Removed the internal write bitmap
- Opend the file os.open("md125",os.O_EXCL,os.O_RDWR) in Python to test if it's in use somewhere (command worked fine)
- Set array-size to the less then the desired new size (while still not destroying the FS below it).

 
Information:
------------
Kernel version: 3.15.5
mdadm tools: 3.3-r2

mdadm --detail:
/dev/md125:
        Version : 1.2
  Creation Time : Wed Apr 16 20:58:09 2014
     Raid Level : raid5
     Array Size : 8283750400 (7900.00 GiB 8482.56 GB)
  Used Dev Size : 2858285568 (2725.87 GiB 2926.88 GB)
   Raid Devices : 4
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Fri Jul 18 09:53:08 2014
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           UUID : 885c588b:c3503d9d:c67b86db:2887f8f7
         Events : 6440

    Number   Major   Minor   RaidDevice State
       0       8       36        0      active sync   /dev/sdc4
       2       0        0        2      removed
       2       8       20        2      active sync   /dev/sdb4
       4       8       52        3      active sync   /dev/sdd4

-- 
Killian De Volder
Megasoft bvba
killian.de.volder@megasoft.be

