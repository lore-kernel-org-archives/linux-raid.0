From: <me@heyjay.com>
Subject: How to build bootable RAID 1 as a module with Grub on Debian Sarge
Date: Thu, 27 May 2004 23:15:07 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001101c4446a$837f80d0$6705a8c0@a30>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: jakob@unthought.net, bueso@vives.org
List-Id: linux-raid.ids

Since its not described in the software Raid HOWTO, maybe it will prevent
someone
else from struggling like I did

Build a IDE RAID-1 on Debian Sarge (currently "testing"), using GRUB as the
bootloader, RAID as a module (as opposed to built into the kernel), putting
the swap on a RAID-1 device, via mdadm, with 2 disks, by "method 2" of
the Software Raid HowTo (i.e. installing on one disk (hda), building the
raid
with a "missing" disk, copying contents of hda to raid, and then
incorporating
hda to the raid set), and making the whole thing bootable.

The basic overview how to do this is:

1. Install your system on hda.
2. Partition the second drive
3. Install mdadm
4. Create the RAID devices
5. Create filesystems on each of the RAID partitions
6. Create a new initial ram disk contain the RAID partitions
7. Add an entry to GRUB to use the new partitions
8. Copy your system to the new RAID devices
9. Edit your new fstab at /mnt/etc/fstab to point at the new partitions
10. reboot and hope for the best :)
11. repartition your old system disk
14. add new partitions to raid sets
15. Create a new initial ram disk that knows about your mirrored drives
16. Reboot and check /proc/mdstat see if you are mirroring

I did this on a stock Debian Sarge install
platinum:~# uname -a
Linux platinum 2.4.25-1-386 #2 Wed Apr 14 19:38:08 EST 2004 i686 GNU/Linux

====================================================================
1. Install your system on hda.

 When I finished installing my disk looked like:

platinum:~# fdisk -l /dev/hda

Disk /dev/hda: 120.0 GB, 120033041920 bytes
255 heads, 63 sectors/track, 14593 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hda1               1        1216     9767488+  83  Linux
/dev/hda2            1217        1338      979965   83  Linux

platinum:~# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/hda1              9614116    367000   8758744   5% /
tmpfs                   452696         0    452696   0% /dev/shm

2. Partition the second drive (in my case hdc).  Its important in this step
   to make sure the partition types are "fd" often referred to in other
 how-tos as, 0xFD.  Be careful of the partition sizes.  When it comes time
 to incorporate the current system disk into the raid you must be able to
 build equal size, or larger, partitions on the system disk.  I partitioned
 my drive with sfdisk, you can use cfdisk, fdisk... (or any other method
 you prefer).

 I made my hdc look like:

platinum:~# fdisk -l /dev/hdc

Disk /dev/hdc: 120.0 GB, 120033041920 bytes
255 heads, 63 sectors/track, 14593 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hdc1               1        4357    34997571   fd  Linux raid
autodetect
/dev/hdc2            4358        4606     2000092+  fd  Linux raid
autodetect
/dev/hdc3            4607        9586    40001850   fd  Linux raid
autodetect
/dev/hdc4            9587       14593    40218727+  fd  Linux raid
autodetect

3. Install mdadm

 apt-get install mdadm
 OK
 YES - To: Do you want to start the RAID devices automatically?
 YES - To: Do you want to start the RAID monitor daemon?
 <*> = Which user should get the email notification?

4. Create the RAID devices. Now you create your raid devices with a
   missing disk, like:

platinum:~# mdadm -C /dev/md0 --level raid1 --raid-disks 2 missing /dev/hdc1
platinum:~# mdadm -C /dev/md1 --level raid1 --raid-disks 2 missing /dev/hdc2
platinum:~# mdadm -C /dev/md2 --level raid1 --raid-disks 2 missing /dev/hdc3
platinum:~# mdadm -C /dev/md3 --level raid1 --raid-disks 2 missing /dev/hdc4

 NOTE: the "missing" is a place holder for a device.  This builds a
 RAID device that is degraded (i.e. its supposed to be two partitions but
 only is operating upon one).

 # You may see messages like:
 mdadm: /dev/hdc1 appears to contain an ext2fs file system
    size=104320K  mtime=Sat Apr 10 05:36:15 2004
 Continue creating array? y
 mdadm: array /dev/md0 started.

 mdadm: array /dev/md1 started.
 mdadm: array /dev/md2 started.
 mdadm: array /dev/md3 started.

5. Create filesystems on each of the RAID partitions.  In my case I'm
   making ext3 filesystems, hence the -j

