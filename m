From: "Sean Hildebrand" <silverwraithii@gmail.com>
Subject: RAID not auto-assembling?
Date: Tue, 26 Aug 2008 01:33:19 -0400
Message-ID: <fa037c550808252233u175c7ca8g37ff6fa0c214e12f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a 3-disk RAID5, with a consistent superblock, and partitions
are all 0xFD.

The array isn't recognized by mdadm at boot or when I manually ask it
to assemble /dev/md0 without specifying partitions. The three
partitions are always /dev/sd[abc]1.

Output of -D /dev/md0 is:

/dev/md0:
        Version : 00.90.03
  Creation Time : Sun Jun 15 22:02:57 2008
     Raid Level : raid5
     Array Size : 1465143808 (1397.27 GiB 1500.31 GB)
  Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Aug 26 01:03:31 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : eaa2f834:729baa7b:5b2687e9:8461c801
         Events : 0.512

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
