From: "Adone Vincenzo" <Vincenzo.Adone@h3g.it>
Subject: Raid5 Array lost ???
Date: Tue, 31 Aug 2004 17:36:14 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <21D027BB2753F34692A50402E8D259AD1F4685@MIEXC06.h3g.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'm in trouble with an raid5 array. Do I have to scratch everything or there is something I can do ...

Array configuration:	raid-5, 6 disks, no spare disks configured.

The sdg1 gone in fail state (power fail ... I think the disks is good). During the recovery the sdb1 gone in fail state.

thanx in advance.
vince


h3netapp1:~# mdadm -E /dev/sdg1
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 59bc9243:bb78edbc:2876bbe9:43d1ec04
  Creation Time : Thu May  6 09:00:59 2004
     Raid Level : raid5
    Device Size : 72204032 (68.86 GiB 73.94 GB)
   Raid Devices : 6
  Total Devices : 7
Preferred Minor : 1

    Update Time : Mon Aug 30 16:15:43 2004
          State : clean
 Active Devices : 4
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 2
       Checksum : b0c5526f - correct
         Events : 0.37

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       97        6      spare   /dev/sdg1
   0     0       0        0        0      faulty removed
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       0        0        5      faulty removed
   6     6       8       97        6      spare   /dev/sdg1
   7     7       8       17        7      spare   /dev/sdb1
