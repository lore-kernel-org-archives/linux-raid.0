From: nagilum@nagilum.org
Subject: Raid5 growing problem
Date: Tue, 9 Oct 2007 08:29:15 -0400
Message-ID: <12730771.1191932955728.JavaMail.root@wombat.diezmil.com>
Reply-To: nagilum@nagilum.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I had a power failure during a RAID5 reshape.
I added two drives to an existing RAID5 of three drives.
After the machine came back up (on a rescue disk) I thought I'd simply have to go through the process again. So I use add add the new disk again.
Although that worked, I am now unable to resume the growing process.

#
nas:~# mdadm -Q --detail /dev/md0
#
/dev/md0:
#
        Version : 00.91.03
#
  Creation Time : Sat Sep 15 21:11:41 2007
#
     Raid Level : raid5
#
    Device Size : 488308672 (465.69 GiB 500.03 GB)
#
   Raid Devices : 5
#
  Total Devices : 5
#
Preferred Minor : 0
#
    Persistence : Superblock is persistent
#
 
#
    Update Time : Mon Oct  8 23:59:27 2007
#
          State : active, degraded, Not Started
#
 Active Devices : 3
#
Working Devices : 5
#
 Failed Devices : 0
#
  Spare Devices : 2
#
 
#
         Layout : left-symmetric
#
     Chunk Size : 16K
#
 
#
  Delta Devices : 2, (3->5)
#
 
#
           UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
#
         Events : 0.470134
#
 
#
    Number   Major   Minor   RaidDevice State
#
       0       8        0        0      active sync   /dev/sda
#
       1       8       16        1      active sync   /dev/sdb
#
       2       8       32        2      active sync   /dev/sdc
#
       3       0        0        3      removed
#
       4       0        0        4      removed
#
 
#
       5       8       48        -      spare   /dev/sdd
#
       6       8       64        -      spare   /dev/sde
#
 
#
nas:~# mdadm -E /dev/sd[a-e]
#
/dev/sda:
#
          Magic : a92b4efc
#
        Version : 00.91.00
#
           UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
#
  Creation Time : Sat Sep 15 21:11:41 2007
#
     Raid Level : raid5
#
    Device Size : 488308672 (465.69 GiB 500.03 GB)
#
     Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
#
   Raid Devices : 5
#
  Total Devices : 5
#
Preferred Minor : 0
#
 
#
  Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
#
  Delta Devices : 2 (3->5)
#
 
#
    Update Time : Mon Oct  8 23:59:27 2007
#
          State : clean
#
 Active Devices : 5
#
Working Devices : 5
#
 Failed Devices : 0
#
  Spare Devices : 0
#
       Checksum : f425054d - correct
#
         Events : 0.470134
#
 
#
         Layout : left-symmetric
#
     Chunk Size : 16K
#
 
#
      Number   Major   Minor   RaidDevice State
#
this     0       8        0        0      active sync   /dev/sda
#
 
#
   0     0       8        0        0      active sync   /dev/sda
#
   1     1       8       16        1      active sync   /dev/sdb
#
   2     2       8       32        2      active sync   /dev/sdc
#
   3     3       8       64        3      active sync   /dev/sde
#
   4     4       8       48        4      active sync   /dev/sdd
#
/dev/sdb:
#
          Magic : a92b4efc
#
        Version : 00.91.00
#
           UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
#
  Creation Time : Sat Sep 15 21:11:41 2007
#
     Raid Level : raid5
#
    Device Size : 488308672 (465.69 GiB 500.03 GB)
#
     Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
#
   Raid Devices : 5
#
  Total Devices : 5
#
Preferred Minor : 0
#
 
#
  Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
#
  Delta Devices : 2 (3->5)
#
 
#
    Update Time : Mon Oct  8 23:59:27 2007
#
          State : clean
#
 Active Devices : 5
#
Working Devices : 5
#
 Failed Devices : 0
#
  Spare Devices : 0
#
       Checksum : f425055f - correct
#
         Events : 0.470134
#
 
#
         Layout : left-symmetric
#
     Chunk Size : 16K
#
 
#
      Number   Major   Minor   RaidDevice State
#
this     1       8       16        1      active sync   /dev/sdb
#
 
#
   0     0       8        0        0      active sync   /dev/sda
#
   1     1       8       16        1      active sync   /dev/sdb
#
   2     2       8       32        2      active sync   /dev/sdc
#
   3     3       8       64        3      active sync   /dev/sde
#
   4     4       8       48        4      active sync   /dev/sdd
#
/dev/sdc:
#
          Magic : a92b4efc
#
        Version : 00.91.00
#
           UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
