From: Rory Jaffe <rsjaffe@gmail.com>
Subject: check vs repair -- mismatch count goes up in repair, zeros in check?
Date: Sat, 18 Jun 2011 09:10:01 -0700
Message-ID: <BANLkTikWJvVfmwiRgDPzprQsU_Jc67go0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm a bit confused about check vs repair.

When I run repair, mismatches are initially zero'd at the start and
then add up as it runs through, so that at the end there is a positive
mismatch count. Running check after that zero's them out.

I thought check would run through the array and identify mismatches,
but not repair them, while repair would do the repair step as well.
But the exhibited behavior seems to indicate the opposite.

Does the mismatch count show the current number of identified
mismatches? Or what is it really counting?

See http://pastthe.endoftheinternet.org/munin/home/ubuntunas/index.html#munin
for an example (page up from the munin graphs--the three graphs
immediately above track the array.


/dev/md0:
        Version : 1.2
  Creation Time : Sat Apr 30 14:29:07 2011
     Raid Level : raid6
     Array Size : 5857609728 (5586.25 GiB 5998.19 GB)
  Used Dev Size : 1952536576 (1862.08 GiB 1999.40 GB)
   Raid Devices : 5
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Sat Jun 18 09:08:03 2011
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : ubuntunas:0  (local to host ubuntunas)
           UUID : 9916bc94:a245d51b:ecca3480:7c612ed5
         Events : 127

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2
       4       8       66        4      active sync   /dev/sde2

       5       8       82        -      spare   /dev/sdf2
