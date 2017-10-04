From: Curt <lightspd@gmail.com>
Subject: hung grow
Date: Wed, 4 Oct 2017 13:18:14 -0400
Message-ID: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

So, I got my raid6 is a half fucked state you could say. My raid6 lost
3 drives and then starting throwing I/O errors on the mount point.  If
I tried to restart with the good drives, I got too few to start raid.
So one that got marked faulty, almost matched the even count of the
others, only off by a few.  So I did a assemble force, which seemed to
work and I could see my data.  I should have just pulled it off at
that point and saved what I could, but no.

So I replaced 2 of the bad drives and added them to the raid, it went
through recovery, but only marked the 2 new drives as spares and
showed the bad removed, 2 spares, and it marked one faulty aging, see
the below.

uname -a
Linux dev 3.10.0-229.el7.x86_64 #1 SMP Fri Mar 6 11:36:42 UTC 2015
x86_64 x86_64 x86_64 GNU/Linux

mdadm --detail /dev/md127
/dev/md127:
           Version : 0.90
     Creation Time : Fri Jun 15 15:52:05 2012
        Raid Level : raid6
        Array Size : 9767519360 (9315.03 GiB 10001.94 GB)
     Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
      Raid Devices : 7
     Total Devices : 7
   Preferred Minor : 127
       Persistence : Superblock is persistent

       Update Time : Tue Oct  3 22:22:06 2017
             State : clean, FAILED
    Active Devices : 4
   Working Devices : 6
    Failed Devices : 1
     Spare Devices : 2

            Layout : left-symmetric
        Chunk Size : 64K

Consistency Policy : unknown

              UUID : 714a612d:9bd35197:36c91ae3:c168144d
            Events : 0.11559613

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8       49        1      active sync   /dev/sdd1
       2       8       33        2      active sync   /dev/sdc1
       3       8        1        3      active sync   /dev/sda1
       -       0        0        4      removed
       -       0        0        5      removed
       -       0        0        6      removed

       7       8       80        -      spare   /dev/sdf
       8       8       16        -      spare   /dev/sdb
       9       8       65        -      faulty   /dev/sde1

after several tries to reassemble, the spares wouldn't got active.  So
on the advice of somenone, I set the raid to grow to 8, the theory
being it would make on spare active. Which somewhat worked, but grow
froze at 0% and when I do a detail on md127 it just hangs, it returned
once when this first started and showed the spare in spare rebuilding
status, but sync_action showed reshape and mdstat.


examine returns this, it's the same for all as far as I can see
mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 11721023232 (11178.04 GiB 12002.33 GB)
   Raid Devices : 8
  Total Devices : 6
Preferred Minor : 127

  Reshape pos'n : 3799296 (3.62 GiB 3.89 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Oct  4 10:10:37 2017
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 2
  Spare Devices : 0
       Checksum : ce71846f - correct
         Events : 11559679

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8        1        3      active sync   /dev/sda1

   0     0       8       97        0      active sync   /dev/sdg1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       0        0        5      faulty removed
   6     6       8       16        6      active   /dev/sdb
   7     7       0        0        7      faulty removed


Is my raid completely fucked or can I still recover some data with
doing the create assume clean?

Cheers,
Curt
