From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: 2.6.20: reproducible hard lockup with RAID-5 resync
Date: Thu, 15 Feb 2007 22:47:02 -0800
Message-ID: <45D55366.4010904@fatooh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think I have found an easily-reproducible bug in Linux 2.6.20. I have
already applied the "Fix various bugs with aligned reads in RAID5"
patch, and that had no effect. It appears to be related to the resync
process, and makes the system lock up, hard.

The steps to reproduce are:
1. Be running Linux 2.6.20 and do whatever is necessary to prepare for a
crash (close open files, sync, unmount filesystems, or whatever).
Alternatively, just boot with 'init=/bin/bash'.
2. Run 'mdadm -S /dev/md2', where /dev/md2 is a RAID-5.
3. Run 'mdadm -A /dev/md2 -U resync'.
4. Wait about 1 second. The system will lock up.

During the lock up, nothing is printed to the console, and the magic
SysRQ key has no effect; I have to poke the reset button. Normally, I
wouldn't rule out a hardware problem, but I have reasonable faith in my
computer. Neither memtest86+ nor cpuburn nor normal operation have
flushed out any instability.

Upon reboot, 2.6.20 will lock up almost immediately when it tries to
resync the array. This appears to occur regardless of whether the resync
is just starting; if I run 2.6.19 for a while until the resync is, say,
50% done and then reboot to 2.6.20, the lockup still happens.

I have provided what I hope is enough information below.

--------------------------------------------------------------------
System information:
Athlon64 3400+
64-bit Linux 2.6.20 compiled with GCC 4.1.2
64-bit Debian Sid
RAID-5 of 5 devices:
   /dev/hda   (IDE hard drive)
   /dev/sda6  (partition on SATA hard drive)
   /dev/sdb   (SATA hard drive)
   /dev/sdc6  (partition on SATA hard drive)
   /dev/sdd   (SATA hard drive)

--------------------------------------------------------------------
bugfood:~# mdadm -D /dev/md2
/dev/md2:
        Version : 00.90.03
  Creation Time : Mon May 29 22:13:47 2006
     Raid Level : raid5
     Array Size : 781433344 (745.23 GiB 800.19 GB)
    Device Size : 195358336 (186.31 GiB 200.05 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Thu Feb 15 22:07:26 2007
          State : active, resyncing
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 26% complete

           UUID : d016a205:bd3106ef:b19cb15b:b6d70494
         Events : 0.3971003

    Number   Major   Minor   RaidDevice State
       0       8        6        0      active sync   /dev/sda6
       1       8       38        1      active sync   /dev/sdc6
       2       3        0        2      active sync   /dev/hda
       3       8       16        3      active sync   /dev/sdb
       4       8       48        4      active sync   /dev/sdd

--------------------------------------------------------------------

Thank you,
Corey
