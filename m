From: <senthilkumar.muthukalai@wipro.com>
Subject: Growing Linear RAID
Date: Wed, 9 Dec 2009 20:31:54 +0530
Message-ID: <8338BD137FF1B64EB341218BD702985E02C8C03B@BLR-EC-MBX03.wipro.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am trying to add a disk to a Linear Raid which was created with 2
disks.
We use linux-2.6.18 and mdadm-2.6.4.
I guess these support the above mentioned disk addition.
But I get the error quoted below.
Could you pls guide me?

Observations
------------

[root@NAS00226b1755a0 ~]# mdadm /dev/md0 --grow -n 3 /dev/sata3 
mdadm: --size, --raiddisks, and --add are exclusing in --grow mode
[root@NAS00226b1755a0 ~]# 
[root@NAS00226b1755a0 ~]# 
[root@NAS00226b1755a0 ~]# mdadm /dev/md0 --grow -n 3            
mdadm: linear array /dev/md0 cannot be reshaped.
[root@NAS00226b1755a0 ~]# 
[root@NAS00226b1755a0 ~]# 
[root@NAS00226b1755a0 ~]# mdadm /dev/md0 --grow --add /dev/sata3     
mdadm: Cannot add new disk to this array
[root@NAS00226b1755a0 ~]# 
[root@NAS00226b1755a0 ~]# 
[root@NAS00226b1755a0 ~]# mdadm /dev/md0 --add /dev/sata3
mdadm: add new device failed for /dev/sata3 as 2: No space left on
device
[root@NAS00226b1755a0 ~]# 
[root@NAS00226b1755a0 ~]# 
[root@NAS00226b1755a0 ~]# mdadm /dev/md0 --grow -n 3 --add /dev/sata3
mdadm: --size, --raiddisks, and --add are exclusing in --grow mode
[root@NAS00226b1755a0 ~]# 
[root@NAS00226b1755a0 ~]# 
[root@NAS00226b1755a0 ~]# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] 
md0 : active linear sdb[1] sda[0]
      444265856 blocks super 1.2 32k rounding
      
unused devices: <none>
[root@NAS00226b1755a0 ~]# mdadm -D /dev/md0 
/dev/md0:
        Version : 01.02.03
  Creation Time : Wed Dec  9 03:02:50 2009
     Raid Level : linear
     Array Size : 444265856 (423.68 GiB 454.93 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Dec  9 03:02:50 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

       Rounding : 32K

           Name : 0
           UUID : 041dce1e:adafc8da:525455fe:5a9d950f
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sata1
       1       8       16        1      active sync   /dev/sata2

Thanks,
Senthil M
