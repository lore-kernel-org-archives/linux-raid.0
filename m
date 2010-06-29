From: Shaochun Wang <scwang@ios.ac.cn>
Subject: Write-intent bitmap decreases or increase performance of RAID5?
Date: Wed, 30 Jun 2010 04:11:54 +0800
Message-ID: <20100629201153.GA13018@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From what I read from the internet, write-intent bitmap decreases raid
performance and provides more stability. But in my situation, it also
increases raid performance dramatically!

My RAID5 write speed without write-intent bitmap is 90MB/s, and is
increased to 200MB/s after enabling internal write-intent bitmap. I
use ext4 filesystem on this raid array. The following is my RAID5
array information:

# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.0
  Creation Time : Mon Nov 16 02:46:50 2009
     Raid Level : raid5
     Array Size : 10255968576 (9780.85 GiB 10502.11 GB)
  Used Dev Size : 1465138368 (1397.26 GiB 1500.30 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Jun 30 03:51:56 2010
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : AOpen:00
           UUID : abb2242c:6a250d29:df65e52b:426f4ed9
         Events : 405636

    Number   Major   Minor   RaidDevice State
       4       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1
       5       8       81        4      active sync   /dev/sdf1
       6       8       97        5      active sync   /dev/sdg1
       7       8      113        6      active sync   /dev/sdh1
       8       8      129        7      active sync   /dev/sdi1

-- 
Shaochun Wang <scwang@ios.ac.cn>

Jabber: fungusw@jabber.org
