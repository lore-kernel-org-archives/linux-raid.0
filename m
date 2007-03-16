From: Hanno Meyer-Thurow <h.mth@web.de>
Subject: mdadm: raid1 with ext3 - filesystem size differs?
Date: Fri, 16 Mar 2007 04:53:25 +0100
Message-ID: <20070316045325.75671622.h.mth@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all!
Please CC me on answers since I am not subscribed to this list, thanks.

When I try to build a raid1 system with mdadm 2.6.1 the filesystem size
recorded in superblock differs from physical size of device.

System:
ana ~ # uname -a
Linux ana 2.6.20-gentoo-r2 #4 SMP PREEMPT Sat Mar 10 16:25:46 CET 2007 x86_64 Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz GenuineIntel GNU/Linux

ana ~ # mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
mdadm: /dev/sda1 appears to contain an ext2fs file system
    size=48152K  mtime=Thu Mar 15 17:27:07 2007
mdadm: /dev/sda1 appears to be part of a raid array:
    level=raid1 devices=2 ctime=Thu Mar 15 17:25:52 2007
mdadm: /dev/sdb1 appears to contain an ext2fs file system
    size=48152K  mtime=Thu Mar 15 17:27:07 2007
mdadm: /dev/sdb1 appears to be part of a raid array:
    level=raid1 devices=2 ctime=Thu Mar 15 17:25:52 2007
Continue creating array? y

mdadm: array /dev/md1 started.
ana ~ # cat /proc/mdstat
md1 : active raid1 sdb1[1] sda1[0]
      48064 blocks [2/2] [UU]

ana ~ # mdadm --misc --detail /dev/md1
/dev/md1:
        Version : 00.90.03
  Creation Time : Thu Mar 15 17:37:35 2007
     Raid Level : raid1
     Array Size : 48064 (46.95 MiB 49.22 MB)
  Used Dev Size : 48064 (46.95 MiB 49.22 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Thu Mar 15 17:38:27 2007
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : cf0478ee:7e60a40e:20a5e204:cc7bc2c9
         Events : 0.4

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1

ana ~ # LC_ALL=C fsck.ext3 /dev/md1
e2fsck 1.39 (29-May-2006)
The filesystem size (according to the superblock) is 48152 blocks
The physical size of the device is 48064 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort<y>? yes



Any ideas what could be wrong? Thank you in advance for help!


Regards,
Hanno
