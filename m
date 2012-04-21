From: Ken Gunderson <kgunders@teamcool.net>
Subject: md raid recovery - perplexed
Date: Fri, 20 Apr 2012 18:48:56 -0600
Message-ID: <1334969336.14947.23.camel@hermes>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello List:

I've created some arrays.  For example, md2 is RAID1 created with gpt
based partitions  /dev/sd[ab]1

# mdadm --misc --detail /dev/md2

/dev/md2:
        Version : 1.0
  Creation Time : Thu Apr 19 15:56:18 2012
     Raid Level : raid1
     Array Size : 262132 (256.03 MiB 268.42 MB)
  Used Dev Size : 262132 (256.03 MiB 268.42 MB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Fri Apr 20 09:08:11 2012
          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : archiso:2
           UUID : e3a5c30e:3fb61039:397992ff:6cc70600
         Events : 17

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1


Okay, great, that works.  However, I am not able to recover from
simulated failure.

# mdadm /dev/md2 --fail /dev/sdb1

# mdadm /dev/md2 --misc --detail

/dev/md2:
        Version : 1.0
  Creation Time : Thu Apr 19 15:56:18 2012
     Raid Level : raid1
     Array Size : 262132 (256.03 MiB 268.42 MB)
  Used Dev Size : 262132 (256.03 MiB 268.42 MB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Fri Apr 20 15:40:10 2012
          State : clean, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           Name : archiso:2
           UUID : e3a5c30e:3fb61039:397992ff:6cc70600
         Events : 20

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       0        0        1      removed

       1       8       17        -      faulty spare   /dev/sdb1



Followed by

# mdadm /dev/md2 --remove /dev/sdb1

/dev/md2:
        Version : 1.0
  Creation Time : Thu Apr 19 15:56:18 2012
     Raid Level : raid1
     Array Size : 262132 (256.03 MiB 268.42 MB)
  Used Dev Size : 262132 (256.03 MiB 268.42 MB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Fri Apr 20 15:59:52 2012
          State : clean, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : archiso:2
           UUID : e3a5c30e:3fb61039:397992ff:6cc70600
         Events : 31

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       0        0        1      removed


I should then be able to re-add sdb1, no?

# mdadm /dev/md2 --re-add /dev/sdb1

mdadm: --re-add for /dev/sdb1 to /dev/md2 is not possible

Since man mdadm explicitly provides following as example:

"mdadm /dev/md0 -f /dev/hda1 -r /dev/hda1 -a /dev/hda1"

Let's try just adding it instead of re-adding

# mdadm /dev/md2 -a /dev/sdb1
mdadm: /dev/sdb1 reports being an active member for /dev/md2, but a --re-add fails.
mdadm: not performing --add as that would convert /dev/sdb1 in to a spare.
mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdb1" first.

I am perplexed as to why might this be?  I must be missing something
pretty basic here, else I can provide additional detail as require.

Thanks for your help-- Ken

-- 
Ken Gunderson <kgunders@teamcool.net>

