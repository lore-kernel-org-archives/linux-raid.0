From: Joel Means <means.joel@gmail.com>
Subject: RAID5 assembles with wrong array size
Date: Fri, 24 Apr 2009 08:34:19 -0600
Message-ID: <e5c6503d0904240734j5fc26413nf80ad0f67f9c396c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I seem to be having major issues with my primary storage array.  I am
running Debian Lenny with a 2.6.29 kernel, compiled myself, and mdadm
version 2.6.7.2.  I have a seven disk RAID5.  My problem is that when
I assemble my array, the array size shown is too small.  Here is what
I get from mdadm -D /dev/md0:

/dev/md0:
        Version : 00.90
  Creation Time : Thu Apr 23 21:25:14 2009
     Raid Level : raid5
     Array Size : 782819968 (746.56 GiB 801.61 GB)
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Apr 23 21:25:14 2009
          State : clean, degraded
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 16b9b60d:ab7eb6b3:4bb6d167:
00581514 (local to host localhost)
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       97        1      active sync   /dev/sdg1
       2       8       65        2      active sync   /dev/sde1
       3       8       49        3      active sync   /dev/sdd1
       4       8        1        4      active sync   /dev/sda1
       5       8       81        5      active sync   /dev/sdf1
       6       0        0        6      removed

       7       8       17        -      spare   /dev/sdb1


Using mdadm -E on each of the drives gives the correct info:

/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 16b9b60d:ab7eb6b3:4bb6d167:00581514 (local to host localhost)
  Creation Time : Thu Apr 23 21:25:14 2009
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 2930303616 (2794.56 GiB 3000.63 GB)
   Raid Devices : 7
  Total Devices : 8
Preferred Minor : 0

    Update Time : Thu Apr 23 21:25:14 2009
          State : clean
 Active Devices : 6
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 68722cb1 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8        1        4      active sync   /dev/sda1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       97        1      active sync   /dev/sdg1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty
   7     7       8       17        7      spare   /dev/sdb1


Note the difference in Array Size.  I can remove and re-add /dev/sdb1,
and the array will start rebuilding, but the info from 'mdadm -E'
doesn't change.   Stopping and re-assembling the array puts the
following into /var/log/kern.log:

Apr 24 07:52:22 meansnet kernel: [40612.345814] md: md0 stopped.
Apr 24 07:52:22 meansnet kernel: [40612.345855] md: unbind<sdc1>
Apr 24 07:52:22 meansnet kernel: [40612.364018] md: export_rdev(sdc1)
Apr 24 07:52:22 meansnet kernel: [40612.364079] md: unbind<sdb1>
Apr 24 07:52:22 meansnet kernel: [40612.380013] md: export_rdev(sdb1)
Apr 24 07:52:22 meansnet kernel: [40612.380037] md: unbind<sdf1>
Apr 24 07:52:22 meansnet kernel: [40612.396013] md: export_rdev(sdf1)
Apr 24 07:52:22 meansnet kernel: [40612.396034] md: unbind<sda1>
Apr 24 07:52:22 meansnet kernel: [40612.408021] md: export_rdev(sda1)
Apr 24 07:52:22 meansnet kernel: [40612.408062] md: unbind<sdd1>
Apr 24 07:52:22 meansnet kernel: [40612.420021] md: export_rdev(sdd1)
Apr 24 07:52:22 meansnet kernel: [40612.420042] md: unbind<sde1>
Apr 24 07:52:22 meansnet kernel: [40612.432012] md: export_rdev(sde1)
Apr 24 07:52:22 meansnet kernel: [40612.432033] md: unbind<sdg1>
Apr 24 07:52:22 meansnet kernel: [40612.444013] md: export_rdev(sdg1)
Apr 24 07:52:45 meansnet kernel: [40632.630953] md: md0 stopped.
Apr 24 07:52:54 meansnet kernel: [40632.865163] md: bind<sdg1>
Apr 24 07:53:02 meansnet kernel: [40632.865333] md: bind<sde1>
Apr 24 07:53:10 meansnet kernel: [40632.865460] md: bind<sdd1>
Apr 24 07:53:10 meansnet kernel: [40632.871509] md: bind<sda1>
Apr 24 07:53:10 meansnet kernel: [40632.871659] md: bind<sdf1>
Apr 24 07:53:10 meansnet kernel: [40632.878380] md: bind<sdb1>
Apr 24 07:53:10 meansnet kernel: [40632.878509] md: bind<sdc1>
Apr 24 07:53:10 meansnet kernel: [40632.916237] raid5: device sdc1
operational as raid disk 0
Apr 24 07:53:10 meansnet kernel: [40632.916255] raid5: device sdf1
operational as raid disk 5
Apr 24 07:53:10 meansnet kernel: [40632.916271] raid5: device sda1
operational as raid disk 4
Apr 24 07:53:10 meansnet kernel: [40632.916288] raid5: device sdd1
operational as raid disk 3
Apr 24 07:53:10 meansnet kernel: [40632.916305] raid5: device sde1
operational as raid disk 2
Apr 24 07:53:10 meansnet kernel: [40632.916322] raid5: device sdg1
operational as raid disk 1
Apr 24 07:53:10 meansnet kernel: [40632.916897] raid5: allocated 7330kB for md0
Apr 24 07:53:10 meansnet kernel: [40632.916913] raid5: raid level 5
set md0 active with 6 out of 7 devices, algorithm 2
Apr 24 07:53:10 meansnet kernel: [40632.916940] RAID5 conf printout:
Apr 24 07:53:10 meansnet kernel: [40632.916954]  --- rd:7 wd:6
Apr 24 07:53:10 meansnet kernel: [40632.916967]  disk 0, o:1, dev:sdc1
Apr 24 07:53:10 meansnet kernel: [40632.916982]  disk 1, o:1, dev:sdg1
Apr 24 07:53:10 meansnet kernel: [40632.916996]  disk 2, o:1, dev:sde1
Apr 24 07:53:10 meansnet kernel: [40632.917019]  disk 3, o:1, dev:sdd1
Apr 24 07:53:10 meansnet kernel: [40632.917034]  disk 4, o:1, dev:sda1
Apr 24 07:53:10 meansnet kernel: [40632.917048]  disk 5, o:1, dev:sdf1
Apr 24 07:53:10 meansnet kernel: [40632.917483]  md0: unknown partition table



Running 'fsck.jfs' on /dev/md0 gives me an error about corrupt
superblocks, so I don't know if my data is hosed or not.  This was
working fine for over a year.   It could be the upgrade to the new
kernel that did this, but trying to revert to the older kernel gave me
several other issues.  Does anyone have any thoughts on what might be
done to fix this?
Thanks,

Joel
