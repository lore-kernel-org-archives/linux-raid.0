From: Andreas Jung <lists@zopyx.com>
Subject: mdadm: created raid has one disc more than configured
Date: Sun, 18 Apr 2004 12:33:56 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2147483647.1082291636@[192.168.0.105]>
Reply-To: Andreas Jung <lists@zopyx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I created a raid devices using:

mdadm --create /dev/md0 --level 5 -3 /dev/hdc1 /dev/hde1 /dev/hdf1

mdadm --detail /dev/md0 gives me:

/dev/md0:
        Version : 00.90.00
  Creation Time : Sun Apr 18 11:36:04 2004
     Raid Level : raid5
     Array Size : 117231104 (111.80 GiB 120.04 GB)
    Device Size : 58615552 (55.90 GiB 60.02 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Apr 18 11:36:04 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 80% complete

    Number   Major   Minor   RaidDevice State
       0      22        1        0      active sync   /dev/hdc1
       1      33        1        1      active sync   /dev/hde1
       2       0        0        2      faulty
       3      33       65        3      spare   /dev/hdf1
           UUID : 84cf502e:9d757c6a:1855fa04:5c4e9bcd
         Events : 0.1

The output say that I have four devices although only three were
specified at creation time.

Any ideas? (using mdadm 1.5, RH 9,latest Kernel).

-aj


-- 

Andreas Jung
--------------------------------
www.zopyx.com Software-Entwicklung und Consulting Andreas Jung
