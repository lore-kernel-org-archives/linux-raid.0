From: Michael Shaver <jmshaver@gmail.com>
Subject: Kernel deadlock during mdadm reshape
Date: Tue, 26 Jul 2016 22:18:48 -0400
Message-ID: <bbcfb493-cdee-54cd-99aa-b1f9217b3b43@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am experiencing the exact same problem reported in this thread:

http://www.spinics.net/lists/raid/msg52235.html

Also reported here:

https://forums.gentoo.org/viewtopic-t-1043706.html

And here:

https://bbs.archlinux.org/viewtopic.php?id=212108

I have a raid5 array of 2TB disks currently stuck at 94% of a mdadm 
reshape squeal to a grow operation from 4 disks to 5.  In my case, I did 
have a drive drop out of the array during the reshape.

The PC has been rebooted many times now in an attempt to restart the 
process, but no matter what I do, the array immediately locks up upon 
assembly.  The md127_raid5 kernel process immediately spikes to near 
100% cpu, and md127_reshape immediately deadlocks, followed by udev 
shortly after. At this point, any attempt to mount or interact with the 
array will cause processes to hang.

Been trying to recover for about three weeks now, starting to run out of 
ideas of what to try next.

What I have tried thus far:

1. Disabled all manner of intrusive security enforcement (selinux)

2. Attempted to 'freeze-reshape' but to no effect

3. Attempted to assemble with 'invalid-backup' but to no effect

4. Changed min and max through put values for array reshape but to no effect

5. Ran extended SMART tests against all drives (all pass, the faulty 
drive has issues with going to sleep)

6. Booted live recovery CDs from a variety of kernel versions (as far 
back as 3.6.10 and as far forward as 4.6.3)

7. Compiled latest mdadm

8. Disabled udev

9. Tried killing the md127_raid5 process before it could spike but to no 
effect

10. Tried killing the md127_reshape process before it could deadlock but 
to no effect

11. Swapped out drives to a different physical PC


Nothing I do seems to have any effect.  The issue reproduces exactly the 
same under all scenarios.


 > mdadm --add /dev/md127 /dev/sdf1

 > mdadm --grow /dev/md127 --raid-devices=5 
--backup-file=/home/user/grow_md127.bak

 > cat /prod/mdstat

Personalities : [raid6] [raid5] [raid4]
md127 : active raid5 sdd1[1] sde1[5] sda1[4] sdf1[2]
       5860147200 blocks super 1.2 level 5, 128k chunk, algorithm 2 
[5/4] [_UUUU]
       [==================>..]  reshape = 94.3% (1842696832/1953382400) 
finish=99999.99min speed=0K/sec
       bitmap: 2/15 pages [8KB], 65536KB chunk

unused devices: <none>

 > ps aux | grep md127

root      3568 98.4  0.0      0     0 ?        R    21:35   1:16 
[md127_raid5]
root      3569  0.0  0.0      0     0 ?        D    21:35   0:00 
[md127_reshape]

 > ps aux | grep md | grep D
root      3569  0.0  0.0      0     0 ?        D    21:35   0:00 
[md127_reshape]
root      3570  0.0  0.0      0     0 ?        D    21:35   0:00 
[systemd-udevd]

 > cat /proc/3569/stack
[<ffffffffc066af50>] raid5_get_active_stripe+0x310/0x6f0 [raid456]
[<ffffffffc066f87b>] reshape_request+0x2fb/0x940 [raid456]
[<ffffffffc06701e6>] raid5_sync_request+0x326/0x3a0 [raid456]
[<ffffffff8164136c>] md_do_sync+0x88c/0xe50
[<ffffffff8163dde9>] md_thread+0x139/0x150
[<ffffffff810c6c98>] kthread+0xd8/0xf0
[<ffffffff817da5c2>] ret_from_fork+0x22/0x40
[<ffffffffffffffff>] 0xffffffffffffffff

 > cat /proc/3570/stack
[<ffffffff811b64d8>] __lock_page+0xc8/0xe0
[<ffffffff811cb8dd>] truncate_inode_pages_range+0x46d/0x880
[<ffffffff811cbd05>] truncate_inode_pages+0x15/0x20
[<ffffffff81281d8f>] kill_bdev+0x2f/0x40
[<ffffffff812832e5>] __blkdev_put+0x85/0x290
[<ffffffff8128399c>] blkdev_put+0x4c/0x110
[<ffffffff81283a85>] blkdev_close+0x25/0x30
[<ffffffff81249abf>] __fput+0xdf/0x1f0
[<ffffffff81249c0e>] ____fput+0xe/0x10
[<ffffffff810c514f>] task_work_run+0x7f/0xa0
[<ffffffff810ab0a8>] do_exit+0x2d8/0xb60
[<ffffffff810ab9b7>] do_group_exit+0x47/0xb0
[<ffffffff810b6cd1>] get_signal+0x291/0x610
[<ffffffff8102e137>] do_signal+0x37/0x710
[<ffffffff8100320c>] exit_to_mode_loop+0x8c/0xd0
[<ffffffff81003d21>] syscall_return_slowpath+0xa1/0xb0
[<ffffffff817da43a>] entry_SYSCALL_64_fastpath+0xa2/0xa4
[<ffffffffffffffff>] 0xffffffffffffffff

 > cat /proc/3568/stack
