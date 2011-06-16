From: Chad Walker <chad@chad-cat-lore-eddie.com>
Subject: raid6 issues
Date: Thu, 16 Jun 2011 13:28:17 -0700
Message-ID: <BANLkTi=ky+t1uM0p_HhQPScG78BFxE8Hjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have 15 drives in a raid6 plus a spare. I returned home after being
gone for 12 days and one of the drives was marked as faulty. The load
on the machine was crazy, and mdadm stop responding. I should've done
an strace, sorry. Likewise cat'ing /proc/mdstat was blocking. I
rebooted and mdadm started recovering, but to the faulty drive. I
checked in on /proc/mdstat periodically over the 35-hour recovery.
When it was down to the last bit, /proc/mdstat and mdadm stopped
responding again. I gave it 28 hours, and then when I still couldn't
get any insight into it I rebooted again. Now /proc/mdstat says it's
inactive. And I don't appear to be able to assemble it. I issued
--examine on each of the 16 drives and they all agreed with each other
except for the faulty drive. I popped the faulty drive out and
rebooted again, still no luck assembling.

This is what my /proc/mdstat looks like:
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : inactive sdd1[12](S) sdm1[6](S) sdf1[0](S) sdh1[2](S) sdi1[7](S)
sdb1[14](S) sdo1[4](S) sdg1[1](S) sdl1[8](S) sdk1[9](S) sdc1[13](S)
sdn1[3](S) sdj1[10](S) sdp1[15](S) sde1[11](S)
      29302715520 blocks

unused devices: <none>

This is what the --examine for /dev/sd[b-o]1 and /dev/sdq1 look like:
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 78e3f473:48bbfc34:0e051622:5c30970b
  Creation Time : Wed Mar 30 14:48:46 2011
     Raid Level : raid6
  Used Dev Size : 1953514368 (1863.02 GiB 2000.40 GB)
     Array Size : 25395686784 (24219.21 GiB 26005.18 GB)
   Raid Devices : 15
  Total Devices : 16
Preferred Minor : 1

    Update Time : Wed Jun 15 07:45:12 2011
          State : active
 Active Devices : 14
Working Devices : 15
 Failed Devices : 1
  Spare Devices : 1
       Checksum : e4ff038f - correct
         Events : 38452

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    14       8       17       14      active sync   /dev/sdb1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       97        1      active sync   /dev/sdg1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8      209        3      active sync   /dev/sdn1
   4     4       8      225        4      active sync   /dev/sdo1
   5     5       0        0        5      faulty removed
   6     6       8      193        6      active sync   /dev/sdm1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      145       10      active sync   /dev/sdj1
  11    11       8       65       11      active sync   /dev/sde1
  12    12       8       49       12      active sync   /dev/sdd1
  13    13       8       33       13      active sync   /dev/sdc1
  14    14       8       17       14      active sync   /dev/sdb1
  15    15      65        1       15      spare   /dev/sdq1

And this is what --examine for /dev/sdp1 looked like:
/dev/sdp1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 78e3f473:48bbfc34:0e051622:5c30970b
  Creation Time : Wed Mar 30 14:48:46 2011
     Raid Level : raid6
  Used Dev Size : 1953514368 (1863.02 GiB 2000.40 GB)
     Array Size : 25395686784 (24219.21 GiB 26005.18 GB)
   Raid Devices : 15
  Total Devices : 16
Preferred Minor : 1

    Update Time : Tue Jun 14 07:35:56 2011
          State : active
 Active Devices : 15
Working Devices : 16
 Failed Devices : 0
  Spare Devices : 1
       Checksum : e4fdb07b - correct
         Events : 38433

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8      241        5      active sync   /dev/sdp1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       97        1      active sync   /dev/sdg1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8      209        3      active sync   /dev/sdn1
   4     4       8      225        4      active sync   /dev/sdo1
   5     5       8      241        5      active sync   /dev/sdp1
   6     6       8      193        6      active sync   /dev/sdm1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      145       10      active sync   /dev/sdj1
  11    11       8       65       11      active sync   /dev/sde1
  12    12       8       49       12      active sync   /dev/sdd1
  13    13       8       33       13      active sync   /dev/sdc1
  14    14       8       17       14      active sync   /dev/sdb1
  15    15      65        1       15      spare   /dev/sdq1

I was scared to run mdadm --build --level=6 --raid-devices=15 /dev/md1
/dev/sdf1 /dev/sdg1....

system information:
Ubuntu 11.04, kernel 2.6.38, x86_64, mdadm version 3.1.4, 3ware 9650SE

Any advice? There's about 1TB of data on these drives that would cause
my wife to kill me (and about 9TB of data would just irritate her to
loose).

-chad
