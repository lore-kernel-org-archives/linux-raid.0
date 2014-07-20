From: Kenny Root <kenny@the-b.org>
Subject: Possible leak during reshaping layout
Date: Sat, 19 Jul 2014 22:27:00 -0700
Message-ID: <20140720052700.GB1838@batman-mbp.internally.la.gs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I may have stumbled into a kernel memory leak during reshaping of a RAID 10
from offset to near layout:

I have a RAID 10 array which was previously in offset layout. I decided to
reshape to a near layout. Eventually the machine had become very sluggish,
the load average shot up, and the reshape slowed down to nearly nothing.

    md127 : active raid10 sdh1[2] sdk1[3] sdf1[0] sdg1[1]
          7813771264 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
          [=========>...........]  reshape = 49.5% (3872227840/7813771264) finish=63624.5min speed=1032K/sec

A look at slabtop appears to show that there is an allocation that is
larger than the physical RAM (16GB):

     Active / Total Objects (% used)    : 61551490 / 61918456 (99.4%)
     Active / Total Slabs (% used)      : 2209811 / 2209811 (100.0%)
     Active / Total Caches (% used)     : 76 / 99 (76.8%)
     Active / Total Size (% used)       : 15241504.92K / 15319798.41K (99.5%)
     Minimum / Average / Maximum Object : 0.01K / 0.25K / 15.69K

      OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
    60511744 60511219  29%    0.25K 2183366       32  17466928K kmalloc-256
    193408  82391  42%    0.06K   3022       64     12088K kmalloc-64
    154880 129949  83%    0.03K   1210      128      4840K kmalloc-32
    154624 152783  98%    0.01K    302      512      1208K kmalloc-8
    144160 143412  99%    0.02K    848      170      3392K fsnotify_event_holder
    125103  34053  27%    0.08K   2453       51      9812K selinux_inode_security

Output of mdadm -D:

/dev/md127:
        Version : 1.2
  Creation Time : Wed Dec 20 19:41:25 2013
     Raid Level : raid10
     Array Size : 7813771264 (7451.79 GiB 8001.30 GB)
  Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sat Jul 19 22:20:55 2014
          State : active, reshaping
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : offset=2
     Chunk Size : 512K

 Reshape Status : 49% complete
     New Layout : near=2, far=1

           Name : local:home  (local to host local)
           UUID : 3102a888:f08888a8:da88e888:c6288888
         Events : 70841

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8       97        1      active sync   /dev/sdg1
       2       8      113        2      active sync   /dev/sdh1
       3       8      161        3      active sync   /dev/sdk1

uname -r output:
3.13.6-200.fc20.x86_64
