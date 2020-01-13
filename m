From: Christian Deufel <christian.deufel@inview.de>
Subject: Reassembling Raid5 in degraded state
Date: Mon, 13 Jan 2020 10:41:01 +0100
Message-ID: <54384251-9978-eb99-e7ec-2da35f41566c@inview.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I'm having a problem with a 4 disk Raid 5 MD-Array.
After a crash it didn't reassemble correctly, by that I mean it crashed 
during the reassemble, and cat /proc/mdstat reads as follows:

[root@dirvish ~]# cat /proc/mdstat
Personalities : [raid1] [raid0] [raid6] [raid5] [raid4]
...
md3 : inactive sdd1[0] sde1[5] sdf1[3] sdc1[2]
       7814047744 blocks
...

mdadm --examine for the disks in the Raid reads as follows:

[root@dirvish ~]# mdadm -E /dev/sdc1
/dev/sdc1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 84b70068:58203635:60d8aaf0:b60ee018
   Creation Time : Mon Feb 28 18:46:58 2011
      Raid Level : raid5
   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
      Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 3

     Update Time : Wed Jan  8 12:26:35 2020
           State : clean
  Active Devices : 3
Working Devices : 4
  Failed Devices : 1
   Spare Devices : 1
        Checksum : bd93dda1 - correct
          Events : 5995154

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

    0     0       8       49        0      active sync   /dev/sdd1
    1     1       0        0        1      faulty removed
    2     2       8       33        2      active sync   /dev/sdc1
    3     3       8       81        3      active sync   /dev/sdf1
    4     4       8       65        4      spare   /dev/sde1
[root@dirvish ~]# mdadm -E /dev/sdd1
/dev/sdd1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 84b70068:58203635:60d8aaf0:b60ee018
   Creation Time : Mon Feb 28 18:46:58 2011
      Raid Level : raid5
   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
      Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 3

     Update Time : Wed Jan  8 13:30:15 2020
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 2
   Spare Devices : 0
        Checksum : bd93ec60 - correct
          Events : 5995162

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8       49        0      active sync   /dev/sdd1

    0     0       8       49        0      active sync   /dev/sdd1
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8       81        3      active sync   /dev/sdf1
[root@dirvish ~]# mdadm -E /dev/sde1
/dev/sde1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 84b70068:58203635:60d8aaf0:b60ee018
   Creation Time : Mon Feb 28 18:46:58 2011
      Raid Level : raid5
   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
      Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 3

     Update Time : Wed Jan  8 13:30:15 2020
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 2
   Spare Devices : 0
        Checksum : bd93ecbd - correct
          Events : 5995162

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     5       8       65       -1      spare   /dev/sde1

    0     0       8       49        0      active sync   /dev/sdd1
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8       81        3      active sync   /dev/sdf1
[root@dirvish ~]# mdadm -E /dev/sdf1
/dev/sdf1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 84b70068:58203635:60d8aaf0:b60ee018
   Creation Time : Mon Feb 28 18:46:58 2011
      Raid Level : raid5
   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
      Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 3

     Update Time : Wed Jan  8 13:30:15 2020
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 2
   Spare Devices : 0
        Checksum : bd93ec86 - correct
          Events : 5995162

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     3       8       81        3      active sync   /dev/sdf1

    0     0       8       49        0      active sync   /dev/sdd1
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8       81        3      active sync   /dev/sdf1

My plan now would be to run mdadm --assemble --force /dev/md3 with 3 
disk, to get the Raid going in a degraded state.
Does anyone have any experience in doing so and can recommend which 3 
disks I should use. I would use sdc1 sdd1 and sdf1, since sdd1 and sdf1 
are displayed as active sync in every examine and sdc1 as it is also 
displayed as active sync.
Do you think that by doing it this way I have a chance to get my Data 
back or do you have any other suggestion as to get the Data back and the 
Raid running again?

Greetings
Christian

  -------------------------------------------------------------------
| Christian Deufel
|
|
| inView Groupware und Datentechnik GmbH
| Emmy-Noether-Str.2
| 79110 Freiburg
|
| https://www.inView.de
| christian.deufel@inView.de
| Tel. 0761 - 45 75 48-22
| Fax. 0761 - 45 75 48-99
|
| Amtsgericht Freiburg HRB-6769
| Ust-ID DE 219531868
| Geschäftsführer: Caspar Fromelt, Frank Kopp
  -------------------------------------------------------------------
