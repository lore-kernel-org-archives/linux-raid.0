From: spam@streefland.xs4all.nl (Dick Streefland)
Subject: Re: resync on every raidstart
Date: Sat, 27 Sep 2003 14:52:04 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <13ef.3f75a413.f153f@altium.nl>
References: <7e6d.3f6de874.1ece7@altium.nl> <16239.60542.191148.816664@notabene.cse.unsw.edu.au> <dad.3f70b057.ee5c4@altium.nl>
Reply-To: dick.streefland@xs4all.nl (Dick Streefland)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I did some more tests, and it looks like my problem may be related to
SMP. When I setup a RAID1 array on my SMP machine, the component
devices stay "dirty", but when I do the same on an UP machine, the
state is "clean". However, when I boot the SMP machine with "nosmp",
or boot a non-SMP kernel, the problem persists. Both machines run a
2.6.0-test5 kernel (with your oops fix from 2003-09-12), and have
mdadm-1.3.0.

This is the test script:

#!/bin/sh
dd bs=1024k count=10 if=/dev/zero of=/tmp/img1
dd bs=1024k count=10 if=/dev/zero of=/tmp/img2
losetup /dev/loop1 /tmp/img1
losetup /dev/loop2 /tmp/img2
mdadm -C -n 2 -l 1 /dev/md1 /dev/loop1 /dev/loop2
while grep resync /proc/mdstat
do sleep 1
done
echo done
sleep 3
mdadm -E /dev/loop1
mdadm -S /dev/md1
losetup -d /dev/loop1
losetup -d /dev/loop2
rm /tmp/img1
rm /tmp/img2

This is the output on the UP machine:

      [======>..............]  resync = 30.0% (3584/10176) finish=0.1min speed=716K/sec
done
/dev/loop1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 6553bca6:9c4152b1:960d65fc:75de3d79
  Creation Time : Sat Sep 27 16:23:58 2003
     Raid Level : raid1
    Device Size : 10176 (9.94 MiB 10.42 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Sat Sep 27 16:24:11 2003
          State : clean, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 35976528 - correct
         Events : 0.1


      Number   Major   Minor   RaidDevice State
this     0       7        1        0      active sync   /dev/loop1
   0     0       7        1        0      active sync   /dev/loop1
   1     1       7        2        1      active sync   /dev/loop2

This is the output on the SMP machine:

      [>....................]  resync =  0.0% (0/10176) finish=1.6min speed=0K/sec
done
/dev/loop1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : dc1e7844:0571f448:75ec8ac0:df235bed
  Creation Time : Sat Sep 27 16:23:18 2003
     Raid Level : raid1
    Device Size : 10176 (9.94 MiB 10.42 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Sat Sep 27 16:23:19 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 5eb70538 - correct
         Events : 0.1


      Number   Major   Minor   RaidDevice State
this     0       7        1        0      active sync   /dev/loop1
   0     0       7        1        0      active sync   /dev/loop1
   1     1       7        2        1      active sync   /dev/loop2

-- 
Dick Streefland                    ////               De Bilt
dick.streefland@xs4all.nl         (@ @)       The Netherlands
------------------------------oOO--(_)--OOo------------------

