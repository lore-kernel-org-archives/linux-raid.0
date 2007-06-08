From: phyros <dlopuch@mit.edu>
Subject: Help on Recovering a Corrupted raid5 Partition
Date: Fri, 8 Jun 2007 12:32:45 -0700 (PDT)
Message-ID: <11032621.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hey guys, I'd like some help recovering from a corrupted software Raid-5
setup. The raid-5 setup is on an embedded linux NAS (the Buffalo Terastation
Pro, if anyone's familiar with it), so I can't really give all that many
details as to the distro, version, setup, etc. All of that is hidden and
proprietary. The tech support told me that all I can do is scrap my data,
but this is stupid... they're manufacturing a redundant data server; they
should know better and have some corruption-recovery procedure in place. 
Welcome to capitalism.

Anyways, a hacked firmware does allow me to telnet into the device as root
(and probably void my warranty, but my data is more important than my
warranty... buffalo should realize that), so if any pertinent information is
discoverable, I can attempt to reverse engineer this thing if you tell me
what to do (my linux experience is about a few month's worth... enough to
get by but lacking in the deeper understandings of things). Google has been
surprisingly unhelpful in finding a comprehensive tutorial on
troubleshooting a raid configuration, so I'm hoping someone here can help
me.

Anyways, here's what I do know about the setup: it uses four 500gb SATA
drives in a RAID-5 configuration, and the raid arrays are mounted as md
devices. There's two main partitions of interest: /md0 is a system partition
and /md1 is the partition of data that I'm trying to recover. I suspect the
problem is a corrupted superblock, but I'm not quite sure on how to recover
from that.

Here's what I've discovered by poking around with mdadm. Looking at the
system partition...

================
================
root@HAXD_HELPER:/etc# mdadm --examine /dev/md0
mdadm: No super block found on /dev/md0 (Expected magic a92b4efc, got
00000000)


root@HAXD_HELPER:/etc# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.02
  Creation Time : Sat Jan 14 12:32:49 2006
     Raid Level : raid1
     Array Size : 385408 (376.38 MiB 394.66 MB)
    Device Size : 385408 (376.38 MiB 394.66 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jun  6 21:26:53 2007
          State : active
Active Devices : 4
Working Devices : 4
Failed Devices : 0
  Spare Devices : 0

           UUID : e87531ac:9fe1f96a:121f55a1:1220867e
         Events : 0.110

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       17        3      active sync   /dev/sdb1
================
================


I may not be understanding it correctly (or just not knowing what a good
working config looks like), but it seems that all the --details are fine
while the --examine says uh-oh. This is also weird since this is supposed to
be the system partition (and the system works since, well, I'm in it and
running commands), but it supposedly has a bad superblock.

Anyways, there's probably some implementation magic that makes things
happen. Thats not too important. I'm really just concerned about my data,
which is on /md1.


================
================
root@HAXD_HELPER:/etc# mdadm --examine /dev/md1     
mdadm: No super block found on /dev/md1 (Expected magic a92b4efc, got
7d7d7d7d)


root@HAXD_HELPER:/etc# mdadm --detail /dev/md1
/dev/md1:
        Version : 00.90.02
  Creation Time : Tue Dec 27 16:09:40 2005
     Raid Level : raid5
     Array Size : 1462862592 (1395.09 GiB 1497.97 GB)
    Device Size : 487620864 (465.03 GiB 499.32 GB)
   Raid Devices : 4
  Total Devices : 1
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Wed Jun  6 22:22:04 2007
          State : active, degraded
Active Devices : 1
Working Devices : 1
Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 37d97fb5:083ede07:8d3e9c16:0f299b85
         Events : 0.300

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       2       8       35        2      active sync   /dev/sdc3
       3       8       51        3      active sync   /dev/sdd3
================
================


What concerns me here are the lines that say there are 4 raid devices, but
only 1 total device. The md device doesn't have a good superblock, but when
I --examine the individual sd*3 partitions, they do appear to have good
superblocks, so this makes me think that all hope is not yet lost...


================
================
root@HAXD_HELPER:/etc# mdadm -E /dev/sd[abcd]3
/dev/sda3:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 37d97fb5:083ede07:8d3e9c16:0f299b85
  Creation Time : Tue Dec 27 16:09:40 2005
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 1
Preferred Minor : 1

    Update Time : Wed Jun  6 22:22:04 2007
          State : active
Active Devices : 4
Working Devices : 1
Failed Devices : 0
  Spare Devices : 0
       Checksum : 2cd505c9 - correct
         Events : 0.300

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        3        0      active sync   /dev/sda3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
/dev/sdb3:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 37d97fb5:083ede07:8d3e9c16:0f299b85
  Creation Time : Tue Dec 27 16:09:40 2005
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 1
Preferred Minor : 1

    Update Time : Wed Jun  6 22:22:04 2007
          State : active
Active Devices : 4
Working Devices : 1
Failed Devices : 0
  Spare Devices : 0
       Checksum : 2cd505db - correct
         Events : 0.300

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       19        1      active sync   /dev/sdb3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
/dev/sdc3:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 37d97fb5:083ede07:8d3e9c16:0f299b85
  Creation Time : Tue Dec 27 16:09:40 2005
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 1
Preferred Minor : 1

    Update Time : Wed Jun  6 22:22:04 2007
          State : active
Active Devices : 4
Working Devices : 1
Failed Devices : 0
  Spare Devices : 0
       Checksum : 2cd505ed - correct
         Events : 0.300

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       35        2      active sync   /dev/sdc3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
/dev/sdd3:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 37d97fb5:083ede07:8d3e9c16:0f299b85
  Creation Time : Tue Dec 27 16:09:40 2005
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 1
Preferred Minor : 1

    Update Time : Wed Jun  6 22:22:04 2007
          State : active
Active Devices : 4
Working Devices : 1
Failed Devices : 0
  Spare Devices : 0
       Checksum : 2cd505ff - correct
         Events : 0.300

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       51        3      active sync   /dev/sdd3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
================
================


So... it seems to me like the individual sd*3 devices have the right
superblock info, but the superblock info on the md1 device got bust. Is
there any way I can tell the md1 device to look at the individual sd*3
devices for its superblock? I'm not sure how to phrase this in terms of
proper raid/mdadm terminology (or if I even have the right idea).

Finally, it may help to figure out how these devices are scripted to be set
up at boot-time. Again, this is a embedded linux NAS device, so all of this
is hidden and would have to be reverse-engineered. I've been told that
creating a /initrd directory un-hides all of the boot-time scripts/ramdisk
(and indeed this works for my device), but I have no idea what to look for
in here or where to start.

Any help from a raid guru would be infinitely helpful.
-- 
View this message in context: http://www.nabble.com/Help-on-Recovering-a-Corrupted-raid5-Partition-tf3891709.html#a11032621
Sent from the linux-raid mailing list archive at Nabble.com.

