From: "taddis" <taddis@taddis.com>
Subject: raid-1 boot with raid-5 system
Date: Tue, 05 Aug 2003 16:59:11 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <WorldClient-F200308051659.AA59110009@taddis.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Im having trouble booting my raid-1 array.
This is what I want to do:
First I want to boot the system on a small raid-1 array (2 * 80M) to get
boot redundancy. Then I want to mount a raid-5 array (3 * 30G) on "/".
I'll have 3 Linux swaps, one on each disk.

Here are the disks after partition.

#### /dev/hdb ##########################################################

Disk /dev/hdb: 30.7 GB, 30750031872 bytes
255 heads, 63 sectors/track, 3738 cylinders, total 60058656 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdb1   *        63    160649     80293+  fd  Linux raid autodetect
/dev/hdb2        160650  60050969  29945160    5  Extended
/dev/hdb5        160713   1156679    497983+  82  Linux swap
/dev/hdb6   *   1156743  60050969  29447113+  fd  Linux raid autodetect
########################################################################

#### /dev/hdc ##########################################################

Disk /dev/hdc: 30.7 GB, 30750031872 bytes
16 heads, 63 sectors/track, 59582 cylinders, total 60058656 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdc1            63    156239     78088+  fd  Linux raid autodetect
/dev/hdc2        156240  60058655  29951208    5  Extended
/dev/hdc5        156303   1156175    499936+  82  Linux swap
/dev/hdc6   *   1156239  60058655  29451208+  fd  Linux raid autodetect
########################################################################

#### /dev/hdd ##########################################################

Disk /dev/hdd: 30.7 GB, 30750031872 bytes
16 heads, 63 sectors/track, 59582 cylinders, total 60058656 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdd1            63    999935    499936+  82  Linux swap
/dev/hdd2        999936  60058655  29529360    5  Extended
/dev/hdd5   *    999999  60058655  29529328+  fd  Linux raid autodetect
########################################################################


I installed the base system (debian) on /dev/hdb6 with all the required
tools (raidtools, ...).
Then I edited the raidtab file like this:

#### /etc/raidtab ###############
raiddev /dev/md0
raid-level 5
nr-raid-disks 3
nr-spare-disks 0
persistent-superblock 1
parity-algorithm left-symmetric
chunk-size 32
device /dev/hdc6
raid-disk 1
device /dev/hdd5
raid-disk 2
device /dev/hdb6
failed-disk 0

raiddev /dev/md1
raid-level 1
nr-raid-disks 2
nr-spare-disks 0
persistent-superblock 1
chunk-size 32
device /dev/hdc1
raid-disk 0
device /dev/hdb1
raid-disk 1
#################################

In /dev/md0 I have /dev/hdb6 as a failed-disk that partition will be in
the raid-5 later on.
Then I created the arrays with:
mkraid /dev/md0
mkraid /dev/md1

All went well and when I cat /proc/mdstat I get:

#### cat /proc/mdstat #############################################
Personalities : [raid1] [raid5] 
read_ahead 1024 sectors
md1 : active raid1 hdb1[1] hdc1[0]
      78016 blocks [2/2] [UU]
      
md0 : active raid5 hdd5[1] hdc6[0]
      58902272 blocks level 5, 32k chunk, algorithm 2 [3/2] [_UU]
      
unused devices: <none>
###################################################################

After that I stopped the arrays and made filesystems on them like this:

mkreiserfs /dev/md0
mkreiserfs /dev/md1

