From: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Subject: multiple disk failures in an md raid6 array
Date: Wed, 3 Apr 2013 13:19:16 +0000
Message-ID: <CD81A492.400C6%michael.vanhorn@wright.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <7B1A3757F28AAD48B8207A01236ECCDC@prod.exchangelabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Now, I don't think that 3 disks have all gone bad at the same time, but as
md seems to think that they have, how do I proceed with this?

Normally, it's a RAID 6 array, with sdc - sdi being active and sdj being a
spare (that it, 8 disks total with one spare).

Here's what my raid looks like now:

[root ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Thu Dec 13 16:10:58 2012
     Raid Level : raid6
     Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
  Used Dev Size : 1953380352 (1862.89 GiB 2000.26 GB)
   Raid Devices : 7
  Total Devices : 8
    Persistence : Superblock is persistent

    Update Time : Wed Apr  3 02:15:16 2013
          State : clean, FAILED
 Active Devices : 4
Working Devices : 5
 Failed Devices : 3
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : myhostname:0  (local to host myhostname)
           UUID : c98a2a7b:f051a80c:2fa73177:757a5be1
         Events : 5066

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       49        1      active sync   /dev/sdd1
       2       0        0        2      removed
       3       0        0        3      removed
       4       8       97        4      active sync   /dev/sdg1
       5       8      113        5      active sync   /dev/sdh1
       6       8      129        6      active sync   /dev/sdi1

       0       8       33        -      faulty spare   /dev/sdc1
       2       8       65        -      faulty spare
       3       8       81        -      faulty spare   /dev/sdf1
       7       8      145        -      spare   /dev/sdj1
[root ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdc1[0](F) sdj1[7](S) sdi1[6] sdh1[5] sdg1[4]
sdf1[3](F) sde1[2](F) sdd1[1]
      9766901760 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/4]
[_U__UUU]
      
unused devices: <none>
[root ~]#

It seems that at some point last night, sde went bad and was taken out of
the array and the spare, sdj, was put in it's place and the raid began to
rebuild. At that point, I would have waited until the rebuild was
complete, and then replaced sde and brought it all back. However, the
rebuild seems to have died, and now I have the situation shown above.

So, I can believe that sde actually is bad, but it seems unlikely to me
that all of them are bad, especially since the smart tests I do have all
been coming back fine up to this point. Actually, according to smart, most
of them are good:

sdc:
SMART overall-health self-assessment test result: PASSED
sdd:
SMART overall-health self-assessment test result: PASSED
sde:
sdf:
SMART overall-health self-assessment test result: PASSED
sdg:
SMART overall-health self-assessment test result: PASSED
sdh:
SMART overall-health self-assessment test result: PASSED
sdi:
SMART overall-health self-assessment test result: PASSED
sdj:
SMART overall-health self-assessment test result: FAILED!

And so it appears that sde has died (it seems to have disappeared from the
system entirely). And sdj appears to have enough bad block that smart is
labeling it as bad:

[root ~]# /usr/sbin/smartctl -H -d ata /dev/sde
smartctl 5.42 2011-10-20 r3458 [x86_64-linux-2.6.18-308.13.1.el5] (local
build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

Smartctl open device: /dev/sde failed: No such device
[root ~]# /usr/sbin/smartctl -H -d ata /dev/sdj
smartctl 5.42 2011-10-20 r3458 [x86_64-linux-2.6.18-308.13.1.el5] (local
build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: FAILED!
Drive failure expected in less than 24 hours. SAVE ALL DATA.
Failed Attributes:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED
WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   058   058   140    Pre-fail  Always
FAILING_NOW 1134

Is there someway I can keep this array going? I do have one spare disk on
the shelf that I can put in (which is what I would have done), but how to
I get it to consider sdc and sdf as okay?

Thanks!




---
Mike VanHorn
Senior Computer Systems Administrator
College of Engineering and Computer Science
Wright State University
265 Russ Engineering Center
937-775-5157
michael.vanhorn@wright.edu
http://www.cecs.wright.edu/~mvanhorn/




