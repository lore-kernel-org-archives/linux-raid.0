From: <mario@dedenet.de>
Subject: array broken after mdadm --add
Date: Fri, 17 Mar 2006 12:15:15 +0100
Message-ID: <CHILKAT-MID-90cc2abe-79ee-481f-b683-dcdacbdd9cc3@admiral-aqua>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

i have my root partition on a raid10 array with 4 drives: hde3, hdf3, hdg3, hdh3.

hdg3 got damaged (probably because of a bad ide-cable). I installed a new cable and started:
mdadm /dev/md0 --add /dev/hdg3

resyncinc started. I watched the process via cat /proc/mdstat.

When it finished, the system suddenly rebootet and ended in a kernel panic, that it could not read data from md0.
(if the exact error message is important, pls tell me, its something with bread failed)


I booted from a live CD and executed the following command:

livecd ~ # mdadm --examine /dev/hde(f,g)3
/dev/hde3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 58d6e846:98a7c96b:7b44880d:28950ad6
  Creation Time : Mon Oct 31 09:35:10 2005
     Raid Level : raid10
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Mar 17 10:14:16 2006
          State : active
 Active Devices : 2
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 1
       Checksum : cd2e7b8c - correct
         Events : 0.439044

         Layout : near=2, far=1

      Number   Major   Minor   RaidDevice State
this     0      33        3        0      active sync   /dev/hde3

   0     0      33        3        0      active sync   /dev/hde3
   1     1      33       67        1      active sync   /dev/hdf3
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4      34        3        4      spare   /dev/hdg3



The same command with hdh3 gives another result:
livecd ~ # mdadm --examine /dev/hdh3
/dev/hdh3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 58d6e846:98a7c96b:7b44880d:28950ad6
  Creation Time : Mon Oct 31 09:35:10 2005
     Raid Level : raid10
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Mar 17 10:10:01 2006
          State : active
 Active Devices : 3
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 1
       Checksum : cd2e7ac2 - correct
         Events : 0.439040

         Layout : near=2, far=1

      Number   Major   Minor   RaidDevice State
this     3      34       67        3      active sync   /dev/hdh3

   0     0      33        3        0      active sync   /dev/hde3
   1     1      33       67        1      active sync   /dev/hdf3
   2     2       0        0        2      faulty removed
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      34        3        4      spare   /dev/hdg3


Here it seems, that the drive is still active.

What can I do now to get the raid running again and do not risk losing any files?

Any help is appreciated!

Thanks in advance.

Mario.
