From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: md: badblocks(pid 1216) used obsolete MD ioctl
Date: Mon, 1 Jul 2002 10:58:55 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNAAEAMDBAA.kc130iseo@coastalnet.com>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list:

I'm getting errors when formatting and managing RAID devices. Below is the
sequence of events leading up to the errors. I had recently upgraded our
RAID5 array from 6 to 9 disks (see below for system profile and raid
config). To do this, I backed up the contents of the RAID, formatted the new
drives, and re-created it with a new raidtab. There were no errors on any
RAID devices prior to the upgrade.

Please note that the same sector is shown in each of the two I/O errors, so
there may be a real error. However, why can't I get "fsck" to work around
it? Why did the sector error not show up before? Also, why did I only get
data errors in the filesystem check? Isn't the "badblock" test supposed to
catch these bad blocks? Could the "obsolete MD ioctl" errors be keeping
"fsck" from correcting the errors?

Thanks!

--Cal Webster
Network Manager
NAWCTSD ISEO CPNC


############################
# Begin Sequence of Events #
############################

1. Upgraded from 6 to 9 drives - no apparent errors during creation or
restoration of RAID5 device.

2. After restoring data, /dev/sdc1 got kicked from array.

---------------------------------------------------
SCSI disk error : host 0 channel 0 id 2 lun 0  return code = 2
 I/O error: dev 08:21, sector 32772736
raid5: Disk failure on sdc1, disabling device.
Operation continuing on 7 devices
---------------------------------------------------

3. Ran "e2fsck -c /dev/md0" before adding "sdc1" back into array.

---------------------------------------------------
md: badblocks(pid 1857) used obsolete MD ioctl, upgrade your software to use
new ictls.
---------------------------------------------------

4. Ran "fdisk" on /dev/sdc without changing any parameters to erase the RAID
superblock (is there another way to remove "faulty" flag?). Same errors
occurred when formatting new drives (sdg,sdh,sdi) during hardware upgrade:

	Multiple occurrences of this error:
---------------------------------------------------
sys32_ioctl(fdisk:9883): Unknown cmd fd(3) cmd(00000330) arg(effffb40)
---------------------------------------------------

	No errors displayed at terminal
	Partition tables still look okay

5. Used "mdadm /dev/md0 -a /dev/sdc1" to add (formerly "faulty") drive back
into array.

	No errors

6. Used "mdadm /dev/md0 -f /dev/sdi1" to kick (good) original spare from
array.

---------------------------------------------------
md0: resyncing spare disk sdc1 to replace failed disk
---------------------------------------------------

	Reconstruction of array proceeded without incident.

7. Ran "fdisk" on /dev/sdi without changing any parameters to erase the RAID
superblock (is there another way to remove "faulty" flag?). Got same errors
in log from "fdisk" as with /dev/sdc and, as with the other drive, no
terminal error.

8. Used "mdadm /dev/md0 -a /dev/sdi1" to add original spare drive back into
array, again as the spare. Following error appeared in log following raid
reconfig.

---------------------------------------------------
md: badblocks(pid 1216) used obsolete MD ioctl, upgrade your software to use
new ictls.
---------------------------------------------------

9. Ran e2fsck

---------------------------------------------------
[root@winggear root]# e2fsck -c /dev/md0
e2fsck 1.23, 15-Aug-2001 for EXT2 FS 0.5b, 95/08/09
Checking for bad blocks (read-only test): done
Pass 1: Checking inodes, blocks, and sizes
Inode 15105025 is in use, but has dtime set.  Fix<y>? yes
...
Inode 15105088 is in use, but has dtime set.  Fix<y>? yes

yyPass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Inode 15105025 (...) has a bad mode (0157306).
Clear<y>? yes
...
Inode 15105088 (...) has a bad mode (0157306).
Clear<y>? yes

Pass 5: Checking group summary information

ARCHIVE: ***** FILE SYSTEM WAS MODIFIED *****
ARCHIVE: 70316/15482880 files (0.2% non-contiguous), 9814872/30942912 blocks
---------------------------------------------------

10. Following error shows up in system log following completion of "e2fsck".
/dev/sdc1 shows no errors in system log prior to or during the filesystem
check.

---------------------------------------------------
SCSI disk error : host 0 channel 0 id 2 lun 0 return code = 2
 I/O error: dev 08:21, sector 32772736
raid5: Disk failure on sdc1, disabling device.
Operation continuing on 7 devices
---------------------------------------------------

##########################
# End Sequence of Events #
##########################


######################
# Begin RAID Profile #
######################

                           ===============
                           Partition table
                           (all 9 drives)
                           ===============

Disk /dev/sdh (Sun disk label): 19 heads, 248 sectors, 7506 cylinders
Units = cylinders of 4712 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/sdh1             1      7506  17681780   fd  Linux raid autodetect
/dev/sdh3             0      7506  17684136    5  Whole disk
                           ===============

                             ===========
                             Superblocks
                            (all 9 drives)
                             ===========

--------[ mdadm --examine /dev/sda1 ]--------
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 714b16c1:5fb9be28:e5a24a26:38f9f531
  Creation Time : Wed Jun 26 13:03:23 2002
     Raid Level : raid5
    Device Size : 17681664 (16.86 GiB 18.15 GB)
   Raid Devices : 8
  Total Devices : 9
Preferred Minor : 0

    Update Time : Sat Jun 29 01:45:09 2002
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 14137179 - correct
         Events : 0.24

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
                             ===========

                          ==================
                          RAID Configuration
                          ==================

-----------------------[ raidtab ]-----------------------
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
---------------------------------------------------------
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

