From: Ian Radford <ian.c.radford@gmail.com>
Subject: Accidentally added as spare
Date: Fri, 30 Oct 2015 19:07:23 +0000
Message-ID: <CA+H5Tn=Mzys64CK2r4HBZQe-rUc8nM8hpsWTQUX_mDMTF9-d_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently had a drive fail in a 3 drive RAID 5 array that had been up
for nearly 3 years. I've handled this several time before but this
time, whilst swapping out the failed drive, a 2nd drive dropped out of
the array for some reason and when I tried to add it back, became
marked as a spare. I haven't done anything with the new drive yet so
whenever I try to start the array, I get one active drive and one
spare and hence the array can't start. I can't work out how to prevent
the 2nd drive being detected as a spare and allow the array to start
with 2 of 3 drives. As far as I can tell from using --examine, the
event counts are identical so I'm hoping recovery is feasible.
Unfortunately I don't know what order the disks were originally in
(all of the original disks have failed and been replaced during the
array's life so far).

So, 2 questions: Is there a simple way to stop the 2nd drive thinking
that it's a spare so I can just assemble the array. If not, I believe
I should be able to recreate the array with --assume-clean: How do I
determine the correct order for the drives? (If it's a matter of trial
and error, how do I know when I get it right?)

The output from --examine on the two drives is:

/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cd57d356:c19317bf:a7df5645:f34ebdb2
  Creation Time : Fri Mar 20 17:53:13 2009
     Raid Level : raid5
  Used Dev Size : 1454894336 (1387.50 GiB 1489.81 GB)
     Array Size : 2909788672 (2774.99 GiB 2979.62 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 1

    Update Time : Thu Oct 29 18:37:53 2015
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 1
       Checksum : ca5c1582 - correct
         Events : 3329174

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     0       8       66        0      active sync

   0     0       8       66        0      active sync
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8       50        3      spare   /dev/sdd2


/dev/sdd2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cd57d356:c19317bf:a7df5645:f34ebdb2
  Creation Time : Fri Mar 20 17:53:13 2009
     Raid Level : raid5
  Used Dev Size : 1454894336 (1387.50 GiB 1489.81 GB)
     Array Size : 2909788672 (2774.99 GiB 2979.62 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 1

    Update Time : Thu Oct 29 18:37:53 2015
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 1
       Checksum : ca5c1572 - correct
         Events : 3329174

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     3       8       50        3      spare   /dev/sdd2

   0     0       8       66        0      active sync
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8       50        3      spare   /dev/sdd2
