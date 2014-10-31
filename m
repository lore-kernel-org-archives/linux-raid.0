From: Vince <stuff@hagenhuegel.de>
Subject: Raid5 drive fail during grow and no backup
Date: Fri, 31 Oct 2014 13:34:24 +0000 (UTC)
Message-ID: <loom.20141031T141939-473@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

got a drive failure (bad block) during Raid5 grow (4x3TB -> 5x3TB).
Well... i don't have a backup file :/
Mdadm shows 1 drive as removed.

All 4 'good' drives are in the same reshape pos'n.

Any idea how to finish the reshape process? Or get the array back?



mdadm --examine /dev/sdb

/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 14e9502c:4d51fb5c:a4f2e4d1:2b6a157e
           Name : MyRaid:0
  Creation Time : Mon Mar 18 12:52:00 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 705995da:442a6d8d:783abc2f:9d88e715

  Reshape pos'n : 9243070464 (8814.88 GiB 9464.90 GB)
  Delta Devices : 1 (4->5)

    Update Time : Fri Oct 31 13:21:48 2014
       Checksum : 82973929 - correct
         Events : 18837

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : .AAAA ('A' == active, '.' == missing)




mdadm -detail:

/dev/md0:
        Version : 1.2
  Creation Time : Mon Mar 18 12:52:00 2013
     Raid Level : raid5
  Used Dev Size : -1
   Raid Devices : 5
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Fri Oct 31 13:21:48 2014
          State : active, degraded, Not Started 
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

  Delta Devices : 1, (4->5)

           Name : MyRaid:0
           UUID : 14e9502c:4d51fb5c:a4f2e4d1:2b6a157e
         Events : 18837

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       5       8       48        1      active sync   /dev/sdd
       3       8       32        2      active sync   /dev/sdc
       4       8       80        3      active sync   /dev/sdf
       6       8       16        4      active sync   /dev/sdb


mdadm -A scan -v:

mdadm: looking for devices for /dev/md/0
mdadm: /dev/sdf is identified as a member of /dev/md/0, slot 3.
mdadm: /dev/sdd is identified as a member of /dev/md/0, slot 1.
mdadm: /dev/sdc is identified as a member of /dev/md/0, slot 2.
mdadm: /dev/sdb is identified as a member of /dev/md/0, slot 4.
mdadm:/dev/md/0 has an active reshape - checking if critical section needs
to be restored
mdadm: too-old timestamp on backup-metadata on device-4
mdadm: no uptodate device for slot 0 of /dev/md/0
mdadm: added /dev/sdc to /dev/md/0 as 2
mdadm: added /dev/sdf to /dev/md/0 as 3
mdadm: added /dev/sdb to /dev/md/0 as 4
mdadm: added /dev/sdd to /dev/md/0 as 1
mdadm: /dev/md/0 assembled from 4 drives - not enough to start the array
while not clean - consider --force.




