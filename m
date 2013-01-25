From: William Colls <techlead@stpaulshk.org>
Subject: Not getting anything from mdadm --examine for raid1 array
Date: Fri, 25 Jan 2013 15:15:01 -0500
Message-ID: <5102E7C5.6040900@stpaulshk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The array consists of 2x2Tb disks, each with a single partition filling 
the whole disk.

If I look in /proc/mdstat I see the following information:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid1 sdc[1] sdb[0]
       1953383360 blocks super 1.2 [2/2] [UU]

unused devices: <none>

mdadm --detail /dev/md0 returns the following:

/dev/md0:
         Version : 1.2
   Creation Time : Sat Jan  5 12:39:24 2013
      Raid Level : raid1
      Array Size : 1953383360 (1862.89 GiB 2000.26 GB)
   Used Dev Size : 1953383360 (1862.89 GiB 2000.26 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

     Update Time : Fri Jan 25 06:51:09 2013
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : archangel:0  (local to host archangel)
            UUID : 073d729f:45cbf8f6:01be7bfa:1f7f59da
          Events : 19

     Number   Major   Minor   RaidDevice State
        0       8       16        0      active sync   /dev/sdb
        1       8       32        1      active sync   /dev/sdc


mdadm --examine --scan /dev/md0 returns nothing.

Am I in trouble. If so how bad is the problem, and how best to fix it?

Thanks for your time.

William.



-- 
St. Paul's Anglican Church
20 Young Road
Kanata  Ontarion K2L 1W1

Tel: 613 836 1001
Fax: 613 836 7305
www.stpaulshk.org
