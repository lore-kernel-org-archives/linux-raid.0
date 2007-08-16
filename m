From: rdc <denrdc@gmail.com>
Subject: MD Raid5 rebuild problems - md: sde has invalid sb, not importing!
Date: Thu, 16 Aug 2007 23:58:51 +0200
Message-ID: <200708162358.51671.denrdc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

During a motherboard upgrade, I did something rather stupid : rewrite grub to 
the bootsector of my bootdisk ( or so i thought ), but due to the new board 
and thus a new device order I ended up destroying the beginning of 1 disk of 
a 6 disk raid5 array. No worries, but after completly zeroing the "bad" disk, 
i can't add it anymore. 
 
mdadm says this : 
 
  /dev/md0: 
         Version : 00.90.03 
   Creation Time : Thu Aug 16 22:51:10 2007 
      Raid Level : raid5 
      Array Size : 1220992320 (1164.43 GiB 1250.30 GB) 
   Used Dev Size : 244198464 (232.89 GiB 250.06 GB) 
    Raid Devices : 6 
   Total Devices : 5 
 Preferred Minor : 0 
     Persistence : Superblock is persistent 
 
     Update Time : Thu Aug 16 23:01:46 2007 
           State : clean, degraded 
  Active Devices : 5 
 Working Devices : 5 
  Failed Devices : 0 
   Spare Devices : 0 
 
          Layout : left-asymmetric 
      Chunk Size : 64K 
 
            UUID : 31bd67ad:59721ed7:2e0fde4f:67729963 
          Events : 0.28 
 
     Number   Major   Minor   RaidDevice State 
        0       8       96        0      active sync   /dev/sdg 
        1       8       32        1      active sync   /dev/sdc 
        2       0        0        2      removed 
        3       8       48        3      active sync   /dev/sdd 
        4       8       16        4      active sync   /dev/sdb 
        5       8       80        5      active sync   /dev/sdf 
 
The new disk is definetly clean :

	mdadm -E /dev/sde 
 	mdadm: No md superblock detected on /dev/sde.
   
Seems a-ok, but when i do 
 
	mdadm -a /dev/md0 /dev/sde 
	mdadm: add new device failed for /dev/sde as 6: Invalid argument 
 
I get an error, and the following in the kernel log 

	md: sde has invalid sb, not importing! 
	md: md_import_device returned -22 
 
After this, running mdadm -E /dev/sde again shows the disk now has a 
superblock, but it's still a mistery to me as to why the disk won't get 
imported in the array:

/dev/sde:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 31bd67ad:59721ed7:2e0fde4f:67729963
  Creation Time : Thu Aug 16 22:51:10 2007
     Raid Level : raid5
  Used Dev Size : 244198464 (232.89 GiB 250.06 GB)
     Array Size : 1220992320 (1164.43 GiB 1250.30 GB)
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 0

    Update Time : Thu Aug 16 23:38:08 2007
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 65f5f8c1 - correct
         Events : 0.32

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       64       -1      spare   /dev/sde

   0     0       8       96        0      active sync   /dev/sdg
   1     1       8       32        1      active sync   /dev/sdc
   2     2       0        0        2      faulty removed
   3     3       8       48        3      active sync   /dev/sdd
   4     4       8       16        4      active sync   /dev/sdb
   5     5       8       80        5      active sync   /dev/sdf

No rebuilding happens after this, so i am left with a degraded array.

md0 : active raid5 sdf[5] sdb[4] sdd[3] sdc[1] sdg[0]
      1220992320 blocks level 5, 64k chunk, algorithm 0 [6/5] [UU_UUU]

unused devices: <none> 
   
Any ideas ?

Kind regards
den_RDC
