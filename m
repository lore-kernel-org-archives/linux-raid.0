From: "Steve Macica" <macica@prospecteng.com>
Subject: Degraded Raid 5 Assembles incorrectly(maybe), will not mount
Date: Thu, 28 Mar 2013 18:39:25 +0000
Message-ID: <W9578124347167971364495965@atl4webmail34>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Linux-Raid, 


I have a degraded Raid 5 that I can't mount. I think it may be assembling in the wrong order. I've tryed stopping the array and reassembling but it does not work. The data presented below is taken after a system reboot. I'm at the point where I think I need use the creat command on a dregraded system(which I assume will preserve the data) but I'm hoping there may be less drastick things that can be tried first. Any suggestions??

Thanks in advance. 


History:
Had an Ubuntu 8.10 system working with a Raid 5 system consisting of four HDDs and comfigured with mdadm. I lost one of the drives in the Raid. The system continued to work in degraded mode.  I had not recovered or added a new drive to the Raid5 yet and lost the OS drive(which in this case is a completely different HDD). I loaded Ubuntu 12.10 on a new drive and  I can not mount the degraded Raid 5 array(missing one drive). 


sudo mount /dev/md0 raidmount
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so



/proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10] 
md0 : active raid5 sdc1[2] sdb1[3] sda1[0]
      1465151808 blocks level 5, 32k chunk, algorithm 2 [4/3] [U_UU]
      
unused devices: <none>

mdadm -Es
ARRAY /dev/md0 UUID=d2647e99:e42e221e:9e66cfca:65ac10b8

mdadm -E /dev/sd[abc]1
/dev/sda1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d2647e99:e42e221e:9e66cfca:65ac10b8
  Creation Time : Sun Mar  8 07:54:23 2009
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 1465151808 (1397.28 GiB 1500.32 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Thu Mar 28 07:47:57 2013
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 1bf6a90a - correct
         Events : 32498

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       17        3      active sync   /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d2647e99:e42e221e:9e66cfca:65ac10b8
  Creation Time : Sun Mar  8 07:54:23 2009
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 1465151808 (1397.28 GiB 1500.32 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Thu Mar 28 07:47:57 2013
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 1bf6a920 - correct
         Events : 32498

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     3       8       17        3      active sync   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       17        3      active sync   /dev/sdb1
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d2647e99:e42e221e:9e66cfca:65ac10b8
  Creation Time : Sun Mar  8 07:54:23 2009
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 1465151808 (1397.28 GiB 1500.32 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Thu Mar 28 07:47:57 2013
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 1bf6a92e - correct
         Events : 32498

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       17        3      active sync   /dev/sdb1


admin0@precise64ubuntu:~$ sudo fdisk -ls

Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x3975b426

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1              63   976768064   488384001   da  Non-FS data

Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x3975b458

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              63   976768064   488384001   da  Non-FS data

Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00098106

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1              63  3907024064  1953512001   83  Linux
Partition 1 does not start on physical sector boundary.

Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x0002504f

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0005344a

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1   *        2048      292863      145408   83  Linux
/dev/sde2          294910  1953523711   976614401    5  Extended
/dev/sde5          294912      331775       18432   82  Linux swap / Solaris
/dev/sde6          333824    19863551     9764864   83  Linux
/dev/sde7        19865600    39395327     9764864   83  Linux
/dev/sde8        39397376    41349119      975872   83  Linux
/dev/sde9        41351168    80410623    19529728   83  Linux
/dev/sde10       80412672    80449535       18432   83  Linux
/dev/sde11       80451584    99981311     9764864   83  Linux
/dev/sde12       99983360  1076543487   488280064   83  Linux
/dev/sde13     1076545536  1953523711   438489088   83  Linux

Disk /dev/sdf: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xc8946d21

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1              63  1953520064   976760001   42  SFS

Disk /dev/md0: 1500.3 GB, 1500315451392 bytes
2 heads, 4 sectors/track, 366287952 cylinders, total 2930303616 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 32768 bytes / 98304 bytes
Alignment offset: 512 bytes
Disk identifier: 0x00000000

Disk /dev/md0 doesn't contain a valid partition table
admin0@precise64ubuntu:~$ 



