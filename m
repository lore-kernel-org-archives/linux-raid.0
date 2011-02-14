From: Gavin Flower <gavinflower@yahoo.com>
Subject: mdadm: recovering from an aborted reshape op - mdadm -Evv /dev/sd[abcde]2
Date: Mon, 14 Feb 2011 12:49:35 -0800 (PST)
Message-ID: <151320.37918.qm@web65113.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm -Evv /dev/sd[abcde]2

/dev/sda2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6f1176ae:a0ad6cac:bfe78010:bc810f04
  Creation Time : Thu Dec  3 13:05:02 2009
     Raid Level : raid6
  Used Dev Size : 102399488 (97.66 GiB 104.86 GB)
     Array Size : 307198464 (292.97 GiB 314.57 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1

    Update Time : Mon Feb 14 19:22:05 2011
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d44c7dd2 - correct
         Events : 3389711

         Layout : left-symmetric
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       66        2      active sync   /dev/sde2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       34        4      active sync   /dev/sdc2
/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6f1176ae:a0ad6cac:bfe78010:bc810f04
  Creation Time : Thu Dec  3 13:05:02 2009
     Raid Level : raid6
  Used Dev Size : 102399488 (97.66 GiB 104.86 GB)
     Array Size : 307198464 (292.97 GiB 314.57 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1

    Update Time : Mon Feb 14 19:22:05 2011
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d44c7de4 - correct
         Events : 3389711

         Layout : left-symmetric
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       66        2      active sync   /dev/sde2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       34        4      active sync   /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6f1176ae:a0ad6cac:bfe78010:bc810f04
  Creation Time : Thu Dec  3 13:05:02 2009
     Raid Level : raid6
  Used Dev Size : 102399488 (97.66 GiB 104.86 GB)
     Array Size : 307198464 (292.97 GiB 314.57 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1

    Update Time : Mon Feb 14 19:22:05 2011
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d44c7dfa - correct
         Events : 3389711

         Layout : left-symmetric
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     4       8       34        4      active sync   /dev/sdc2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       66        2      active sync   /dev/sde2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       34        4      active sync   /dev/sdc2
/dev/sdd2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6f1176ae:a0ad6cac:bfe78010:bc810f04
  Creation Time : Thu Dec  3 13:05:02 2009
     Raid Level : raid6
  Used Dev Size : 102399488 (97.66 GiB 104.86 GB)
     Array Size : 307198464 (292.97 GiB 314.57 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1

    Update Time : Mon Feb 14 19:22:05 2011
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d44c7e08 - correct
         Events : 3389711

         Layout : left-symmetric
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     3       8       50        3      active sync   /dev/sdd2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       66        2      active sync   /dev/sde2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       34        4      active sync   /dev/sdc2
/dev/sde2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6f1176ae:a0ad6cac:bfe78010:bc810f04
  Creation Time : Thu Dec  3 13:05:02 2009
     Raid Level : raid6
  Used Dev Size : 102399488 (97.66 GiB 104.86 GB)
     Array Size : 307198464 (292.97 GiB 314.57 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1

    Update Time : Mon Feb 14 19:22:05 2011
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d44c7e16 - correct
         Events : 3389711

         Layout : left-symmetric
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     2       8       66        2      active sync   /dev/sde2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       66        2      active sync   /dev/sde2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       34        4      active sync   /dev/sdc2
--
All Adults share the Responsibility
to help Raise Today's Children,
for they are Tomorrow's Society!


      