[<ffffffffffffffff>] 0xffffffffffffffff

 > mdadm -S /dev/md127          hangs

 > reboot

 > mdadm --assemble /dev/md127 /dev/sda1 /dev/sdc1 /dev/sdd1 /dev/sde1 
/dev/sdf1 --verbose --backup-file=/home/user/grow_md127.bak

mdadm: /dev/sda1 is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 4.
mdadm: /dev/sdf1 is identified as a member of /dev/md127, slot 2.
mdadm: /dev/md127 has an active reshape - checking if critical section 
needs to be restored
mdadm: No backup metadata on /home/user/grow_md127.bak
mdadm: too-old timestamp on backup-metadata on device-4
mdadm: If you think it is should be safe, try 'export 
MDADM_GROW_ALLOW_OLD=1'
mdadm: added /dev/sdc1 to /dev/md127 as 0 (possibly out of date)
mdadm: added /dev/sdf1 to /dev/md127 as 2
mdadm: added /dev/sda1 to /dev/md127 as 3
mdadm: added /dev/sde1 to /dev/md127 as 4
mdadm: added /dev/sdd1 to /dev/md127 as 1
mdadm: /dev/md127 has been started with 4 drives (out of 5).

 > cat /prod/mdstat

Personalities : [raid6] [raid5] [raid4]
md127 : active raid5 sdd1[1] sde1[5] sda1[4] sdf1[2]
       5860147200 blocks super 1.2 level 5, 128k chunk, algorithm 2 
[5/4] [_UUUU]
       [==================>..]  reshape = 94.3% (1842696832/1953382400) 
finish=99999.99min speed=0K/sec
       bitmap: 2/15 pages [8KB], 65536KB chunk

unused devices: <none>

 > mdadm -S /dev/md127          hangs

 > reboot

 > export MDADM_GROW_ALLOW_OLD=1

 > mdadm --assemble /dev/md127 /dev/sda1 /dev/sdc1 /dev/sdd1 /dev/sde1 
/dev/sdf1 --verbose --backup-file=/home/user/grow_md127.bak
mdadm: looking for devices for /dev/md127
mdadm: /dev/sda1 is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 4.
mdadm: /dev/sdf1 is identified as a member of /dev/md127, slot 2.
mdadm: /dev/md127 has an active reshape - checking if critical section 
needs to be restored
mdadm: No backup metadata on /home/user/grow_md127.bak
mdadm: accepting backup with timestamp 1467397557 for array with 
timestamp 1469583355
mdadm: backup-metadata found on device-4 but is not needed
mdadm: added /dev/sdc1 to /dev/md127 as 0 (possibly out of date)
mdadm: added /dev/sdf1 to /dev/md127 as 2
mdadm: added /dev/sda1 to /dev/md127 as 3
mdadm: added /dev/sde1 to /dev/md127 as 4
mdadm: added /dev/sdd1 to /dev/md127 as 1
mdadm: /dev/md127 has been started with 4 drives (out of 5).

 > cat /prod/mdstat

Personalities : [raid6] [raid5] [raid4]
md127 : active raid5 sdd1[1] sde1[5] sda1[4] sdf1[2]
       5860147200 blocks super 1.2 level 5, 128k chunk, algorithm 2 
[5/4] [_UUUU]
       [==================>..]  reshape = 94.3% (1842696832/1953382400) 
finish=99999.99min speed=0K/sec
       bitmap: 2/15 pages [8KB], 65536KB chunk

unused devices: <none>

 > mdadm -D /dev/md127
/dev/md127:
         Version : 1.2
   Creation Time : Sun May 18 16:54:52 2014
      Raid Level : raid5
      Array Size : 5860147200 (5588.67 GiB 6000.79 GB)
   Used Dev Size : 1953382400 (1862.89 GiB 2000.26 GB)
    Raid Devices : 5
   Total Devices : 4
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Tue Jul 26 21:53:57 2016
           State : clean, degraded, reshaping
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 128K

  Reshape Status : 94% complete
   Delta Devices : 1, (4->5)

            Name : rza.eth0.net:0  (local to host rza.eth0.net)
            UUID : 9d5d1606:414b51f8:b5173999:7239c63f
          Events : 345137

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       8       49        1      active sync   /dev/sdd1
        2       8       81        2      active sync   /dev/sdf1
        4       8        1        3      active sync   /dev/sda1
        5       8       65        4      active sync   /dev/sde1



Looking for pointers on where to look next, if anyone has suggestions.  
I am starting to step through code and debugging the kernel, but this is 
out of my depth.

A couple of specific questions:

1.    Am I correct in my understanding that the code for the md127_raid5 
and md127_reshape processes are effectively in kernel space?  My 
understanding is that mdadm manages those kernel space processes? If I 
want to debug the deadlock, I should be looking in the kernel portion of 
linux raid?

2.    Does md_reshape require md_raid5 to be running and vise-versa?  
Would it be possible to force mdadm to only start one process or the other?


thanks for any tips or suggestions!

Michael










