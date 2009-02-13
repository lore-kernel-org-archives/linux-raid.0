From: Andrew Burgess <aab@cichlid.com>
Subject: grow raid6 array: Cannot set device size/shape: Device or resource
	busy, even in single user mode
Date: Fri, 13 Feb 2009 09:43:16 -0800
Message-ID: <1234546996.20249.23.camel@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've grown this array before. This time I can't figure out why it
complains.
Even rebooting to single user mode and making sure the array isn't
mounted
gives the same error.

One discrepancy I noticed (may be unrelated) is that mdadm thinks
the array's device size is twice as big as it actually is:

cat /sys/block/md5/md/component_size 
732159744

mdadm -D /dev/md5|grep Used
Used Dev Size : 1464319488 (1396.48 GiB 1499.46 GB)

(I have another smaller raid6 array on this machine and these numbers
match)

strace reveals that mdadm is doing an ioctl on /dev/md5 when the error
occurs
and that the earlier open on /dev/md5 in RW mode worked.

If it is an mdadm problem, would writing the new number of devices
to /sys/block/md5/md/raid_disks work?

Thanks in advance for any clues
Andrew

-----------------------------------------------
# uname -a
Linux athlon 2.6.28.3-noatop-1 #1 SMP PREEMPT Wed Feb 4 13:49:05 PST
2009 x86_64 x86_64 x86_64 GNU/Linux
# mdadm -V
mdadm - v2.6.7.1 - 15th October 2008
-----------------------------------------------
root@athlon:~ # mdadm /dev/md5 --add /dev/sds1
mdadm: re-added /dev/sds1
root@athlon:~ # mdadm /dev/md5 --grow --raid-devices=10
mdadm: Need to backup 7168K of critical section..
mdadm: Cannot set device size/shape for /dev/md5: Device or resource
busy
---------------------------------------------------
# mdadm -D /dev/md5
/dev/md5:
        Version : 1.02
  Creation Time : Tue Sep 11 13:49:50 2007
     Raid Level : raid6
     Array Size : 5125118208 (4887.69 GiB 5248.12 GB)
  Used Dev Size : 1464319488 (1396.48 GiB 1499.46 GB)
   Raid Devices : 9
  Total Devices : 10
Preferred Minor : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri Feb 13 09:27:52 2009
          State : active
 Active Devices : 9
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 1

     Chunk Size : 128K

           Name : 5
           UUID : 5211e02e:19f8718e:8feeb699:03a4879f
         Events : 7840654

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
      10       8       97        1      active sync   /dev/sdg1
       2       8       49        2      active sync   /dev/sdd1
       8      65       65        3      active sync   /dev/sdu1
       4       8       65        4      active sync   /dev/sde1
       7      65       49        5      active sync   /dev/sdt1
       9       8       81        6      active sync   /dev/sdf1
      11       8       33        7      active sync   /dev/sdc1
      12      65       81        8      active sync   /dev/sdv1

      13      65       33        -      spare   /dev/sds1


