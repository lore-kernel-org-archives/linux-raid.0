From: Bill Davidsen <davidsen@tmr.com>
Subject: [Fwd: Strange RAID-5 rebuild problem]
Date: Sat, 01 Mar 2008 17:08:47 -0500
Message-ID: <47C9D3EF.10001@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: Michael Guntsche <mike@it-loops.com>
List-Id: linux-raid.ids

I am forwarding this from LKML, seems more appropriate here

-------- Original Message --------
Subject: Strange RAID-5 rebuild problem
Date: Sat, 1 Mar 2008 21:57:55 +0100
From: Michael Guntsche <mike@it-loops.com>
To: linux-kernel@vger.kernel.org
Newsgroups: gmane.linux.kernel

Ok, after going through benchmarking for the last few days, I now
started acutally deploying the system.

I created a RAID-5 with a 1.0 superblock and let the RAID resync.
I had to reboot the computer for another update and did not think
about thw rebuilding process since it should continue just fine after
a restart. After a reboot I noticed that the RAID was in the
following state.

/dev/md1:
          Version : 01.00.03
    Creation Time : Sat Mar  1 21:42:18 2008
       Raid Level : raid5
       Array Size : 1464982272 (1397.12 GiB 1500.14 GB)
    Used Dev Size : 976654848 (465.71 GiB 500.05 GB)
     Raid Devices : 4
    Total Devices : 4
Preferred Minor : 1
      Persistence : Superblock is persistent

      Update Time : Sat Mar  1 21:50:19 2008
            State : clean, degraded
   Active Devices : 3
Working Devices : 4
   Failed Devices : 0
    Spare Devices : 1

           Layout : left-symmetric
       Chunk Size : 256K

             Name : gibson:1  (local to host gibson)
             UUID : 80b0698e:d7c76d22:e231f03e:d25feba2
           Events : 32

      Number   Major   Minor   RaidDevice State
         0       8        2        0      active sync   /dev/sda2
         1       8       18        1      active sync   /dev/sdb2
         2       8       34        2      active sync   /dev/sdc2
         4       8       50        3      spare rebuilding   /dev/sdd2

mdadm -E /dev/sdd2:

/dev/sdd2:
            Magic : a92b4efc
          Version : 1.0
      Feature Map : 0x2
       Array UUID : 80b0698e:d7c76d22:e231f03e:d25feba2
             Name : gibson:1  (local to host gibson)
    Creation Time : Sat Mar  1 21:42:18 2008
       Raid Level : raid5
     Raid Devices : 4

   Avail Dev Size : 976655336 (465.71 GiB 500.05 GB)
       Array Size : 2929964544 (1397.12 GiB 1500.14 GB)
    Used Dev Size : 976654848 (465.71 GiB 500.05 GB)
     Super Offset : 976655592 sectors
Recovery Offset : 973312 sectors
            State : clean
      Device UUID : 5d6d28dd:c1d4d59d:3617c511:267c47f6

      Update Time : Sat Mar  1 21:55:44 2008
         Checksum : a1ca2174 - correct
           Events : 52

           Layout : left-symmetric
       Chunk Size : 256K

      Array Slot : 4 (0, 1, 2, failed, 3)
     Array State : uuuU 1 failed




/proc/mdstat showed now progress bar though. Ok, since he seems stuck
I thought, why not just mark sdd2 as failed.
I was able to mark it as failed but looking at the detail again I saw
"spare rebuilding" and I could not remove it.
Next I tried a fail/remove which also did not work. I stopped the
array started it again, and THEN it removed the disk.
I tried this several times, the same result every time.

Just for kicks I created the RAID with a 0.90 superblock and tried
the same thing. Lo and behold after stopping the array and starting
it again the progress bar showed up and everything started rebuilding
where it stopped earlier.

Is this "normal" or is this a superblock 1.0 related problem?

Current kernel is 2.6.24.2, mdadm is v2.6.4 from debian unstable.

I do not need the RAID right now so I could run some tests on it if
someone wants me too.

Kind regards,
Michael
-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
