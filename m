From: Hubert Verstraete <hubskml@free.fr>
Subject: mdadm 2.6 creates slow RAID 5 while mdadm 2.5.6 rocks
Date: Fri, 08 Feb 2008 16:25:23 +0100
Message-ID: <47AC7463.7000502@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

My RAID 5 array is running slow.
I've made a lot of test to find out where this issue is laying.
I've come to the conclusion that once the array is created with mdadm 
2.6.x (up to 2.6.4), whatever the kernel you run, whatever the mdadm you 
use to re-assemble the array, the array's performance is very degraded.

Would this be a bug in mdadm 2.6 ?
Are you seeing this issue too ?

Here are the stats made from bonnie:
2.6.18.8_mdadm_2.5.6,4G,,,38656,5,24171,6,,,182130,26,518.9,1,16,1033,3,+++++,+++,861,2,1224,3,+++++,+++,806,3
2.6.18.8_mdadm_2.6.4,4G,,,19191,2,15845,4,,,164907,26,491.9,1,16,697,2,+++++,+++,546,1,710,2,+++++,+++,465,2
2.6.22.6_mdadm_2.5.6,4G,,,49108,8,29441,7,,,174038,21,455.5,1,16,1351,4,+++++,+++,1073,3,1416,5,+++++,+++,696,4
2.6.22.6_mdadm_2.6.4,4G,,,18010,3,16763,4,,,185106,24,421.6,1,16,928,6,+++++,+++,659,3,871,7,+++++,+++,699,3
2.6.24-git17_mdadm_2.5.6,4G,,,126319,24,34342,4,,,79924,0,180.8,0,16,1566,5,+++++,+++,1459,3,1800,4,+++++,+++,1123,2
2.6.24-git17_mdadm_2.6.4,4G,,,24482,4,19717,3,,,79953,0,594.6,2,16,918,3,+++++,+++,715,2,907,3,+++++,+++,763,2

Remarks on the results:
The read performance is not degraded by mdadm 2.6 (but it gets degraded 
when using the newer kernel both with mdadm 2.5.6 and 2.6).
The write performance is affected by mdadm 2.6 and it's very very 
degraded in the 2.6.24 kernel compared to mdadm 2.5.6 (write performance 
on 2.6.24 kernel is 6 times faster!). Block write runs at 24KB/s when 
the array is created with mdadm 2.6 and 126KB/s when created with mdadm 
2.5.6!
Even when I use mdadm 2.5.6 to assemble an array created with mdadm 2.6 
the results are still bad.

The test environment:
4 disks
64K chunk
superblock 1.0 (same symptoms with 0.9)
XFS
no optimization

Hardware: tried on several computers with different CPU, RAM, SATA 
controller...

More details on the conf:

/dev/md_d0:
         Version : 01.00.03
   Creation Time : Fri Feb  8 14:13:51 2008
      Raid Level : raid5
      Array Size : 732595200 (698.66 GiB 750.18 GB)
     Device Size : 488396800 (232.89 GiB 250.06 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Fri Feb  8 14:42:57 2008
           State : active
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            Name : localhost:d0  (local to host localhost)
            UUID : 93ffc9ae:b33311aa:445e7821:cc7487ec
          Events : 2

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc
        3       8       48        3      active sync   /dev/sdd

# xfs_info /mnt
meta-data=/dev/md_d0p1  isize=256    agcount=32, agsize=5723399 blks
          =              sectsz=512   attr=0
data     =              bsize=4096   blocks=183148768, imaxpct=25
          =              sunit=0      swidth=0 blks, unwritten=1
naming   =version 2     bsize=4096
log      =internal      bsize=4096   blocks=32768, version=1
          =              sectsz=512   sunit=0 blks
realtime =none          extsz=65536  blocks=0, rtextents=0

Thanks for the help.
Hubert