mke2fs -j -b 4096 -R stride=8 /dev/md0
mke2fs -j -b 4096 -R stride=8 /dev/md2
mke2fs -j -b 4096 -R stride=8 /dev/md3

 # and I'm creating my swap partition on md1

platinum:/# mkswap /dev/md1
Setting up swapspace version 1, size = 2047995 kB
platinum:/# swapon /dev/md1
 # Check that you swap partition is online
platinum:/# swapon -s
Filename                        Type            Size    Used    Priority
/dev/hda2                       partition       979956  0       -1
/dev/md1                        partition       1999992 0       -2

6. Create a new boot thingy to contain the RAID modules

platinum:/# cd /boot
platinum:/boot# mkinitrd -r /dev/md0 -o /boot/initrd.img-2.4.25-1-386raid

7. Add an entry to GRUB to use the new partition

platinum:/boot# vi /boot/grub/menu.lst

 # and add the something similar to:

title           Debian GNU/Linux, kernel 2.4.25-1-386 w/Raid
root            (hd0,0)
kernel          /boot/vmlinuz-2.4.25-1-386 root=/dev/md0 ro
initrd          /boot/initrd.img-2.4.25-1-386raid
savedefault
boot

8. Mount the "/" partition of the raid device and copy the system "/"

platinum:~# cd /
platinum:/# mount /dev/md0 /mnt
platinum:/# find . -xdev | cpio -pm /mnt

# cp other partitions and rearrange things as desired

9. Edit your new fstab at /mnt/etc/fstab to point at the new partitions
platinum:~# cat /mnt/etc/fstab
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
#/dev/hda2       none            swap    sw              0       0
/dev/md1        none            swap    sw              0       0
#/dev/hda1       /               ext3    defaults,errors=remount-ro 0
1
/dev/md0        /               ext3    defaults,errors=remount-ro 0       1
/dev/md2        /opt            ext3    defaults        0       1
/dev/md3        /home           ext3    defaults        0       1
/dev/hdd        /media/cdrom    iso9660 ro,user,noauto  0       0
/dev/fd0        /media/floppy   auto    rw,user,noauto  0       0
/dev/hdd        /cdrom          iso9660 ro,user,noauto  0       0

10. reboot and hope for the best :)

# all down hill from here

11. repartition your old system disk (hda)

platinum:/# sfdisk -d /dev/hdc > part.out
platinum:/# sfdisk /dev/hda < part.out

14. add new partitions to raid

platinum:/# mdadm /dev/md0 -a /dev/hda1
mdadm: hot added /dev/hda1
platinum:/# mdadm /dev/md2 -a /dev/hda3
mdadm: hot added /dev/hda3
platinum:/# mdadm /dev/md3 -a /dev/hda4
mdadm: hot added /dev/hda4

# NOTE: while these commands return immediately, they run in the
# background and take a while. For example it took me 30 mins to add
# all the partitions

You can check the progress by:
$ cat /proc/mdstat

# and looking at the "recovery =  X.X%"

15. Create a new initial ram disk that knows about your mirrored drives

platinum:/boot# mkinitrd -r /dev/md0 -o /boot/initrd.img-2.4.25-1-386raid

16. Reboot and check /proc/mdstat see if you are mirroring

====================================================================
Other things to know

mdadm --stop /dev/md0
mdadm --zero-superblock /dev/hda1

## You may want to write a new MBR to the /dev/hdc
## Create an MBR on the new disk

$ grub
Probing devices to guess BIOS drives. This may take a long time.

grub> root (hd1,0)
 Filesystem type is ext2fs, partition type 0xfd

grub> setup (hd1)
 Checking if "/boot/grub/stage1" exists... yes
 Checking if "/boot/grub/stage2" exists... yes
 Checking if "/boot/grub/e2fs_stage1_5" exists... yes
 Running "embed /boot/grub/e2fs_stage1_5 (hd1)"... failed (this is not
fatal)
 Running "embed /boot/grub/e2fs_stage1_5 (hd1,0)"... failed (this is not
fatal)
 Running "install /boot/grub/stage1 (hd1) /boot/grub/stage2 p
/boot/grub/menu.l
st "... succeeded
Done.

# then do the same for hd0
grub> root (hd0,0)
grub> setup (hd0)

#  You may need to edit this file if you install a new kernel-image to
#  tell it where your /dev/md0 is
platinum:/# cat /boot/grub/device.map
(hd0)   /dev/hda
(hd1)   /dev/md0



