From: "Phantazm" <phantazm@phantazm.nu>
Subject: Can someone explain this?
Date: Tue, 22 Feb 2005 14:29:34 +0100
Message-ID: <cvfbt5$3k3$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Why is it reporting Raid Devices: 8 and actuall Devices: 5 ?
Why Failed Devices: -1     (hehe do i have a credit of 1 failed device)  ;)

Is there anyway to get the figures stright again?


mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Wed Jan 26 18:24:22 2005
     Raid Level : raid5
     Array Size : 1393991424 (1329.41 GiB 1427.45 GB)
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 8
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Feb 21 20:52:24 2005
          State : dirty, degraded, recovering
 Active Devices : 7
Working Devices : 7
 Failed Devices : -1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 82% complete

           UUID : 129eed1b:e38f8cbf:dcb31e59:e6532935
         Events : 0.10797242

    Number   Major   Minor   RaidDevice State
       0      22        1        0      active sync 
/dev/ide/host0/bus1/target0/lun0/part1
       1      22       65        1      active sync 
/dev/ide/host0/bus1/target1/lun0/part1
       2      33        1        2      active sync 
/dev/ide/host2/bus0/target0/lun0/part1
       3      33       65        3      active sync 
/dev/ide/host2/bus0/target1/lun0/part1
       4      34        1        4      active sync 
/dev/ide/host2/bus1/target0/lun0/part1
       5       0        0        5      faulty removed
       6      57        1        6      active sync 
/dev/ide/host4/bus1/target0/lun0/part1
       7      57       65        7      active sync 
/dev/ide/host4/bus1/target1/lun0/part1

       8      56        1        8      spare rebuilding 
/dev/ide/host4/bus0/target0/lun0/part1 



