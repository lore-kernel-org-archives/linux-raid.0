From: mtice <mjtice@gmail.com>
Subject: Removed two drives (still valid and working) from raid-5 and need to add them back in.
Date: Sat, 12 Mar 2011 12:12:49 -0700
Message-ID: <837074B9-F2A5-471B-BAD1-6A92249095FB@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 4 disk raid 5 array on my Ubuntu 10.10 box. They are /dev/sd[c,d,e,f]. Smartctl started notifying me that /dev/sde had some bad sectors and the number of errors was increasing each day. To mitigate this I decided to buy a new drive and replace it.

I failed /dev/sde via mdadm:

mdadm --manage /dev/md0 --fail /dev/sde
mdadm --manage /dev/md0 --remove

I pulled the drive from the enclosure . . . and found it was the wrong drive (should have been the next drive down . . .). I quickly pushed the drive back in and found that the system renamed the device (/dev/sdh).  
I then tried to add that drive back in (this time with the different dev name):

mdadm --manage /dev/md0 --re-add /dev/sdh
(I don't have the output of --detail for this step.)

I rebooted and the original dev name returned (/dev/sdd).

The problem is now I have two drives in my raid 5 which of course won't start: 

mdadm -As /dev/md0
mdadm: /dev/md0 assembled from 2 drives and 2 spares - not enough to start the array.


Although, I can get it running with:
dadm --incremental --run --scan

So my question is how can I add these two still-valid spares back into my array?

Here is the output of mdadm --detail /dev/md0:

/dev/md0:
        Version : 00.90
  Creation Time : Thu May 27 15:35:56 2010
     Raid Level : raid5
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Mar 11 15:53:35 2011
          State : active, degraded, Not Started
 Active Devices : 2
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 11c1cdd8:60ec9a90:2e29483d:f114274d (local to host storage)
         Events : 0.43200

    Number   Major   Minor   RaidDevice State
       0       8       80        0      active sync   /dev/sdf
       1       0        0        1      removed
       2       0        0        2      removed
       3       8       32        3      active sync   /dev/sdc

       4       8       64        -      spare   /dev/sde
       5       8       48        -      spare   /dev/sdd


I appreciate any help.

Matt