#
  Creation Time : Sat Sep 15 21:11:41 2007
#
     Raid Level : raid5
#
    Device Size : 488308672 (465.69 GiB 500.03 GB)
#
     Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
#
   Raid Devices : 5
#
  Total Devices : 5
#
Preferred Minor : 0
#
 
#
  Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
#
  Delta Devices : 2 (3->5)
#
 
#
    Update Time : Mon Oct  8 23:59:27 2007
#
          State : clean
#
 Active Devices : 5
#
Working Devices : 5
#
 Failed Devices : 0
#
  Spare Devices : 0
#
       Checksum : f4250571 - correct
#
         Events : 0.470134
#
 
#
         Layout : left-symmetric
#
     Chunk Size : 16K
#
 
#
      Number   Major   Minor   RaidDevice State
#
this     2       8       32        2      active sync   /dev/sdc
#
 
#
   0     0       8        0        0      active sync   /dev/sda
#
   1     1       8       16        1      active sync   /dev/sdb
#
   2     2       8       32        2      active sync   /dev/sdc
#
   3     3       8       64        3      active sync   /dev/sde
#
   4     4       8       48        4      active sync   /dev/sdd
#
/dev/sdd:
#
          Magic : a92b4efc
#
        Version : 00.91.00
#
           UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
#
  Creation Time : Sat Sep 15 21:11:41 2007
#
     Raid Level : raid5
#
    Device Size : 488308672 (465.69 GiB 500.03 GB)
#
     Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
#
   Raid Devices : 5
#
  Total Devices : 5
#
Preferred Minor : 0
#
 
#
  Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
#
  Delta Devices : 2 (3->5)
#
 
#
    Update Time : Mon Oct  8 23:59:27 2007
#
          State : clean
#
 Active Devices : 5
#
Working Devices : 5
#
 Failed Devices : 0
#
  Spare Devices : 0
#
       Checksum : f42505b9 - correct
#
         Events : 0.470134
#
 
#
         Layout : left-symmetric
#
     Chunk Size : 16K
#
 
#
      Number   Major   Minor   RaidDevice State
#
this     5       8       48       -1      spare   /dev/sdd
#
 
#
   0     0       8        0        0      active sync   /dev/sda
#
   1     1       8       16        1      active sync   /dev/sdb
#
   2     2       8       32        2      active sync   /dev/sdc
#
   3     3       8       64        3      active sync   /dev/sde
#
   4     4       8       48        4      active sync   /dev/sdd
#
/dev/sde:
#
          Magic : a92b4efc
#
        Version : 00.91.00
#
           UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
#
  Creation Time : Sat Sep 15 21:11:41 2007
#
     Raid Level : raid5
#
    Device Size : 488308672 (465.69 GiB 500.03 GB)
#
     Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
#
   Raid Devices : 5
#
  Total Devices : 5
#
Preferred Minor : 0
#
 
#
  Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
#
  Delta Devices : 2 (3->5)
#
 
#
    Update Time : Mon Oct  8 23:59:27 2007
#
          State : clean
#
 Active Devices : 5
#
Working Devices : 5
#
 Failed Devices : 0
#
  Spare Devices : 0
#
       Checksum : f42505db - correct
#
         Events : 0.470134
#
 
#
         Layout : left-symmetric
#
     Chunk Size : 16K
#
 
#
      Number   Major   Minor   RaidDevice State
#
this     6       8       64       -1      spare   /dev/sde
#
 
#
   0     0       8        0        0      active sync   /dev/sda
#
   1     1       8       16        1      active sync   /dev/sdb
#
   2     2       8       32        2      active sync   /dev/sdc
#
   3     3       8       64        3      active sync   /dev/sde
#
   4     4       8       48        4      active sync   /dev/sdd
#
 
#
nas:~# mdadm /dev/md0 -r /dev/sdd
#
mdadm: hot remove failed for /dev/sdd: No such device
#
nas:~# mdadm /dev/md0 --re-add /dev/sdd
#
mdadm: Cannot open /dev/sdd: Device or resource busy

As you can see I am also unable to remove the devices again.
I also adjusted /etc/mdadm/mdadm.conf to match the new setup but still:
# mdadm -A /dev/md0 /dev/sd[a-e]
mdadm: /dev/md0 assembled from 3 drives and 2 spares - not enough to start the array.

How can I tell mdadm that the devices /dev/sdd & /dev/sde are not spares but active? The information on the disks seems ok so I don't know where mdadm gets the idea that these should spare drives? :(


--
This message was sent on behalf of nagilum@nagilum.org at openSubscriber.com
http://www.opensubscriber.com/messages/linux-raid@vger.kernel.org/topic.html
