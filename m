From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: raidreconf: Successful RAID5 Reconstruction (re-size)
Date: Wed, 26 Jun 2002 10:41:07 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNAAEOGDAAA.kc130iseo@coastalnet.com>
Reply-To: <cwebster@axl.iseocp.navy.mil>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As requested in the documentation, this message is to provide feedback on
use of "raidreconf". See below for "System Profile".

The total time required to reconstruct our RAID5 was less than 6 hours.
There were no errors. Prior to the reconfiguration, a backup from the RAID
to the 80 GB IDE drive took approximately 5 hours with maximum compression.
See "Actions Taken" below for details on what done to accomplish this task.

The reconfiguration became necessary due to a hardware upgrade which added
three hard drives to the 9-bay software RAID5 array. The three new drives
are from a different vendor than the originals but have the same size,
speed, and disk geometry.

Although the reconstruction was completely successful and seemed to be
pretty efficient, I think we are going to "re-make" the array anyway. I
would like the arrays to be constructed with the fixes and enhancements of
the latest raidtools. I would also like to at least start out with a RAID
configuration that was specified, where the spare is the last drive. I'm not
sure exactly what difference there will be between the 0.90 and 1.00 devices
in terms of efficiency, but I'm assuming there were fixes and enhancements
from which the RAID would benefit.

The original array was created with raidtools version 0.90. As expected, the
superblocks for the original 6 drives attest to this (see below). However, I
was surprised to see that the superblocks of the newly added drives did not
display the current version (raidtools-1.00.2-1.3).

One other thing is puzzling me. When I constructed the new "raidtab" I
explicitly reconfigured the array so that all devices would be in sequence,
leaving the last drive as the spare. Disregarding my "new" raidtab,
"raidreconf" kept the old spare (/dev/sdc) and used the last drive in the
array in its place. So, now the sequence of devices is incorrect.

Old sequence:     sda sdb sdf sdd sde sdc
RAID Drive #:      0   1   2   3   4   S

Desired sequence: sda sdb sdc sdd sde sdf sdg sdh sdi
RAID Drive #:      0   1   2   3   4   5   6   7   S

Sequence created: sda sdb sdi sdd sde sdf sdg sdh sdc
RAID Drive #:      0   1   2   3   4   5   6   7   S


Overall, I'm very pleased with the performance and utility of this new
addition to the raidtools. It provides much needed functionality. Thank you
Neil and contributors!

Cal Webster
Network Manager
NAWCTSD ISEO CPNC
cwebster@ec.rr.com


######################
# Begin RAID Profile #
######################

===============
Partition table
===============
Disk /dev/sdh (Sun disk label): 19 heads, 248 sectors, 7506 cylinders
Units = cylinders of 4712 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/sdh1             1      7506  17681780   fd  Linux raid autodetect
/dev/sdh3             0      7506  17684136    5  Whole disk
===============

===========
Superblocks
===========
              ---------------------------
              Original Drives (sda - sdf)
              ---------------------------

--------[ mdadm --examine /dev/sda1 ]--------
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fd94b4ec:0888d541:a6dacd75:c81d47bc
  Creation Time : Tue Jun 25 20:57:22 2002
     Raid Level : raid5
    Device Size : 17681664 (16.86 GiB 18.15 GB)
   Raid Devices : 8
  Total Devices : 9
Preferred Minor : 0

    Update Time : Wed Jun 26 01:38:05 2002
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 998323f1 - correct
         Events : 0.3

         Layout : left-asymmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
---------------------------------------------

            ----------------------
            New Drives (sdg - sdi)
            ----------------------

--------[ mdadm --examine /dev/sdg1 ]--------
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fd94b4ec:0888d541:a6dacd75:c81d47bc
  Creation Time : Tue Jun 25 20:57:22 2002
     Raid Level : raid5
    Device Size : 17681664 (16.86 GiB 18.15 GB)
   Raid Devices : 8
  Total Devices : 9
