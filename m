From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: why a bitmap file never changes?
Date: Wed, 29 Aug 2007 10:45:28 +0200
Message-ID: <46D53228.4000400@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm just synchronizing a local LVM volume to the remote one using md and 
a bitmap file, as suggested by Neil Brown ("how to synchronize two 
devices (RAID-1, but not really?)" thread from 15 May 2007):


mdadm --build /dev/md11 --level=1 --bitmap=/root/backup-bitmap \
--write-behind --raid-disks=2 /dev/san1/backup \
--write-mostly /dev/iscsi/....../part


Certainly, it takes a while to complete this operation.

I noticed that the bitmap file never changes as the devices are being 
synced - md5sum stays always the same, no matter if resync progress was 
10, 30, or 90%:

# md5sum /root/backup-bitmap
e8e0c4a8424dfd4d487b8facd231ce76  /root/backup-bitmap

# ls -l /root/backup-bitmap
-rw-r--r-- 1 root root 80676 2007-08-27 18:35 /root/backup-bitmap

The date of the file is the date of creation of this array, and as I 
look inside, it's basically almost empty. When looking in a hex editor, 
zeroes (+bitm etc.)at the beginning, and than FF to the end.


Is it normal?


# mdadm -D /dev/md11
/dev/md11:
         Version : 00.90.03
   Creation Time : Mon Aug 27 18:35:32 2007
      Raid Level : raid1
      Array Size : 658800640 (628.28 GiB 674.61 GB)
     Device Size : 658800640 (628.28 GiB 674.61 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 11
     Persistence : Superblock is not persistent

   Intent Bitmap : /root/backup-bitmap

     Update Time : Mon Aug 27 18:39:22 2007
           State : active, resyncing
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

  Rebuild Status : 91% complete

     Number   Major   Minor   RaidDevice State
        0     254       47        0      active sync   /dev/dm-47
        1       8       48        1      active sync writemostly   /dev/sdd


# cat /proc/mdstat
Personalities : [raid1]
md11 : active raid1 sdd[1](W) dm-47[0]
       658800640 blocks super non-persistent [2/2] [UU]
       [==================>..]  resync = 91.8% (605314368/658800640) 
finish=65.6min speed=13584K/sec
       bitmap: 315/315 pages [1260KB], 1024KB chunk, file: 
/root/backup-bitmap




-- 
Tomasz Chmielewski
http://wpkg.org

