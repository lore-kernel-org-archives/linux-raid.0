From: Marc Desharnais <marcdesharnais@hotmail.com>
Subject: Raid5 fails to assemble automatically
Date: Sun, 19 Jul 2015 10:26:35 -0400
Message-ID: <BLU437-SMTP68684C478276C82E113DE6CE860@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm new to this mailing list but I subscribed because of this problem 
with my raid5.
I really don't want to mess this up and it was clearly suggested to not 
rush things on the wiki. So I'm looking for help :)
My raid has been running great for a long time now but I think it needs 
so serious maintenance.
I have a 4 disks raid 5 on ArchLinux, mdadm version 3.3.1.

First, the raid status :

/dev/sda:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 63fa3bf5:e14f2233:61302635:9841f005
   Creation Time : Sat Dec 26 11:20:04 2009
      Raid Level : raid5
   Used Dev Size : 488386432 (465.76 GiB 500.11 GB)
      Array Size : 1465159296 (1397.28 GiB 1500.32 GB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Fri May 22 03:08:43 2015
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : a59a8ad1 - correct
          Events : 17559

          Layout : left-symmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     3       8        0        3      active sync   /dev/sda

    0     0       8       64        0      active sync   /dev/sde
    1     1       0        0        1      faulty removed
    2     2       8       16        2      active sync   /dev/sdb
    3     3       8        0        3      active sync   /dev/sda
/dev/sdb:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 63fa3bf5:e14f2233:61302635:9841f005
   Creation Time : Sat Dec 26 11:20:04 2009
      Raid Level : raid5
   Used Dev Size : 488386432 (465.76 GiB 500.11 GB)
      Array Size : 1465159296 (1397.28 GiB 1500.32 GB)
    Raid Devices : 4
   Total Devices : 2
Preferred Minor : 0

     Update Time : Sat May 23 07:02:59 2015
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 2
   Spare Devices : 0
        Checksum : a59c1346 - correct
          Events : 17562

          Layout : left-symmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     2       8       16        2      active sync   /dev/sdb

    0     0       8       64        0      active sync   /dev/sde
    1     1       0        0        1      faulty removed
    2     2       8       16        2      active sync   /dev/sdb
    3     3       0        0        3      faulty removed
/dev/sdd:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 63fa3bf5:e14f2233:61302635:9841f005
   Creation Time : Sat Dec 26 11:20:04 2009
      Raid Level : raid5
   Used Dev Size : 488386432 (465.76 GiB 500.11 GB)
      Array Size : 1465159296 (1397.28 GiB 1500.32 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0

     Update Time : Mon Dec 24 01:09:51 2012
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0
        Checksum : a113755e - correct
          Events : 11218

          Layout : left-symmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     1       8       16        1      active sync   /dev/sdb

    0     0       8       32        0      active sync   /dev/sdc
    1     1       8       16        1      active sync   /dev/sdb
    2     2       8       48        2      active sync   /dev/sdd
    3     3       8       64        3      active sync   /dev/sde
/dev/sde:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 63fa3bf5:e14f2233:61302635:9841f005
   Creation Time : Sat Dec 26 11:20:04 2009
      Raid Level : raid5
   Used Dev Size : 488386432 (465.76 GiB 500.11 GB)
      Array Size : 1465159296 (1397.28 GiB 1500.32 GB)
    Raid Devices : 4
   Total Devices : 2
Preferred Minor : 0

     Update Time : Sat May 23 07:02:59 2015
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 2
   Spare Devices : 0
        Checksum : a59c1372 - correct
          Events : 17562

          Layout : left-symmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     0       8       64        0      active sync   /dev/sde

    0     0       8       64        0      active sync   /dev/sde
    1     1       0        0        1      faulty removed
    2     2       8       16        2      active sync   /dev/sdb
    3     3       0        0        3      faulty removed



Obvisously the event count is wrong on 2 disks. One disk has been gone 
for a long time now...

1 - First question : how can I safely assemble the raid to the latest 
sync state? I don't want to mess this up.
2 - Does this mean my hard drives are dead, or simply desync?


Also I tried to force assemble :
  mdadm --assemble --force /dev/md0 /dev/sda /dev/sdb /dev/sde
mdadm: /dev/sda is busy - skipping
mdadm: /dev/sdb is busy - skipping
mdadm: /dev/sde is busy - skipping


What should I do now?

Thank you!


Marc

