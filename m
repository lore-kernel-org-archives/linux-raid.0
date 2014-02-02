From: Marc MERLIN <marc@merlins.org>
Subject: Intent Bitmap size and performance
Date: Sat, 1 Feb 2014 16:39:15 -0800
Message-ID: <20140202003915.GB25441@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was reading
http://blog.liw.fi/posts/write-intent-bitmaps/
which warns that intent bitmaps kill performance if they are too small

The mdadm man page does tell me how I can set the intent bitmap size,
but I can't tell what size I have or what is applied by default if you
don't have the size option and create the intent bitmap with --grow

First, I did: mdadm --grow --bitmap=internal /dev/md7

Then, I have:
gargamel:/mnt/btrfs_pool1# mdadm --detail /dev/md7
/dev/md7:
        Version : 1.2
  Creation Time : Thu Mar 25 20:15:00 2010
     Raid Level : raid5
     Array Size : 7814045696 (7452.05 GiB 8001.58 GB)
  Used Dev Size : 1953511424 (1863.01 GiB 2000.40 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sat Feb  1 16:08:56 2014
          State : active 
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : gargamel.svh.merlins.org:7  (local to host gargamel.svh.merlins.org)
           UUID : 5884576b:0e402a5d:8629093c:ec020760
         Events : 38030

    Number   Major   Minor   RaidDevice State
       6       8       81        0      active sync   /dev/sdf1
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1
       3       8        1        3      active sync   /dev/sda1
       7       8       17        4      active sync   /dev/sdb1


How can I tell I got the size for my array size?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
