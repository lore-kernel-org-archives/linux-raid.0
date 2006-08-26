From: James Brown <jbrown@orange.net>
Subject: Newbie: Kernel panic during RAID1 test & reboot loses one disk
Date: Sat, 26 Aug 2006 23:31:45 +0200
Message-ID: <ecqek4$tnu$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All,

I'm fairly new to Linux/Debian and have been trying to configure mdadm 
for RAID1 with 2x120Gb IDE disks. Unfortunately, I have two problems 
with the configuration and would really appreciate some advice.

* Problem 1: Since moving from 2.4 -> 2.6 kernel, a reboot kicks one 
device out of the array (c.f. post by Andreas Pelzner on 24th Aug 2006).

* Problem 2: When booting my system, unless both disks plugged in, I get 
a kernel panic (oh dear!):

 > mdadm md0 stopped
 > mdadm cannot open device /dev/hda6 no such device or address
 > mdadm /dev/hda6 has wrong uuid
 > mdadm no devices found for /dev/md0
 > ext3fs unable to read superblock
 > ecit 2 - unable to read superblock cramfs
 > kernel panic attempting to kill init

Here is the information about my system/config:

* System Info:
# uname -a
Linux cinzano. 2.6.8-3-386 #1 Sat Jul 15 09:26:40 UTC 2006 i686 GNU/Linux

* mdadm Config:
# cat /etc/mdadm/mdadm.conf
DEVICE partitions
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=cc518d12:0e602331:8715a849:6dac0873
    devices=/dev/hda7,/dev/hdc7
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=07c5cab1:1b86a5ca:f4599353:4ccfc5c1
    devices=/dev/hda6,/dev/hdc6

* After reboot:
# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 hda7[0]
       4675264 blocks [2/1] [U_]
md0 : active raid1 hda6[0]
       101562816 blocks [2/1] [U_]

* After hotadding again:
# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 hda7[0] hdc7[1]
       14675264 blocks [2/2] [UU]
md0 : active raid1 hdc6[1] hda6[0]
       101562816 blocks [2/2] [UU]

* Mdadm version
# apt-show-versions | grep mdadm
mdadm/stable uptodate 1.9.0-4sarge1

* System md logs don't mention hdc6
# grep md /var/log/messages
Aug 26 14:21:32 cinzano kernel: Kernel command line: root=/dev/md0 ro
Aug 26 14:21:32 cinzano kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, 
MD_SB_DISKS=27
Aug 26 14:21:32 cinzano kernel: md: raid1 personality registered as nr 3
Aug 26 14:21:32 cinzano kernel: md: md0 stopped.
Aug 26 14:21:32 cinzano kernel: md: bind<hda6>
Aug 26 14:21:32 cinzano kernel: raid1: raid set md0 active with 1 out of 
2 mirrors
Aug 26 14:21:32 cinzano kernel: EXT3 FS on md0, internal journal
Aug 26 14:21:32 cinzano kernel: md: md1 stopped.
Aug 26 14:21:32 cinzano kernel: md: bind<hdc7>
Aug 26 14:21:32 cinzano kernel: md: bind<hda7>
Aug 26 14:21:32 cinzano kernel: raid1: raid set md1 active with 2 out of 
2 mirrors
Aug 26 14:21:32 cinzano kernel: EXT3 FS on md1, internal journal
Aug 26 14:25:43 cinzano kernel: Kernel command line: root=/dev/md0 ro
Aug 26 14:25:43 cinzano kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, 
MD_SB_DISKS=27
Aug 26 14:25:43 cinzano kernel: md: raid1 personality registered as nr 3
Aug 26 14:25:43 cinzano kernel: md: md0 stopped.
Aug 26 14:25:43 cinzano kernel: md: bind<hda6>
Aug 26 14:25:43 cinzano kernel: raid1: raid set md0 active with 1 out of 
2 mirrors
Aug 26 14:25:43 cinzano kernel: EXT3-fs: md0: orphan cleanup on readonly fs
Aug 26 14:25:43 cinzano kernel: EXT3-fs: md0: 3 orphan inodes deleted
Aug 26 14:25:43 cinzano kernel: EXT3 FS on md0, internal journal
Aug 26 14:25:43 cinzano kernel: md: md1 stopped.
Aug 26 14:25:43 cinzano kernel: md: bind<hdc7>
Aug 26 14:25:43 cinzano kernel: md: bind<hda7>
Aug 26 14:25:43 cinzano kernel: raid1: raid set md1 active with 2 out of 
2 mirrors
Aug 26 14:25:43 cinzano kernel: EXT3 FS on md1, internal journal

* FDisk output
# fdisk -l
Disk /dev/hda: 120.0 GB, 120034123776 bytes
255 heads, 63 sectors/track, 14593 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/hda1               1       14593   117218241    5  Extended
/dev/hda5               1         122      979902   82  Linux swap/Sola.
/dev/hda6             123       12766   101562898+  fd  Linux raid auto.
/dev/hda7           12767       14593    14675346   fd  Linux raid auto.

Disk /dev/hdc: 120.0 GB, 120034123776 bytes
255 heads, 63 sectors/track, 14593 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/hdc1               1       14593   117218241    5  Extended
/dev/hdc5               1         122      979902   82  Linux swap/Sola.
/dev/hdc6             123       12766   101562898+  fd  Linux raid auto.
/dev/hdc7           12767       14593    14675346   fd  Linux raid auto.

Disk /dev/md0: 104.0 GB, 104000323584 bytes
2 heads, 4 sectors/track, 25390704 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

Disk /dev/md0 doesn't contain a valid partition table

Disk /dev/md1: 15.0 GB, 15027470336 bytes
2 heads, 4 sectors/track, 3668816 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

Disk /dev/md1 doesn't contain a valid partition table

* Grub config
# cat /boot/grub/menu.lst
[...]
# groot=(hd0,5)
[...]
title           Debian GNU/Linux, kernel 2.6.8-3-386
root            (hd0,5)
kernel          /boot/vmlinuz-2.6.8-3-386 root=/dev/md0 ro
initrd          /boot/initrd.img-2.6.8-3-386
savedefault
boot
[...]

* Mounts
# cat /etc/fstab
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
/dev/md0        /               ext3    defaults,errors=remount-ro 0       1
/dev/md1        /var/mail       ext3    defaults        0       2
/dev/hda5       none            swap    sw              0       0
/dev/hdc5       none            swap    sw              0       0
/dev/hdd        /media/cdrom0   iso9660 ro,user,noauto  0       0

Many thanks to anyone who can help.

James.

