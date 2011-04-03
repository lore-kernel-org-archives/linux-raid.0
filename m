From: Dennis Grant <reccedg@gmail.com>
Subject: Mounting array at boot - works with some kernels but not others
Date: Sun, 3 Apr 2011 12:34:35 -0400
Message-ID: <BANLkTinSwLgNze-EdRB6wu1o5QYApHbLXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good afternoon.

I love that these old-school mailing lists are still around. :)

To make a long story short, today I started drilling in to why a
machine I have will boot fine on 2.6.31-22 but not on anything newer
(2.6.32-24 to 2.6.32-30)

This is a Ubuntu machine, and all the kernels are the generic models
provided by Ubuntu.

From what I can tell (and the Ubuntu splash screens and various other
shenanigans tend to make troubleshooting more challenging than
required) the boot sequence is failing to mount the raid partition on
the newer kernels. That drops the boot to a console where one is
provided the options to keep waiting, (S)kip the mount, or (M)anually
recover (which drops to a shell). Skipping will boot the machine, but
with the array unmounted.

So something is different about how Ubuntu or the kernel is handling
the raid array between the 2.6.31-22 and all the newer kernels.

When I boot from the 31-22 kernel, the array does appear to be functional.

Machine has 3 drives: sda and sdb are identical and contain the array.
sdc is an older HD from an earlier machine that has LVM partitions on
it.

Attached is a bunch of diagnostic material. Unfortunately, I don't
have the error messages from failed boot attempts.

Any assistance would be much appreciated. I'd be happy to work
off-list and post a summary of the resolution if that helps keep the
list from being clogged up.

Thanks,

DG

---------------------------------
cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : active raid1 sda5[0] sdb5[1]
      769706176 blocks [2/2] [UU]

cat /proc/partitions
major minor  #blocks  name

   8        0  976762584 sda
   8        1     207872 sda1
   8        2  204796620 sda2
   8        3    2048287 sda3
   8        4          1 sda4
   8        5  769706248 sda5
   8       16  976762584 sdb
   8       17     208813 sdb1
   8       18  204796620 sdb2
   8       19    2048287 sdb3
   8       20          1 sdb4
   8       21  769706248 sdb5
   8       32  245117376 sdc
   8       33     104391 sdc1
   8       34  245007315 sdc2
   9        1  769706176 md1
 252        0   10223616 dm-0
 252        1  153812992 dm-1
 252        2   76775424 dm-2
 252        3    1015808 dm-3
 252        4    3145728 dm-4

sudo mdadm --detail /dev/md1
/dev/md1:
        Version : 00.90
  Creation Time : Sat Apr 25 08:43:26 2009
     Raid Level : raid1
     Array Size : 769706176 (734.05 GiB 788.18 GB)
  Used Dev Size : 769706176 (734.05 GiB 788.18 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sun Apr  3 12:06:23 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : e0cc58c7:6f841366:7a44a462:94a1d56a (local to host karzai)
         Events : 0.2844822

    Number   Major   Minor   RaidDevice State
       0       8        5        0      active sync   /dev/sda5
       1       8       21        1      active sync   /dev/sdb5

sudo mdadm --examine /dev/md1
mdadm: No md superblock detected on /dev/md1.

sudo fdisk -l

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000ac88c

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          26      207872   83  Linux
Partition 1 does not end on cylinder boundary.
/dev/sda2              27       25522   204796620   83  Linux
/dev/sda3           25523       25777     2048287+  82  Linux swap / Solaris
/dev/sda4           25778      121601   769706280    5  Extended
/dev/sda5           25778      121601   769706248+  83  Linux

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000d90a1

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1          26      208813+  83  Linux
/dev/sdb2              27       25522   204796620   83  Linux
/dev/sdb3           25523       25777     2048287+  82  Linux swap / Solaris
/dev/sdb4           25778      121601   769706280    5  Extended
/dev/sdb5           25778      121601   769706248+  83  Linux

Disk /dev/sdc: 251.0 GB, 251000193024 bytes
255 heads, 63 sectors/track, 30515 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00042b0a

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1   *           1          13      104391   83  Linux
/dev/sdc2              14       30515   245007315   8e  Linux LVM

Disk /dev/md1: 788.2 GB, 788179124224 bytes
2 heads, 4 sectors/track, 192426544 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/md1 doesn't contain a valid partition table

cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'vol_id --uuid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
# / was on /dev/sda2 during installation
UUID=0bffc411-e143-4d25-bc59-b8b9fabb788a /               ext3
relatime,errors=remount-ro 0       1
# /boot was on /dev/sda1 during installation
UUID=b8f4b4ab-2e59-426e-b380-791f36ba473c /boot           ext2
relatime        0       2
# /boot2 was on /dev/sdb1 during installation
UUID=e9768910-bfd5-4e04-a244-db4a2da9b215 /boot2          ext2
relatime        0       2
# /home was on /dev/sda5 during installation
#UUID=4f73e3ae-9e5d-432f-b5e4-f7c75a038c7c /home           ext3
relatime        0       2
# /home installed on mdraid device by DG. Consists of /home and
/homebak partitions (/dev/sda5 and /dev/sdb5)
/dev/md1	/home	ext3	relatime	0	2
# /homeback was on /dev/sdb5 during installation
#UUID=c3c02f6c-1321-4882-90c5-2623033261c5 /homeback       ext3
relatime        0       2
# /sysback was on /dev/sdb2 during installation
UUID=9f3bb9ee-ee5e-48a8-bdbe-9c80561f41d0 /sysback        ext3
relatime        0       2
# swap was on /dev/sda3 during installation
UUID=873b1a20-cb72-4675-9cc7-fe6ac857490d none            swap    sw
           0       0
# swap was on /dev/sdb3 during installation
UUID=47842e22-d4be-4738-ba2a-b13332b752e9 none            swap    sw
           0       0
/dev/scd0       /media/cdrom0   udf,iso9660 user,noauto,exec,utf8 0       0
/dev/VolGroupHDB/LogVol00		/oldhd/root		ext3	defaults	1 2
/dev/VolGroupHDB/LogVol04		/oldhd/home		ext3	defaults	1 2
/dev/VolGroupHDB/LogVol02		/oldhd/root/usr/local		ext3	defaults	1 2
/dev/VolGroupHDB/LogVol03		/oldhd/root/var		ext3	defaults	1 2

sudo vgdisplay
  --- Volume group ---
  VG Name               VolGroupHDB
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  8
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                5
  Open LV               4
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               233.66 GiB
  PE Size               32.00 MiB
  Total PE              7477
  Alloc PE / Size       7476 / 233.62 GiB
  Free  PE / Size       1 / 32.00 MiB
  VG UUID               2tI8oM-GfB9-OHgv-jQAc-D9bH-zRBK-f3dBAs
