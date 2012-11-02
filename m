From: Marc MERLIN <marc@merlins.org>
Subject: An md1 array doesn't re-assemble after reboot (/dev/sdf2 reports being an active member for /dev/md1, but a --re-add fails).
Date: Fri, 2 Nov 2012 07:42:04 -0700
Message-ID: <20121102144204.GE31851@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


gargamel:/var/spool# mdadm --version
mdadm - v3.2.3 - 23rd December 2011
gargamel:/var/spool# mdadm -a /dev/md1 /dev/sdf2
mdadm: /dev/sdf2 reports being an active member for /dev/md1, but a --re-add fails.
mdadm: not performing --add as that would convert /dev/sdf2 in to a spare.
mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdf2" first.
gargamel:/var/spool# mdadm --zero-superblock /dev/sdf2
gargamel:/var/spool# mdadm -a /dev/md1 /dev/sdf2
mdadm: added /dev/sdf2


I have this:
gargamel:/var/spool# mdadm -q --detail /dev/md1
/dev/md1:
        Version : 0.90
  Creation Time : Sun Jul 25 00:46:56 2010
     Raid Level : raid1
     Array Size : 1048512 (1024.11 MiB 1073.68 MB)
  Used Dev Size : 1048512 (1024.11 MiB 1073.68 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Nov  2 07:19:36 2012
          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : c5d9db9e:ea8efce2:5f1e94b5:d63edfe3
         Events : 0.318

    Number   Major   Minor   RaidDevice State
       0       8       82        0      active sync   /dev/sdf2
       1       8       98        1      active sync   /dev/sdg2

shutdown shows:
Stopping MD array md1...done (stopped).

Boot was like this, and it shows md1 being made out of just one drive
but not why. 
My other 3 md1 arrays re-assemble just fine, just this one does not.

kernel: 3.5.3:
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: invalid raid superblock magic on sda1
md: sda1 does not have a valid v0.90 superblock, not importing!
md: invalid raid superblock magic on sdb1
md: sdb1 does not have a valid v0.90 superblock, not importing!
md: invalid raid superblock magic on sdc1
md: sdc1 does not have a valid v0.90 superblock, not importing!
md: invalid raid superblock magic on sdd1
md: sdd1 does not have a valid v0.90 superblock, not importing!
md: invalid raid superblock magic on sde1
md: sde1 does not have a valid v0.90 superblock, not importing!
md: invalid raid superblock magic on sdf6
md: sdf6 does not have a valid v0.90 superblock, not importing!
md: invalid raid superblock magic on sdg6
md: sdg6 does not have a valid v0.90 superblock, not importing!
md: Scanned 12 and added 5 devices.
md: autorun ...
md: considering sdg5 ...
md:  adding sdg5 ...
md: sdg2 has different UUID to sdg5
md: sdg1 has different UUID to sdg5
md:  adding sdf5 ...
md: sdf1 has different UUID to sdg5
md: created md2
md: bind<sdf5>
md: bind<sdg5>
md: running: <sdg5><sdf5>
bio: create slab <bio-1> at 1
md/raid1:md2: active with 2 out of 2 mirrors
md2: detected capacity change from 0 to 6442385408
md: considering sdg2 ...
md:  adding sdg2 ...
md: sdg1 has different UUID to sdg2
md: sdf1 has different UUID to sdg2
md: created md1
md: bind<sdg2>
md: running: <sdg2>
md/raid1:md1: active with 1 out of 2 mirrors

Before I force re-adding sdf2, here's what things look like.

gargamel:~# mdadm --examine /dev/sdg2
/dev/sdg2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : c5d9db9e:ea8efce2:5f1e94b5:d63edfe3
  Creation Time : Sun Jul 25 00:46:56 2010
     Raid Level : raid1
  Used Dev Size : 1048512 (1024.11 MiB 1073.68 MB)
     Array Size : 1048512 (1024.11 MiB 1073.68 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1

    Update Time : Fri Nov  2 07:32:38 2012
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 2be1651c - correct
         Events : 320


      Number   Major   Minor   RaidDevice State
this     1       8       98        1      active sync   /dev/sdg2

   0     0       0        0        0      removed
   1     1       8       98        1      active sync   /dev/sdg2
gargamel:~# mdadm --examine /dev/sdf2
/dev/sdf2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : c5d9db9e:ea8efce2:5f1e94b5:d63edfe3
  Creation Time : Sun Jul 25 00:46:56 2010
     Raid Level : raid1
  Used Dev Size : 1048512 (1024.11 MiB 1073.68 MB)
     Array Size : 1048512 (1024.11 MiB 1073.68 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Fri Nov  2 07:31:18 2012
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 2be16511 - correct
         Events : 318


      Number   Major   Minor   RaidDevice State
this     0       8       82        0      active sync   /dev/sdf2

   0     0       8       82        0      active sync   /dev/sdf2
   1     1       8       98        1      active sync   /dev/sdg2


Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
