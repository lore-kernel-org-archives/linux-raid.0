From: Bruno Costacurta <pubmb02@skynet.be>
Subject: Doubts about array size
Date: Tue, 17 Oct 2006 22:21:48 +0200
Message-ID: <200610172221.49080.pubmb02@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I built my first RAID with 2 disks. 

Array looks active (please see hereafter) but I'm confusing about size : 
having 2 disks of 160-Gb each I expect a size of 160-Gb (correct ?) but array 
size seems around 103-Gb.
I also received a 'Disk /dev/md0 doesn't contain a valid partition table'

Please find hereafer outputs for commands of fdisk and mdadm :

'fdisk -l' return: 

-start-
Disk /dev/sdb: 163.9 GB, 163928604672 bytes
255 heads, 63 sectors/track, 19929 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       19453   156256191   fd  Linux raid autodetect

Disk /dev/sdc: 160.0 GB, 160041885696 bytes
255 heads, 63 sectors/track, 19457 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       19453   156256191   fd  Linux raid autodetect

Disk /dev/md0: 106 MB, 106823680 bytes
2 heads, 4 sectors/track, 26080 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

Disk /dev/md0 doesn't contain a valid partition table
-end-



'mdadm --detail /dev/md0'  :
-start-
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Oct 17 21:26:43 2006
     Raid Level : raid1
     Array Size : 104320 (101.89 MiB 106.82 MB)
    Device Size : 104320 (101.89 MiB 106.82 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Oct 17 21:32:33 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 39877482:3daad5f3:a9b54997:0c328c24
         Events : 0.24

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
-end-


Cheers for help and advice.
Bruno

