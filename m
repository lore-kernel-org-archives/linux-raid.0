From: Bob Hillegas <bobhillegas@houston.rr.com>
Subject: How to stop raid prior to shutdown...
Date: Mon, 23 Aug 2004 23:23:32 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1093321412.2221.101.camel@south.rosestar.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry for newbie question. Software-RAID-HOWTO said the following
would stop an array for shutdown. mdadm complains the array is still 
in use. Why? 

mdadm --stop --scan

md: md0 still in use.
mdadm: fail to stop array /dev/md0: Device or resource busy

/dev/md0 is not mounted. 
There is no filesystem built on the partitions yet.

Just mdadm --create --verbose /dev/md0 --level=raid1 --raid-devices=2
           /dev/sda1 /dev/sdb1

cat /proc/mdstat

Personalities : [raid1] 
md0 : active raid1 sdb1[1] sda1[0]
      71826496 blocks [2/2] [UU]
      
unused devices: <none>

mdadm --query --detail /dev/md0

/dev/md0:
        Version : 00.90.01
  Creation Time : Mon Aug 23 20:54:44 2004
     Raid Level : raid1
     Array Size : 71826496 (68.50 GiB 73.55 GB)
    Device Size : 71826496 (68.50 GiB 73.55 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Aug 23 21:16:09 2004
          State : clean, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
           UUID : 4b2b674d:2b170d5e:3fbbf170:373f1bee
         Events : 0.2
Thanks, BobH
-- 
------------------------------
Bob Hillegas
bobhillegas@houston.rr.com

