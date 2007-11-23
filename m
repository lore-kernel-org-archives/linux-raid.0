From: "Joshua Johnson" <enigma2175@gmail.com>
Subject: HELP! New disks being dropped from RAID 6 array on every reboot
Date: Fri, 23 Nov 2007 11:19:00 -0700
Message-ID: <e59c37290711231019v3c20ea71od906bca6e5cab724@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings, long time listener, first time caller.

I recently replaced a disk in my existing 8 disk RAID 6 array.
Previously, all disks were PATA drives connected to the motherboard
IDE and 3 promise Ultra 100/133 controllers.  I replaced one of the
Promise controllers with a Via 64xx based controller, which has 2 SATA
ports and one PATA port.  I connected a new SATA drive to the new
card, partitioned the drive and added it to the array.  After 5 or 6
hours the resyncing process finished and the array showed up complete.
 Upon rebooting I discovered that the new drive had not been added to
the array when it was assembled on boot.   I resynced it and tried
again -- still would not persist after a reboot.  I moved one of the
existing PATA drives to the new controller (so I could have the slot
for network), rebooted and rebuilt the array.  Now when I reboot BOTH
disks are missing from the array (sda and sdb).  Upon examining the
disks it appears they think they are part of the array, but for some
reason they are not being added when the array is being assembled.
For example, this is a disk on the new controller which was not added
to the array after rebooting:

# mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 63ee7d14:a0ac6a6e:aef6fe14:50e047a5
  Creation Time : Thu Sep 21 23:52:19 2006
     Raid Level : raid6
    Device Size : 191157248 (182.30 GiB 195.75 GB)
     Array Size : 1146943488 (1093.81 GiB 1174.47 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Fri Nov 23 10:22:57 2007
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 50df590e - correct
         Events : 0.96419878

     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     6       8        1        6      active sync   /dev/sda1

   0     0       3        2        0      active sync   /dev/hda2
   1     1      57        2        1      active sync   /dev/hdk2
   2     2      33        2        2      active sync   /dev/hde2
   3     3      34        2        3      active sync   /dev/hdg2
   4     4      22        2        4      active sync   /dev/hdc2
   5     5      56        2        5      active sync   /dev/hdi2
   6     6       8        1        6      active sync   /dev/sda1
   7     7       8       17        7      active sync   /dev/sdb1


Everything there seems to be correct and current up to the last
shutdown.  But the disk is not being added on boot.  Examining a disk
that is currently running in the array shows:

# mdadm --examine /dev/hdc2
/dev/hdc2:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 63ee7d14:a0ac6a6e:aef6fe14:50e047a5
  Creation Time : Thu Sep 21 23:52:19 2006
     Raid Level : raid6
    Device Size : 191157248 (182.30 GiB 195.75 GB)
     Array Size : 1146943488 (1093.81 GiB 1174.47 GB)
   Raid Devices : 8
  Total Devices : 6
Preferred Minor : 0

    Update Time : Fri Nov 23 10:23:52 2007
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 50df5934 - correct
         Events : 0.96419880

     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     4      22        2        4      active sync   /dev/hdc2

   0     0       3        2        0      active sync   /dev/hda2
   1     1      57        2        1      active sync   /dev/hdk2
   2     2      33        2        2      active sync   /dev/hde2
   3     3      34        2        3      active sync   /dev/hdg2
   4     4      22        2        4      active sync   /dev/hdc2
   5     5      56        2        5      active sync   /dev/hdi2
   6     6       0        0        6      faulty removed
   7     7       0        0        7      faulty removed


Here is my /etc/mdadm/mdadm.conf:

DEVICE partitions
PROGRAM /bin/echo
MAILADDR <redacted>
ARRAY /dev/md0 level=raid6 num-devices=8
UUID=63ee7d14:a0ac6a6e:aef6fe14:50e047a5


Can anyone see anything that is glaringly wrong here?  Has anybody
experienced similar behavior?  I am running Debian using kernel
2.6.23.8.  All partitions are set to type 0xFD and it appears the
superblocks on the sd* disks were written, why wouldn't they be added
to the array on boot?  Any help is greatly appreciated!
