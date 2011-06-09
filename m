From: Matthias Dahl <ml_linux_raid@mortal-soul.de>
Subject: [BUG?] RAID not properly assembled w/ kernel 2.6.39.x
Date: Thu, 9 Jun 2011 15:21:54 +0200
Message-ID: <201106091521.54769.ml_linux_raid@mortal-soul.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.

I tried updating to 2.6.39.1 from 2.6.38.2 and failed due to some md raid
issues I wasn't able to solve even after hours.   I hope someone can help
me out- I'd really appreciate it.

I've running two RAID1s (boot, swap) and one partitioned RAID5 (3 partitions):

dreamgate ~ # mdadm --misc -D /dev/md{0,1,_d0}
/dev/md0:
        Version : 0.90
  Creation Time : Sat Aug  8 03:09:54 2009
     Raid Level : raid1
     Array Size : 779008 (760.88 MiB 797.70 MB)
  Used Dev Size : 779008 (760.88 MiB 797.70 MB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jun  9 14:49:31 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           UUID : c6c29c17:d2088f05:bfe78010:bc810f04
         Events : 0.74

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8        1        1      active sync   /dev/sda1
       2       8       49        2      active sync   /dev/sdd1
/dev/md1:
        Version : 0.90
  Creation Time : Sat Aug  8 03:10:33 2009
     Raid Level : raid1
     Array Size : 4000064 (3.81 GiB 4.10 GB)
  Used Dev Size : 4000064 (3.81 GiB 4.10 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Thu Jun  9 14:49:31 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           UUID : f4f3dfc8:812e35f6:bfe78010:bc810f04
         Events : 0.30

    Number   Major   Minor   RaidDevice State
       0       8       34        0      active sync   /dev/sdc2
       1       8        2        1      active sync   /dev/sda2
       2       8       50        2      active sync   /dev/sdd2
/dev/md_d0:
        Version : 1.0
  Creation Time : Sat Aug  8 03:46:31 2009
     Raid Level : raid5
     Array Size : 1943961088 (1853.91 GiB 1990.62 GB)
  Used Dev Size : 971980544 (926.95 GiB 995.31 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Thu Jun  9 14:49:32 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : localhost.localdomain:d0
           UUID : fbbdaaca:b89e291b:784b7787:a4b65ebd
         Events : 5080856

    Number   Major   Minor   RaidDevice State
       0       8       35        0      active sync   /dev/sdc3
       1       8        3        1      active sync   /dev/sda3
       3       8       51        2      active sync   /dev/sdd3

This worked fine since day one actually. I'm using Gentoo x86_64 w/ mdadm
3.1.5 and an initramfs created by genkernel to start the raids and  mount
root which is on one of those RAID5 partitions.

The  initramfs  simply does a "mdadm --assemble --scan" w/o a mdadm.conf.
This worked fine with any kernel prior to 2.6.39.x. Now whatever I do, it
does not create the devices as usual like: /dev/md0 /dev/md1 /dev/md_d0pX
where X is {1..3}. It suffixes the unpartitioned devices w/ "_0" which is
due to the homehost not matching (which was never a problem) and has even
more problems with the partitioned RAID5. Those end up as md127pX in /dev
and localhost.localdomain:d0 in /dev/md.    And depending on what you do,
you even get an additional partition  p4  like  when  simply  adding  the
following mdadm.conf to the initramfs  so  there  is  no   auto-detection
necessary:

ARRAY /dev/md0 level=raid1 num-devices=3 UUID=c6c29c17:d2088f05:bfe78010:bc810f04
ARRAY /dev/md1 level=raid1 num-devices=3 UUID=f4f3dfc8:812e35f6:bfe78010:bc810f04
ARRAY /dev/md_d0 level=raid5 metadata=1.0 auto=mdp num-devices=3 UUID=fbbdaaca:b89e291b:784b7787:a4b65ebd name=localhost.localdomain:d0

I've experimented with homehost but never got to a point where everything
was simply right again.   Setting homehost to "<ignore>" changed nothing.
Changing it to "localhost.localdomain" fixed the problem with the  prefix
and the suffixes but the numbering (md127 instead of md_d0) wasn't  still
right, no partitions were created in /dev/md/ (but in /dev) and  I  ended
up with one additional partition (4).

I'm sorry for this chaotic explanation but as you can see it's quite hard
to explain. :-(

Again, this works fine with any kernel prior to 2.6.39 and adding a  conf
to the initramfs fixes  mostly anything but the additional partition prob
which has me worrying that something else might be wrong.

Like said earlier, I'd really appreciate anyone shedding  some  light  on
this. Thanks a lot in advance...

So long,
matthias.
