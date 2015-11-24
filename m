From: Marco De Vitis <starless@spin.it>
Subject: mdadm and size differences
Date: Tue, 24 Nov 2015 11:32:33 +0100
Message-ID: <n31ec1$ebi$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I cannot understand a difference in size I can see on an old Debian 5.0 
machine, maybe I'm just missing something obvious.

/dev/sdd is partitioned as follows, and /dev/sdf is exactly the same:

> #>fdisk -l /dev/sdd
>
> Disk /dev/sdd: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x000901d8
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdd1               1          24      192748+  83  Linux
> /dev/sdd2              25       60801   488191252+   5  Extended
> /dev/sdd5              25         632     4883728+  83  Linux
> /dev/sdd6             633        2982    18876343+  83  Linux
> /dev/sdd7            2983        4199     9775521   83  Linux
> /dev/sdd8            4200        4807     4883728+  83  Linux
> /dev/sdd9            4808        5173     2939863+  82  Linux swap / Solaris
> /dev/sdd10           5174       31281   209712478+  83  Linux

You can see that sdd6 is twice the size of sdd7.
cfdisk reports sizes of around 20 GB and 10 GB:
     sdd6 -> 19329.41
     sdd7 -> 10010.17

All partitions in these two identical drives are configured as RAID 1 
using mdadm, but the md devices associated to sdd6/sdf6 and sdd7/sdf7 
are both reported to be 10 GB in size, as can be seen from the mdadm 
output below.

Why?

Thanks for any info.

> #>mdadm -vv --detail /dev/md2
> /dev/md2:
>         Version : 00.90
>   Creation Time : Thu Feb 22 16:18:11 2007
>      Raid Level : raid1
>      Array Size : 9767424 (9.31 GiB 10.00 GB)
>   Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Nov 23 14:19:23 2015
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>            UUID : 5582dad7:7ac89883:0c2b9e1d:5009dd35
>          Events : 0.69228
>
>     Number   Major   Minor   RaidDevice State
>        0       8       54        0      active sync   /dev/sdd6
>        1       8       86        1      active sync   /dev/sdf6
>
> #>mdadm -vv --detail /dev/md3
> /dev/md3:
>         Version : 00.90
>   Creation Time : Thu Feb 22 16:18:54 2007
>      Raid Level : raid1
>      Array Size : 9767424 (9.31 GiB 10.00 GB)
>   Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 3
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Nov 23 14:19:27 2015
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>            UUID : e44836cf:6340f7fa:52fb3562:a78d4dbb
>          Events : 0.187630
>
>     Number   Major   Minor   RaidDevice State
>        0       8       55        0      active sync   /dev/sdd7
>        1       8       87        1      active sync   /dev/sdf7

-- 
Ciao,
   Marco.

