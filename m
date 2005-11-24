From: Ivor Joseph Dvorecky <ivorjoseph@delektron.de>
Subject: mdadm: What does "Failed devices :  -1" mean ?
Date: Thu, 24 Nov 2005 16:36:17 +0000 (UTC)
Message-ID: <loom.20051124T173151-994@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, 
Hope this is not a silly question: 
Knows anybody what this "minus one" means in the message 
"Failed Devices : -1"  AND   why are "Total Devices : 1" when 
working devices are 2 ?? 
I am testing a raid1 SCSI system with 10 partitions. 
After some simulated fails an rebuilds 2 partitions 
are left over with this message. 
Using  mdadm with --fail => --remove => --add  didn't help 
(in other cases it did), only  --stop and then --create 
which recreated the array anew. 
But  /dev/md10  is my root partition which I can't 
stop and recreate. 
 
Any idea would be appreciated, 
thanks - IvorJoseph 
P.S. (Of course, I have already googled, scanned FAQs and mailing lists :-) 
 
 
==========  Just for Information: ============================================ 
 
Version:	mdadm 1.90, no raidtools 
OS:		debian sarge 3.1 
Kernel:		2.4.x 
Interface:	LSI SCSI LVD Ultra-80 2 x channel controler, 1 disk per 
channel 
HDDs:		2 x IBM 36 GB,  /dev/sda14 and /dev/sdb14 
RAID:		RAID-1, /dev/md10 
 
============================================================================== 
 
/dev/md10: 
        Version : 00.90.00 
  Creation Time : Thu Nov  3 22:14:58 2005 
     Raid Level : raid1 
     Array Size : 1461760 (1.39 GiB 1.50 GB) 
    Device Size : 1461760 (1.39 GiB 1.50 GB) 
   Raid Devices : 2 
  Total Devices : 1 
Preferred Minor : 10 
    Persistence : Superblock is persistent 
 
    Update Time : Wed Nov 23 08:19:39 2005 
          State : active 
 Active Devices : 2 
Working Devices : 2 
 Failed Devices : -1 
  Spare Devices : 0 
 
           UUID : 662fe3e9:23fd0a28:c0dd9b9e:73b8e7cd 
         Events : 0.47 
 
    Number   Major   Minor   RaidDevice State 
       0       8       14        0      active sync   /dev/sda14 
       1       8       30        1      active sync   /dev/sdb14 
 
============================================================================== 
 
/dev/sda14: 
          Magic : a92b4efc 
        Version : 00.90.00 
           UUID : 662fe3e9:23fd0a28:c0dd9b9e:73b8e7cd 
  Creation Time : Thu Nov  3 22:14:58 2005 
     Raid Level : raid1 
   Raid Devices : 2 
  Total Devices : 1 
Preferred Minor : 10 
 
    Update Time : Wed Nov 23 08:19:39 2005 
          State : active 
 Active Devices : 2 
Working Devices : 2 
 Failed Devices : -1 
  Spare Devices : 0 
       Checksum : eef3a5c5 - correct 
         Events : 0.47 
 
 
      Number   Major   Minor   RaidDevice State 
this     0       8       14        0      active sync   /dev/sda14 
 
   0     0       8       14        0      active sync   /dev/sda14 
   1     1       8       30        1      active sync   /dev/sdb14 
------------------------------------------------------------------------------ 
 
/dev/sdb14: 
          Magic : a92b4efc 
        Version : 00.90.00 
           UUID : 662fe3e9:23fd0a28:c0dd9b9e:73b8e7cd 
  Creation Time : Thu Nov  3 22:14:58 2005 
     Raid Level : raid1 
   Raid Devices : 2 
  Total Devices : 1 
Preferred Minor : 10 
 
    Update Time : Wed Nov 23 08:19:39 2005 
          State : active 
 Active Devices : 2 
Working Devices : 2 
 Failed Devices : -1 
  Spare Devices : 0 
       Checksum : eef3a5d7 - correct 
         Events : 0.47 
 
 
      Number   Major   Minor   RaidDevice State 
this     1       8       30        1      active sync   /dev/sdb14 
 
   0     0       8       14        0      active sync   /dev/sda14 
   1     1       8       30        1      active sync   /dev/sdb14 

