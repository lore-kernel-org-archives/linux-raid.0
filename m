From: Dan Knight <dknight1989@woh.rr.com>
Subject: assembling array after disk failure
Date: Sat, 26 Oct 2013 17:04:31 -0400
Message-ID: <526C2E5F.1060507@woh.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello after some trouble with disks, I am trying to reassemble an 
array.  When I start the array, I am told I don't have enough disks to 
start.  What is really strange to me is that when I examine the disks in 
the array, mdadm gives me different overall information for different 
disks.  What do I need to do to assemble the array?

**[root@server etc]# mdadm -As
**mdadm: /dev/md127 assembled from 3 drives - not enough to start the 
array.**
*[root@server etc]# cat /proc/mdstat*
Personalities :
md127 : inactive sdf[2](S) sde[4](S) sdb[3](S) sdc[1](S) sdd[0](S)
       9767572480 blocks super 0.91

unused devices: <none>
*[root@server etc]# mdadm --examine /dev/sdb*
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
*[root@server etc]# mdadm --examine /dev/sdc*
/dev/sdc:
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

     Update Time : Tue Oct 22 14:42:50 2013
           State : clean
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 6e805a2a - correct
          Events : 15468

          Layout : left-symmetric
      Chunk Size : 4K

       Number   Major   Minor   RaidDevice State
this     1       8       32        1      active sync   /dev/sdc

    0     0       8       48        0      active sync   /dev/sdd
    1     1       8       32        1      active sync   /dev/sdc
    2     2       8       80        2      active sync   /dev/sdf
    3     3       8       16        3      active sync   /dev/sdb
    4     4       8       64        4      active sync   /dev/sde
*[root@server etc]# mdadm --examine /dev/sdd*
/dev/sdd:
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

     Update Time : Tue Oct 22 14:42:50 2013
           State : clean
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 6e805a38 - correct
          Events : 15468

          Layout : left-symmetric
      Chunk Size : 4K

       Number   Major   Minor   RaidDevice State
this     0       8       48        0      active sync   /dev/sdd

    0     0       8       48        0      active sync   /dev/sdd
    1     1       8       32        1      active sync   /dev/sdc
    2     2       8       80        2      active sync   /dev/sdf
    3     3       8       16        3      active sync   /dev/sdb
    4     4       8       64        4      active sync   /dev/sde
*[root@server etc]# mdadm --examine /dev/sde*
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
*[root@server etc]# mdadm --examine /dev/sdf*
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

