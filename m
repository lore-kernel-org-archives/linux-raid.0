From: Iain <iain@minihub.org>
Subject: URGENT lilo problems
Date: Wed, 24 Apr 2002 18:56:59 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020424090459Z310953-22651+15685@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am trying to setup a bootable raid1 system.

When I run lilo I get the following error:

Fatal: map file must be on the boot RAID partition

The map file is in /boot which is on /dev/md0 the partition I want to boot 
from.

I am also using ext3.

The weird thing is that all my raid devices say that there is a total of 3 
disks when there is only one:

candela:/home/iain# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Wed Apr 24 18:49:32 2002
     Raid Level : raid1
     Array Size : 192640 (188.12 MiB 197.26 MB)
    Device Size : 192640 (188.12 MiB 197.26 MB)
     Raid Disks : 2
    Total Disks : 3
Preferred Minor : 0
    Persistance : Superblock is persistant

    Update Time : Thu Apr 25 01:47:37 2002
          State : dirty, no-errors
  Active Drives : 2
 Working Drives : 2
  Failed Drives : 1
   Spare Drives : 0


    Number   Major   Minor   RaidDisk   State
       0       3        1        0      active sync   /dev/hda1
       1      22        1        1      active sync   /dev/hdc1
           UUID : 25bd58dd:78b56568:74efe0f8:57a0e70a

I would appreciate any help as this is quite urgent.

Iain.
-- 
public key available at http://www.minihub.org/~iain/iain.asc