Then I copied all the /boot/* files onto /dev/md1
and the rest of the filesystem onto /dev/md0.

After all this I had a partition table like this:
#### df -T #######################################################
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/hdb6 reiserfs    29446208    918148  28528060   4% /
/dev/md0  reiserfs    58900468    880820  58019648   2% /raid
/dev/md1  reiserfs       78008     40376     37632  52% /raid/boot
###################################################################

then I chroot'ed into /raid and modified /etc/fstab like this 

#### /etc/fstab  (/raid/etc/fstab) ###########################################
#<file system> <mount point>   <type>  <options>               <dump>  <pass>
/dev/md0        /               reiserfs        defaults        1       1
/dev/md1        /boot           reiserfs        defaults        1       1
##############################################################################

And now I'am stucked here with lilo. I cant get it booting my small raid-1
array.
I dont know if i have to chroot into /raid and run lilo from there or if
it works
the same if I dont chroot.
I've read alot of howtos and mailinglists and they all differ. This is how
I've
done it now:
I have 2 lilo files (lilo.hdb.conf and lilo.hdc.conf) and they look like this:

#### /etc/lilo.hdb.conf  (chrooted in /raid) ####
lba32
disk=/dev/md0
bios=0x80
sectors=63
heads=16
cylinders=3738
partition=/dev/md1
start=63
boot=/dev/hdb
root=/dev/md0
install=/boot/boot-menu.b
map=/boot/map
initrd=/boot/initrd-raid.img
delay=100
prompt
timeout=100
default=Linux
image=/vmlinuz
        label=Linux
        read-only
image=/vmlinuz-raid
        label=Linux-Raid
        read-only
image=/vmlinuz-raidNEW
        label=Linux-RaidNEW
        read-only
###################################################

#### /etc/lilo.hdc.conf ###########################
Its exactly like lilo.hdb.conf the only diffrence is
cylinders=59582
boot=/dev/hdc
###################################################

As you can se I've also made a new initrd image.
My /etc/mkinitrd/files contains:
#### /etc/mkinitrd/files ########################## 
/bin
/bin/bash
/bin/echo
/sbin/raidstart
/bin/mount
/bin/umount
/bin/cat
/bin/sh
/dev/tty1
/dev/md0
/dev/md1
/dev/md2
/dev/md3
/dev/console
/dev/hda
/dev/hda1
/dev/hda2
/dev/hda3
/dev/hdc
/dev/hdc1
/dev/hdc2
/dev/hdc3
/dev/hdd
/dev/hdd1
/dev/hdd2
/dev/hdd3
/dev/initrd
/dev/ram0
/dev/ram1
/dev/ram2
/dev/ram3
/dev/ram4
/dev/ram5
/dev/ram6
/dev/ram7
/etc/raidtab
/etc/fstab
/lib/ld-2.3.1.so
/lib/ld-linux.so.2
/lib/libc-2.3.1.so
/lib/libc.so.6
/linuxrc
/proc
########################################

and /linuxrc looks like this (im not really sure 
about how this file works :/ ):

#### /linuxrc ##########################
# mount the proc file system
/bin/mount /proc

# autostart /boot partition and raid0
/sbin/raidstart /dev/md1

# tell the console what's happening
/bin/cat /proc/mdstat

# Everything is fine, let the kernel mount /dev/md2
# tell the kernel to switch to /dev/md2 as the /root device
# The 0x900 value is the device number calculated by:
#  256*major_device_number + minor_device number
echo "/dev/md0 mounted on root"
echo 0x902>/proc/sys/kernel/real-root-dev

# umount /proc to deallocate initrd device ram space
/bin/umount /proc
exit
##########################################

I did it like this 'mkinitrd -o /boot/initrd-raid.img'.

And now I'll write the two lilo's into the bootrecords like this:

#### lilo -v -C /etc/lilo.hdb.conf #####################################

LILO version 22.5.6.1, Copyright (C) 1992-1998 Werner Almesberger
Development beyond version 21 Copyright (C) 1999-2003 John Coffman
Released 03-Jul-2003, and compiled at 23:47:54 on Jul 17 2003
Compiled for Debian GNU/Linux.

Reading boot sector from /dev/hdb
Warning: /dev/hdb is not on the first disk
Using MENU secondary loader
Calling map_insert_data
Warning: The boot sector and map file are on different disks.

Boot image: /vmlinuz -> boot/vmlinuz-2.4.18-bf2.4
Mapping RAM disk /boot/initrd-raid.img
Added Linux *

Boot image: /vmlinuz-raid -> boot/vmlinuz-2.4.21-raid
Mapping RAM disk /boot/initrd-raid.img
Added Linux-Raid

Boot image: /vmlinuz-raidNEW -> /boot/vmlinuz-2.4.21NEW
Mapping RAM disk /boot/initrd-raid.img
Added Linux-RaidNEW

Skipping /vmlinuz.old
Writing boot sector.
/boot/boot.0340 exists - no boot sector backup copy made.
########################################################################

and 

#### lilo -v -C /etc/lilo.hdc.conf #####################################

LILO version 22.5.6.1, Copyright (C) 1992-1998 Werner Almesberger
Development beyond version 21 Copyright (C) 1999-2003 John Coffman
Released 03-Jul-2003, and compiled at 23:47:54 on Jul 17 2003
Compiled for Debian GNU/Linux.

Reading boot sector from /dev/hdc
Warning: /dev/hdc is not on the first disk
Using MENU secondary loader
Calling map_insert_data

Boot image: /vmlinuz -> boot/vmlinuz-2.4.18-bf2.4
Mapping RAM disk /boot/initrd-raid.img
Added Linux *

Boot image: /vmlinuz-raid -> boot/vmlinuz-2.4.21-raid
Mapping RAM disk /boot/initrd-raid.img
Added Linux-Raid

Boot image: /vmlinuz-raidNEW -> /boot/vmlinuz-2.4.21NEW
Mapping RAM disk /boot/initrd-raid.img
Added Linux-RaidNEW

Skipping /vmlinuz.old
Writing boot sector.
/boot/boot.1600 exists - no boot sector backup copy made.
#########################################################################

I dont know if the warnings are critical or not.

And now I'll reboot the system.

And when I boot it up with my new raid improved kernel it finds and sets 
up raid-1 and after that I get this:

#### dmesg ##############################################################
RAMDISK: Couldn't find valid RAM disk image starting at 0.
Freeing initrd memory: 1852k freed
raid5: switching cache buffer size, 4096 -> 1024
md: swapper(pid 1) used obsolete MD ioctl, upgrade your software to use
new ictls.
hdd: dma_initr: status=0x51 { DriveReady SeekComplete Error }
hdd: dma_initr: error=0x84 { DriveStatusError BadCRC }
hdd: dma_initr: status=0x51 { DriveReady SeekComplete Error }
hdd: dma_initr: error=0x84 { DriveStatusError BadCRC }
hdd: dma_initr: status=0x51 { DriveReady SeekComplete Error }
hdd: dma_initr: error=0x84 { DriveStatusError BadCRC }
hdd: dma_initr: status=0x51 { DriveReady SeekComplete Error }
hdd: dma_initr: error=0x84 { DriveStatusError BadCRC }
hdc: DMA disable
#########################################################################

And here i am stucked. I really dont know whats wrong here. Is it that it
doesnt find the RAMDISK, or is it something else in my configuration?

Thanks for the help!

Tobias Carlsson


