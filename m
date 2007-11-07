From: chrise@synplicity.com
Subject: Raid5 assemble after dual sata port failure
Date: Wed, 7 Nov 2007 15:23:48 -0500
Message-ID: <30145090.1194467028512.JavaMail.root@wombat.diezmil.com>
Reply-To: chrise@synplicity.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

While on vacation I had one SATA port/cable fail, and then four hours later a second one fail.  After fixing/moving the SATA ports, I can reboot and all drives seem to be OK now, but when assembled it won't recognize the filesystem.  After futzing around with assemble options like --force and disk order I couldn't get it to work.

Appreciate if someone can provide pointers on how to proceed.  Here's the latest state of the array.  My log shows that /dev/sdc1 failed first and I'm using mdadm v2.5.6 on Ubuntu Linux.

Thanks much,
Chris 

mdadm -Av /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
mdadm: added /dev/sdb1 to /dev/md0 as 1
mdadm: added /dev/sdd1 to /dev/md0 as 2
mdadm: added /dev/sdc1 to /dev/md0 as 3
mdadm: added /dev/sda1 to /dev/md0 as 0
mdadm: /dev/md0 has been started with 3 drives (out of 4).

  mdadm -E /dev/sd[a-d]1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : bc74c21c:9655c1c6:ba6cc37a:df870496
  Creation Time : Sun Nov  5 14:25:01 2006
     Raid Level : raid5
    Device Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 1465151808 (1397.28 GiB 1500.32 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Nov  7 12:02:50 2007
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 401c33e0 - correct
         Events : 0.4880374

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0     254        0        0      active sync   /dev/mapper/sda1

   0     0     254        0        0      active sync   /dev/mapper/sda1
   1     1     254        1        1      active sync   /dev/mapper/sdb1
   2     2     254        2        2      active sync   /dev/mapper/sdd1
   3     3       0        0        3      faulty removed
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : bc74c21c:9655c1c6:ba6cc37a:df870496
  Creation Time : Sun Nov  5 14:25:01 2006
     Raid Level : raid5
    Device Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 1465151808 (1397.28 GiB 1500.32 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Nov  7 12:02:50 2007
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 401c33e3 - correct
         Events : 0.4880374

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1     254        1        1      active sync   /dev/mapper/sdb1

   0     0     254        0        0      active sync   /dev/mapper/sda1
   1     1     254        1        1      active sync   /dev/mapper/sdb1
   2     2     254        2        2      active sync   /dev/mapper/sdd1
   3     3       0        0        3      faulty removed
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : bc74c21c:9655c1c6:ba6cc37a:df870496
  Creation Time : Sun Nov  5 14:25:01 2006
     Raid Level : raid5
    Device Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 1465151808 (1397.28 GiB 1500.32 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon Nov  5 13:31:00 2007
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 3fced5a3 - correct
         Events : 0.4857597

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3     254        3        3      active sync   /dev/mapper/sdc1

   0     0     254        0        0      active sync   /dev/mapper/sda1
   1     1     254        1        1      active sync   /dev/mapper/sdb1
   2     2     254        2        2      active sync   /dev/mapper/sdd1
   3     3     254        3        3      active sync   /dev/mapper/sdc1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : bc74c21c:9655c1c6:ba6cc37a:df870496
  Creation Time : Sun Nov  5 14:25:01 2006
     Raid Level : raid5
    Device Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 1465151808 (1397.28 GiB 1500.32 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Nov  7 12:02:50 2007
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 401c33e6 - correct
         Events : 0.4880374

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2     254        2        2      active sync   /dev/mapper/sdd1

   0     0     254        0        0      active sync   /dev/mapper/sda1
   1     1     254        1        1      active sync   /dev/mapper/sdb1
   2     2     254        2        2      active sync   /dev/mapper/sdd1
   3     3       0        0        3      faulty removed




--
This message was sent on behalf of chrise@synplicity.com at openSubscriber.com
http://www.opensubscriber.com/messages/linux-raid@vger.kernel.org/topic.html
