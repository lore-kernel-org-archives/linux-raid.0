From: Andrew Burgess <aab@cichlid.com>
Subject: raid6 resync: patch "fix raid6 resync check/repair code" working?
Date: Fri, 24 Feb 2006 09:21:10 -0800
Message-ID: <200602241721.k1OHLAOs014146@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had a bad sector on a raid6 member disk, fixed it with dd and then
decided to bite the bullet and upgrade to 2.6.16rc4 to get the better
bad sector error handling.

I note this kernel has the "fix raid6 resync check/repair code" patch.
Since my disk was out of the array briefly I expected to see
reduced writes during resync but I am not seeing this. In fact,
the syncing disk doesnt get read at all!

Here's an iostat output:

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sdd              43.58      8989.34         4.25   12172822       5752
sdh              43.01      8988.78         3.17   12172070       4288
sdi              46.17      8982.13         1.01   12163062       1368
sdj              48.42      8989.03         3.23   12172408       4376
sdk              46.39         2.56      8963.30       3470   12137568
sdo              50.18      8986.71         2.98   12169268       4032
sds              50.71      8992.34         3.85   12176890       5218
sdt              48.61      8989.37         4.22   12172868       5720

(I've deleted the uninteresting disks)

Is it a pilot error? I added the missing disk (sdk) to the array
and mdadm said 're-adding' IIRC. I have no bitmaps yet in case that matters.

/dev/md1:
        Version : 00.90.03
  Creation Time : Mon Dec  5 08:38:36 2005
     Raid Level : raid6
     Array Size : 1757815296 (1676.38 GiB 1800.00 GB)
    Device Size : 292969216 (279.40 GiB 300.00 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Feb 24 09:12:32 2006
          State : clean, degraded, recovering
 Active Devices : 7
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 1

     Chunk Size : 128K

 Rebuild Status : 2% complete

           UUID : 628e4bb1:71f6dbea:5b4cd026:7ac5282f
         Events : 0.2285138

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1      65       49        1      active sync   /dev/sdt1
       2      65       35        2      active sync   /dev/sds3
       8       8      161        3      spare rebuilding   /dev/sdk1
       4       8      225        4      active sync   /dev/sdo1
       5       8      113        5      active sync   /dev/sdh1
       6       8      145        6      active sync   /dev/sdj1
       7       9        4        7      active sync   /dev/md4

