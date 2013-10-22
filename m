From: Dan Knight <dknight1989@woh.rr.com>
Subject: [Question] how to proceed after bad raid5 reshape
Date: Tue, 22 Oct 2013 18:02:32 -0400
Message-ID: <5266F5F8.4040503@woh.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I was attempting to add a drive to a 4 drive raid5.  Everything seemed 
to be going well, but the reshape has seemingly gotten stuck at 99%.  
Here is what cat /proc/mdstat gives:


Personalities : [raid6] [raid5] [raid4]
md127 : active raid5 sde[4] sdd[5](F) sdc[6](F) sdb[3] sdf[2]
       5860543488 blocks super 0.91 level 5, 4k chunk, algorithm 2 [5/3] 
[__UUU]
       [===================>.]  reshape = 99.0% (1934430696/1953514496) 
finish=1967.2min speed=161K/sec

unused devices: <none>


Checking mdadm -Evvvvs shows that maybe 2 drives went bad during the 
reshape?


mdadm: No md superblock detected on /dev/md127.
/dev/sdf:
           Magic : a92b4efc
         Version : 0.91.00
            UUID : ed465281:7b68fb12:01f9e43d:ac30fbff (local to host 
server)
   Creation Time : Sun Feb 20 18:39:42 2011
      Raid Level : raid5
   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
      Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 127

   Reshape pos'n : 7736445008 (7378.05 GiB 7922.12 GB)
   Delta Devices : 1 (4->5)

     Update Time : Tue Oct 22 16:43:25 2013
           State : active
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 6e803a4f - correct
          Events : 15471

          Layout : left-symmetric
      Chunk Size : 4K

       Number   Major   Minor   RaidDevice State
this     2       8       80        2      active sync   /dev/sdf

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8       80        2      active sync   /dev/sdf
    3     3       8       16        3      active sync   /dev/sdb
    4     4       8       64        4      active sync   /dev/sde
/dev/sde:
           Magic : a92b4efc
         Version : 0.91.00
            UUID : ed465281:7b68fb12:01f9e43d:ac30fbff (local to host 
server)
   Creation Time : Sun Feb 20 18:39:42 2011
      Raid Level : raid5
   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
      Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 127

   Reshape pos'n : 7736445008 (7378.05 GiB 7922.12 GB)
   Delta Devices : 1 (4->5)

     Update Time : Tue Oct 22 16:43:25 2013
           State : active
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 6e803a43 - correct
          Events : 15471

          Layout : left-symmetric
      Chunk Size : 4K

       Number   Major   Minor   RaidDevice State
this     4       8       64        4      active sync   /dev/sde

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8       80        2      active sync   /dev/sdf
    3     3       8       16        3      active sync   /dev/sdb
    4     4       8       64        4      active sync   /dev/sde
/dev/sdb:
           Magic : a92b4efc
         Version : 0.91.00
            UUID : ed465281:7b68fb12:01f9e43d:ac30fbff (local to host 
server)
   Creation Time : Sun Feb 20 18:39:42 2011
      Raid Level : raid5
   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
      Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 127

   Reshape pos'n : 7736445008 (7378.05 GiB 7922.12 GB)
   Delta Devices : 1 (4->5)

     Update Time : Tue Oct 22 16:43:25 2013
           State : active
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 6e803a11 - correct
          Events : 15471

          Layout : left-symmetric
      Chunk Size : 4K

       Number   Major   Minor   RaidDevice State
this     3       8       16        3      active sync   /dev/sdb

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8       80        2      active sync   /dev/sdf
    3     3       8       16        3      active sync   /dev/sdb
    4     4       8       64        4      active sync   /dev/sde
mdadm: No md superblock detected on /dev/sda1.
/dev/sda:
    MBR Magic : aa55
Partition[0] :     72303777 sectors at           63 (type 83)
mdadm: No md superblock detected on /dev/sdc.
mdadm: No md superblock detected on /dev/sdd.
[root@server etc]# watch cat /proc/mdstat
[root@server etc]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : active raid5 sde[4] sdd[5](F) sdc[6](F) sdb[3] sdf[2]
       5860543488 blocks super 0.91 level 5, 4k chunk, algorithm 2 [5/3] 
[__UUU]
       [===================>.]  reshape = 99.0% (1934430696/1953514496) 
finish=1967.2min speed=161K/sec

unused devices: <none>
[root@server etc]# mdadm -Evvvvs
mdadm: No md superblock detected on /dev/md127.
/dev/sdf:
           Magic : a92b4efc
         Version : 0.91.00
            UUID : ed465281:7b68fb12:01f9e43d:ac30fbff (local to host 
server)
   Creation Time : Sun Feb 20 18:39:42 2011
      Raid Level : raid5
   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
      Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 127

   Reshape pos'n : 7736445008 (7378.05 GiB 7922.12 GB)
   Delta Devices : 1 (4->5)

     Update Time : Tue Oct 22 16:43:25 2013
           State : active
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 6e803a4f - correct
          Events : 15471

          Layout : left-symmetric
      Chunk Size : 4K

       Number   Major   Minor   RaidDevice State
this     2       8       80        2      active sync   /dev/sdf

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8       80        2      active sync   /dev/sdf
    3     3       8       16        3      active sync   /dev/sdb
    4     4       8       64        4      active sync   /dev/sde
/dev/sde:
           Magic : a92b4efc
         Version : 0.91.00
            UUID : ed465281:7b68fb12:01f9e43d:ac30fbff (local to host 
server)
   Creation Time : Sun Feb 20 18:39:42 2011
      Raid Level : raid5
   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
      Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 127

   Reshape pos'n : 7736445008 (7378.05 GiB 7922.12 GB)
   Delta Devices : 1 (4->5)

     Update Time : Tue Oct 22 16:43:25 2013
           State : active
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 6e803a43 - correct
          Events : 15471

          Layout : left-symmetric
      Chunk Size : 4K

       Number   Major   Minor   RaidDevice State
this     4       8       64        4      active sync   /dev/sde

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8       80        2      active sync   /dev/sdf
    3     3       8       16        3      active sync   /dev/sdb
    4     4       8       64        4      active sync   /dev/sde
/dev/sdb:
           Magic : a92b4efc
         Version : 0.91.00
            UUID : ed465281:7b68fb12:01f9e43d:ac30fbff (local to host 
server)
   Creation Time : Sun Feb 20 18:39:42 2011
      Raid Level : raid5
   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
      Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 127

   Reshape pos'n : 7736445008 (7378.05 GiB 7922.12 GB)
   Delta Devices : 1 (4->5)

     Update Time : Tue Oct 22 16:43:25 2013
           State : active
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 6e803a11 - correct
          Events : 15471

          Layout : left-symmetric
      Chunk Size : 4K

       Number   Major   Minor   RaidDevice State
this     3       8       16        3      active sync   /dev/sdb

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8       80        2      active sync   /dev/sdf
    3     3       8       16        3      active sync   /dev/sdb
    4     4       8       64        4      active sync   /dev/sde
mdadm: No md superblock detected on /dev/sda1.
/dev/sda:
    MBR Magic : aa55
Partition[0] :     72303777 sectors at           63 (type 83)
mdadm: No md superblock detected on /dev/sdc.
mdadm: No md superblock detected on /dev/sdd.



I am curious as to how best to proceed.  Does anyone have any suggestions?

Thanks,
Dan