Preferred Minor : 0

    Update Time : Wed Jun 26 01:38:05 2002
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 9983245d - correct
         Events : 0.3

         Layout : left-asymmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     6       8       97        6      active sync   /dev/sdg1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
---------------------------------------------
===========

==================
RAID Configuration
==================

-----------------------[ Old raidtab ]-----------------------
#
# 'persistent' RAID5 setup, with one spare disk:
#
raiddev /dev/md0
    raid-level                5
    nr-raid-disks             5
    nr-spare-disks            1
    persistent-superblock     1
    chunk-size                128

    device                    /dev/sda1
    raid-disk                 0
    device                    /dev/sdb1
    raid-disk                 1
    device                    /dev/sdf1
    raid-disk                 2
    device                    /dev/sdd1
    raid-disk                 3
    device                    /dev/sde1
    raid-disk                 4
    device                    /dev/sdc1
    spare-disk                0
-------------------------------------------------------------

-----------------------[ New raidtab ]-----------------------
#
# 'persistent' RAID5 setup, with one spare disk:
#
raiddev /dev/md0
    raid-level                5
    nr-raid-disks             8
    nr-spare-disks            1
    persistent-superblock     1
    chunk-size                128

    device                    /dev/sda1
    raid-disk                 0
    device                    /dev/sdb1
    raid-disk                 1
    device                    /dev/sdc1
    raid-disk                 2
    device                    /dev/sdd1
    raid-disk                 3
    device                    /dev/sde1
    raid-disk                 4
    device                    /dev/sdf1
    raid-disk                 5
    device                    /dev/sdg1
    raid-disk                 6
    device                    /dev/sdh1
    raid-disk                 7
    device                    /dev/sdi1
    spare-disk                0
-------------------------------------------------------------
==================

####################
# End RAID Profile #
####################

########################
# Begin System Profile #
########################

CPU:

cpu		: TI UltraSparc IIi
fpu		: UltraSparc IIi integrated FPU
promlib		: Version 3 Revision 14
prom		: 3.14.0
type		: sun4u
ncpus probed	: 1
ncpus active	: 1
Cpu0Bogo	: 599.65
Cpu0ClkTck	: 0000000011e1ab1e
MMU Type	: Spitfire

Physical RAM:	256 MB

IDE Boot drive:

-
class: HD
bus: IDE
detached: 0
device: hdb
driver: ignore
desc: "ST380021A"
physical: 155061/16/63
logical: 155061/16/63
-

SCSI Software RAID Drives:

## 6 of these:
-
class: HD
bus: SCSI
detached: 0
device: sda
driver: ignore
desc: "Fujitsu MAA3182S SUN18G"
host: 0
id: 0
channel: 0
lun: 0
-

## 3 of these:

-
class: HD
bus: SCSI
detached: 0
device: sdg
driver: ignore
desc: "Seagate ST318438LW"
host: 0
id: 6
channel: 0
lun: 0
-

Swap:	256 MB partition

Operating System:

Linux version 2.4.18-0.92sparc (root@fry.rdu.redhat.com) (gcc driver version
egcs-2.91.66 19990314/Linux (egcs-1.1.2 release) executing gcc version
egcs-2.92.11) #1 Mon May 6 17:51:54 EDT 2002

RAID Software: raidtools-1.00.2-1.3

######################
# End System Profile #
######################

#######################
# Begin Actions Taken #
#######################

==>Extracted device names from "dmesg"<==

[root@winggear root]# dmesg | grep Attached
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
Attached scsi disk sdc at scsi0, channel 0, id 2, lun 0
Attached scsi disk sdd at scsi0, channel 0, id 3, lun 0
Attached scsi disk sde at scsi0, channel 0, id 4, lun 0
Attached scsi disk sdf at scsi0, channel 0, id 5, lun 0
Attached scsi disk sdg at scsi0, channel 0, id 6, lun 0
Attached scsi disk sdh at scsi0, channel 0, id 8, lun 0
Attached scsi disk sdi at scsi0, channel 0, id 9, lun 0

