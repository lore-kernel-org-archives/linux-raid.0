From: Frank Jenkins <fjenkins873@yahoo.com>
Subject: RE: raid5 recover after a 2 disk failure
Date: Tue, 19 Jun 2007 00:44:32 -0700 (PDT)
Message-ID: <663967.19910.qm@web57308.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So here's the /proc/mdstat prior to the array failure:
---cut---
Personalities : [linear] [multipath] [raid0] [raid1]
[raid6] [raid5] [raid4] [raid10] 
md1 : active raid5 sdc1[0](S) sdf1[5] sdb1[4] sda1[3]
sde1[2] sdd1[1]
      976783616 blocks level 5, 32k chunk, algorithm 2
[5/4] [_UUUU]
            [>....................]  recovery =  0.0%
(237952/244195904) finish=427.0min speed=9518K/sec
---cut---

and here's the /proc/mdstat as it stands currently:
---cut---
Personalities : [linear] [multipath] [raid0] [raid1]
[raid6] [raid5] [raid4] [raid10] 
md1 : active raid5 sdc1[5](S) sdf1[6](S) sdb1[4]
sda1[3] sde1[7](F) sdd1[1]
      976783616 blocks level 5, 32k chunk, algorithm 2
[5/3] [_U_UU]
            
unused devices: <none>
---cut---

I think what I need to do is run:

mdadm -ARf /dev/md1 missing /dev/sd[baed]1

This should force the array back into a useable state,
yes? 
(assuming that I'm correct and sde isn't really
busted).

And more importantly, if anyone can tell me how to
lock down the 
disks so they are readonly so I can play around with
mdadm 
re-assembly options without having to worry about
compeletly 
destroying the array, that'd be awesome.

As usual, any help would be greatly appreciated.

I'll include the -E output from the drives in their
current state, if that helps:


nas# for t in a b c d e f ; do mdadm -E /dev/sd${t}1 >
sd${t}1.txt ; done
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8bc0e21c:ef63a964:93ce508e:500a32e2
  Creation Time : Mon Sep 27 11:14:17 2004
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 976783616 (931.53 GiB 1000.23 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 1

    Update Time : Sat Jun 16 23:22:03 2007
          State : clean
 Active Devices : 3
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 2
       Checksum : 9e863c27 - correct
         Events : 0.67378

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     3       8        1        3      active sync 
 /dev/sda1

   0     0       0        0        0      removed
   1     1       8       49        1      active sync 
 /dev/sdd1
   2     2       0        0        2      faulty
removed
   3     3       8        1        3      active sync 
 /dev/sda1
   4     4       8       17        4      active sync 
 /dev/sdb1
   5     5       8       33        5      spare  
/dev/sdc1
   6     6       8       81        6      spare  
/dev/sdf1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8bc0e21c:ef63a964:93ce508e:500a32e2
  Creation Time : Mon Sep 27 11:14:17 2004
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 976783616 (931.53 GiB 1000.23 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 1

    Update Time : Sat Jun 16 23:22:03 2007
          State : clean
 Active Devices : 3
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 2
       Checksum : 9e863c39 - correct
         Events : 0.67378

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     4       8       17        4      active sync 
 /dev/sdb1

   0     0       0        0        0      removed
   1     1       8       49        1      active sync 
 /dev/sdd1
   2     2       0        0        2      faulty
removed
   3     3       8        1        3      active sync 
 /dev/sda1
   4     4       8       17        4      active sync 
 /dev/sdb1
   5     5       8       33        5      spare  
/dev/sdc1
   6     6       8       81        6      spare  
/dev/sdf1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8bc0e21c:ef63a964:93ce508e:500a32e2
  Creation Time : Mon Sep 27 11:14:17 2004
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 976783616 (931.53 GiB 1000.23 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 1

    Update Time : Sat Jun 16 23:22:03 2007
          State : clean
 Active Devices : 3
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 2
       Checksum : 9e863c45 - correct
         Events : 0.67378

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     5       8       33        5      spare  
/dev/sdc1

   0     0       0        0        0      removed
   1     1       8       49        1      active sync 
 /dev/sdd1
   2     2       0        0        2      faulty
removed
   3     3       8        1        3      active sync 
 /dev/sda1
   4     4       8       17        4      active sync 
 /dev/sdb1
   5     5       8       33        5      spare  
/dev/sdc1
   6     6       8       81        6      spare  
/dev/sdf1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8bc0e21c:ef63a964:93ce508e:500a32e2
  Creation Time : Mon Sep 27 11:14:17 2004
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 976783616 (931.53 GiB 1000.23 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 1

    Update Time : Sat Jun 16 23:22:03 2007
          State : clean
 Active Devices : 3
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 2
       Checksum : 9e863c53 - correct
         Events : 0.67378

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync 
 /dev/sdd1

   0     0       0        0        0      removed
   1     1       8       49        1      active sync 
 /dev/sdd1
   2     2       0        0        2      faulty
removed
   3     3       8        1        3      active sync 
 /dev/sda1
   4     4       8       17        4      active sync 
 /dev/sdb1
   5     5       8       33        5      spare  
/dev/sdc1
   6     6       8       81        6      spare  
/dev/sdf1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8bc0e21c:ef63a964:93ce508e:500a32e2
  Creation Time : Mon Sep 27 11:14:17 2004
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 976783616 (931.53 GiB 1000.23 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 1

    Update Time : Sat Jun 16 19:16:48 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 9e86022f - correct
         Events : 0.67372

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     2       8       65        2      active sync 
 /dev/sde1

   0     0       0        0        0      removed
   1     1       8       49        1      active sync 
 /dev/sdd1
   2     2       8       65        2      active sync 
 /dev/sde1
   3     3       8        1        3      active sync 
 /dev/sda1
   4     4       8       17        4      active sync 
 /dev/sdb1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8bc0e21c:ef63a964:93ce508e:500a32e2
  Creation Time : Mon Sep 27 11:14:17 2004
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 976783616 (931.53 GiB 1000.23 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 1

    Update Time : Sat Jun 16 23:22:03 2007
          State : clean
 Active Devices : 3
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 2
       Checksum : 9e863c77 - correct
         Events : 0.67378

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     6       8       81        6      spare  
/dev/sdf1

   0     0       0        0        0      removed
   1     1       8       49        1      active sync 
 /dev/sdd1
   2     2       0        0        2      faulty
removed
   3     3       8        1        3      active sync 
 /dev/sda1
   4     4       8       17        4      active sync 
 /dev/sdb1
   5     5       8       33        5      spare  
/dev/sdc1
   6     6       8       81        6      spare  
/dev/sdf1



       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
