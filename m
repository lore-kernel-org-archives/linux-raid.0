From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Enlarging device of linear array
Date: Sat, 8 Jun 2013 20:18:10 +0200
Message-ID: <20130608201810.26c19641@hoferr-x61s.hofer.rummelring>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Stan Hoeppner <stan@hardwarefreak.com>
List-Id: linux-raid.ids

Dear Stan and linux-raid list

My home server with a linear raid (md0) containing three raid5 (md1,
md2, md3) is still working wonderfully. Thanks again Stan!

Now I'm planning to add a fourth raid5 to the linear array.


Because the case (Norco RPC-4020 [1]) will be full after I will have
added these four disks, I wondered if it is possible to replace four
disks of md2 (I have added the details of all devices below) with
bigger ones?

Maybe by replacing sde, rebuilding md2; replacing sdf, rebuilding
md2; ...; replacing sdh, rebuilding md2.
Then enlarging md2.

Due to [2] I'm only able to enlarge the last device (md3 for now, md4
after filling the last slots).
Maybe I should use the extra space I'm going to add now to replace the
linear array with an LVM containing md raid5 devices:

With the new disks I could create a new raid5 md4 and a logical volume
lv_raid with md4 as its only physical volume.
Then I copy the data from md3 to lv_raid, remove md3 from md0, shrink
md0, extebd lv_raid with md3 and repeat that for md2 and md1.

Is this possible and a good idea?

The reason why I'm bothering is that some time ago a disk of my old NAS
(Netgear ReadyNAS NV+) failed and I had some problems to find the same
model of the disk but it was some sectors smaller and the NAS couldn't
rebuild the raid.

If in some years one of the oldest 1.5 TB disks of md2 or any other
fails, I could replace it with a bigger one and at the same time the
other disks of the same device as well and get additional space?


Best
Ramon


[1] http://www.norcotek.com/item_detail.php?categoryid=1&modelno=RPC-4020#order_info
[2] http://linux.die.net/EVMSUG/resizemdreg.html


/dev/md0:
        Version : 1.2
  Creation Time : Fri Jun 22 16:24:29 2012
     Raid Level : linear
     Array Size : 16116489216 (15369.88 GiB 16503.28 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Sun Aug 12 11:00:53 2012
          State : clean 
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

       Rounding : 0K

           Name : media-server:0  (local to host media-server)
           UUID : 0adecee6:ced12699:c6ed6794:0115086e
         Events : 1

    Number   Major   Minor   RaidDevice State
       0       9        1        0      active sync   /dev/md1
       1       9        2        1      active sync   /dev/md2
       2       9        3        2      active sync   /dev/md3


/dev/md1:
        Version : 1.2
  Creation Time : Fri Jun 22 16:21:40 2012
     Raid Level : raid5
     Array Size : 5860540032 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 1953513344 (1863.02 GiB 2000.40 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sat Jun  8 15:11:10 2013
          State : clean 
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : media-server:1  (local to host media-server)
           UUID : d0632cd1:12450da5:6e71fda9:3025c802
         Events : 50

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd


/dev/md2:
        Version : 1.2
  Creation Time : Sun Jun 17 20:08:48 2012
     Raid Level : raid5
     Array Size : 4395412224 (4191.79 GiB 4500.90 GB)
  Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sat Jun  8 14:04:24 2013
          State : clean 
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : media-server:2  (local to host media-server)
           UUID : 1c74447b:33070712:cfcfa5af:cbfea660
         Events : 2287

    Number   Major   Minor   RaidDevice State
       0       8       64        0      active sync   /dev/sde
       1       8       80        1      active sync   /dev/sdf
       2       8       96        2      active sync   /dev/sdg
       4       8      112        3      active sync   /dev/sdh


/dev/md3:
        Version : 1.2
  Creation Time : Sat Aug 11 16:39:30 2012
     Raid Level : raid5
     Array Size : 5860540032 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 1953513344 (1863.02 GiB 2000.40 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sat Jun  8 15:10:10 2013
          State : clean 
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : media-server:3  (local to host media-server)
           UUID : 0fd34415:44344a79:62bcdd9d:b24e84bb
         Events : 51

    Number   Major   Minor   RaidDevice State
       0       8      144        0      active sync   /dev/sdj
       1       8      160        1      active sync   /dev/sdk
       2       8      176        2      active sync   /dev/sdl
       4       8      192        3      active sync   /dev/sdm