==>Create Partition Tables on new disks (same for sdg, sdh, sdi)<==

[root@winggear root]# fdisk /dev/sdg
Drive type
   ?   auto configure
   0   custom (with hardware detected defaults)
   a   Quantum ProDrive 80S
   b   Quantum ProDrive 105S
   c   CDC Wren IV 94171-344
   d   IBM DPES-31080
   e   IBM DORS-32160
   f   IBM DNES-318350
   g   SEAGATE ST34371
   h   SUN0104
   i   SUN0207
   j   SUN0327
   k   SUN0340
   l   SUN0424
   m   SUN0535
   n   SUN0669
   o   SUN1.0G
   p   SUN1.05
   q   SUN1.3G
   r   SUN2.1G
   s   IOMEGA Jaz
Select type (? for auto, 0 for custom): 0

Heads:	19
Heads (1-1024, default 64): 19
Sectors/track (1-1024, default 32): 248
Cylinders (1-65535, default 17272): 7506
Alternate cylinders (0-65535, default 2):
Using default value 2
Physical cylinders (0-65535, default 7508):
Using default value 7508
Rotation speed (rpm) (1-100000, default 5400): 7200
Interleave factor (1-32, default 1):
Using default value 1
Extra sectors per cylinder (0-248, default 0):
Using default value 0

Command (m for help): d
Partition number (1-8): 1

Command (m for help): d
Partition number (1-8): 2

Command (m for help): n
Partition number (1-8): 1
First cylinder (0-7506): 1
Last cylinder or +size or +sizeM or +sizeK (1-7506, default 7506):
Using default value 7506

Command (m for help): t
Partition number (1-8): 1
Hex code (type L to list codes): fd
Changed system type of partition 1 to fd (Linux raid autodetect)

Command (m for help): p

Disk /dev/sdh (Sun disk label): 19 heads, 248 sectors, 7506 cylinders
Units = cylinders of 4712 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/sdh1             1      7506  17681780   fd  Linux raid autodetect
/dev/sdh3             0      7506  17684136    5  Whole disk

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.

==>Create "/etc/raidtab.new"<==

[root@winggear root]# cp /etc/raidtab /etc/raidtab.new
[root@winggear root]# vi /etc/raidtab.new
#
# 'persistent' RAID5 setup, with one spare disk:
#
raiddev /dev/md0
    raid-level                5
    nr-raid-disks             8
    nr-spare-disks            1
    persistent-superblock     1
    chunk-size                128

    device                    /dev/sda1
    raid-disk                 0
    device                    /dev/sdb1
    raid-disk                 1
    device                    /dev/sdc1
    raid-disk                 2
    device                    /dev/sdd1
    raid-disk                 3
    device                    /dev/sde1
    raid-disk                 4
    device                    /dev/sdf1
    raid-disk                 5
    device                    /dev/sdg1
    raid-disk                 6
    device                    /dev/sdh1
    raid-disk                 7
    device                    /dev/sdi1
    spare-disk                0

==>Reconfigure the Array<==

*** Check current RAID status ***

[root@winggear root]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdc1[5] sde1[3] sdd1[2] sdf1[1] sdb1[0] sda1[4]
      70726656 blocks level 5, 128k chunk, algorithm 0 [5/5] [UUUUU]

unused devices: <none>

*** Ensure the RAID is unencumbered ***

[root@winggear root]# /etc/init.d/smb stop

