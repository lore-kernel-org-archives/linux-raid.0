From: Stephane Thiell <sthiell@stanford.edu>
Subject: mismatch_cnt > 0 during initial sync?
Date: Mon, 24 Apr 2017 22:01:19 +0000
Message-ID: <9A8A3C34-EED0-42FF-B631-7AD1D6EAF9A2@stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <5CFF72EFD8ACDE43BADA75D4DE679FBE@namprd02.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi all,

Is it normal to get any mismatch_cnt > 0 during the initial sync? I just cr=
eated a few new new raid6 volumes, and one of them is showing an increasing=
 number of mismatch_cnt during its initial resync. Nothing is visible in th=
e console nor after a smart short test (I also started a long test just in =
case).


$ mdadm --detail /dev/md7
/dev/md7:
        Version : 1.2
  Creation Time : Mon Apr 24 10:07:18 2017
     Raid Level : raid6
     Array Size : 62511163904 (59615.29 GiB 64011.43 GB)
  Used Dev Size : 7813895488 (7451.91 GiB 8001.43 GB)
   Raid Devices : 10
  Total Devices : 10
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Apr 24 14:52:12 2017
          State : clean, resyncing=20
 Active Devices : 10
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

  Resync Status : 24% complete

           Name : oak-io1-s2:7  (local to host oak-io1-s2)
           UUID : 6ece9d71:a97f9497:4612ed73:44dfdc0a
         Events : 3308

    Number   Major   Minor   RaidDevice State
       0     253       62        0      active sync   /dev/dm-62
       1     253       63        1      active sync   /dev/dm-63
       2     253       72        2      active sync   /dev/dm-72
       3     253       75        3      active sync   /dev/dm-75
       4     253       89        4      active sync   /dev/dm-89
       5     253       87        5      active sync   /dev/dm-87
       6     253      119        6      active sync   /dev/dm-119
       7     253       97        7      active sync   /dev/dm-97
       8     253      103        8      active sync   /dev/dm-103
       9     253      107        9      active sync   /dev/dm-107

$ cat /sys/block/md7/md/sync_completed
3795284824 / 15627790976

$ cat /sys/block/md7/md/mismatch_cnt=20
3424

versions:
  mdadm-3.4-14.el7_3.1.x86_64
  CentOS7 (3.10.0-514.10.2.el7_lustre.x86_64)

Thanks!

Stephan=

