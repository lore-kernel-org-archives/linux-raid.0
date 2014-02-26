From: Charles Polisher <cpolish@surewest.net>
Subject: Reshape RAID10 -> RAID1
Date: Tue, 25 Feb 2014 22:05:32 -0800
Message-ID: <20140226060532.GA18630@kevin.peecee3.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I hope to reshape a RAID10 (near,2) with 2 failed and physically
removed members [_U_U] into a RAID1 hopefully [UU], for the
benefit of seeing a healthy status.

Is following proposed invocation correct?

   mdadm --grow /dev/md2 --level=1

Details:

root@mencius $ mdadm --query --verbose --detail /dev/md2
/dev/md2:
        Version : 1.1
  Creation Time : Fri Jul 15 22:56:53 2011
     Raid Level : raid10
     Array Size : 1944916992 (1854.82 GiB 1991.59 GB)
  Used Dev Size : 972458496 (927.41 GiB 995.80 GB)
   Raid Devices : 4
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Feb 25 22:00:46 2014
          State : active, degraded 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 512K

           Name : localhost.localdomain:2
           UUID : 971ee8b2:8d980355:0e5dfae9:c8bccd89
         Events : 5326341

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       19        1      active sync   /dev/sdb3
       2       0        0        2      removed
       3       8        3        3      active sync   /dev/sda3
root@mencius $ uname -a
Linux mencius 2.6.32-358.18.1.el6.centos.plus.x86_64 #1 SMP Wed Aug 28 16:14:04 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
root@mencius $ mdadm --version
mdadm - v3.2.6 - 25th October 2012


Thanks,
-- 
Charles Polisher