[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.2/disc1
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.2/disc2
[root@winggear root]# umount /home/httpd/html/SysAdmin-PerlJournal
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/disc1
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/disc2
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/disc3
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/docs
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/srpm1
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/srpm2
[root@winggear root]# umount /usr/local/archive

[root@winggear root]# df -k
Filesystem           1k-blocks      Used Available Use% Mounted on
/dev/hda5              1008952    149796    807904  16% /
/dev/hda2             25134948  11767212  12090936  50% /home
/dev/hda1             25134948   2299120  21559028  10% /usr
/dev/hda4             25136164  18782672   5076632  79% /var

*** Reconstruct the array ***

[root@winggear root]# raidstop /dev/md0

[root@winggear root]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
unused devices: <none>

[root@winggear root]# date
Tue Jun 25 15:05:24 EDT 2002

[root@winggear root]# raidreconf -o /etc/raidtab -n /etc/raidtab.new -m
/dev/md0

Working with device /dev/md0
Parsing /etc/raidtab
Parsing /etc/raidtab.new
Size of old array: 212181360 blocks,  Size of new array: 318272040 blocks
Old raid-disk 0 has 138138 chunks, 17681664 blocks
Old raid-disk 1 has 138138 chunks, 17681664 blocks
Old raid-disk 2 has 138138 chunks, 17681664 blocks
Old raid-disk 3 has 138138 chunks, 17681664 blocks
Old raid-disk 4 has 138138 chunks, 17681664 blocks
Old raid-disk 5 has 138138 chunks, 17681664 blocks
New raid-disk 0 has 138138 chunks, 17681664 blocks
New raid-disk 1 has 138138 chunks, 17681664 blocks
New raid-disk 2 has 138138 chunks, 17681664 blocks
New raid-disk 3 has 138138 chunks, 17681664 blocks
New raid-disk 4 has 138138 chunks, 17681664 blocks
New raid-disk 5 has 138138 chunks, 17681664 blocks
New raid-disk 6 has 138138 chunks, 17681664 blocks
New raid-disk 7 has 138138 chunks, 17681664 blocks
New raid-disk 8 has 138138 chunks, 17681664 blocks
Using 128 Kbyte blocks to move from 128 Kbyte chunks to 128 Kbyte chunks.
Detected 254584 KB of physical memory in system
A maximum of 517 outstanding requests is allowed
---------------------------------------------------
I will grow your old device /dev/md0 of 690690 blocks
to a new device /dev/md0 of 1105104 blocks
using a block-size of 128 KB
Is this what you want? (yes/no): yes
Converting 690690 block device to 1105104 block device
Allocated free block map for 6 disks
9 unique disks detected.
Working (\) [00690690/00690690]
[############################################]
Source drained, flushing sink.
Reconfiguration succeeded, will update superblocks...
Updating superblocks...
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/sda1, 17681780kB, raid superblock at 17681664kB
disk 1: /dev/sdb1, 17681780kB, raid superblock at 17681664kB
disk 2: /dev/sdc1, 17681780kB, raid superblock at 17681664kB
disk 3: /dev/sdd1, 17681780kB, raid superblock at 17681664kB
disk 4: /dev/sde1, 17681780kB, raid superblock at 17681664kB
disk 5: /dev/sdf1, 17681780kB, raid superblock at 17681664kB
disk 6: /dev/sdg1, 17681780kB, raid superblock at 17681664kB
disk 7: /dev/sdh1, 17681780kB, raid superblock at 17681664kB
disk 8: /dev/sdi1, 17681780kB, raid superblock at 17681664kB
Array is updated with kernel.
Disks re-inserted in array... Hold on while starting the array...
Maximum friend-freeing depth:         8
Total wishes hooked:             690690
Maximum wishes hooked:              517
Total gifts hooked:              690690
Maximum gifts hooked:               415
Congratulations, your array has been reconfigured,
and no errors seem to have occured.

[root@winggear root]# date
Tue Jun 25 20:57:26 EDT 2002

[root@winggear root]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdi1[2] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3]
sdc1[8](F) sdb1[1] sda1[0]
      123771648 blocks level 5, 128k chunk, algorithm 0 [8/8] [UUUUUUUU]

unused devices: <none>

*** Rename the configuration files ***

[root@winggear root]# cp /etc/raidtab /etc/raidtab.020626
[root@winggear root]# mv /etc/raidtab.new /etc/raidtab
mv: overwrite `/etc/raidtab'? y

#####################
# End Actions Taken #
#####################


