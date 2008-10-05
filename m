From: Jeffrey Ross <jeff@bubble.org>
Subject: RAID issue (Fedora 9 issue?)
Date: Sat, 04 Oct 2008 21:38:02 -0400
Message-ID: <48E81A7A.4080703@bubble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I tried the question on the Fedora mailing list and it was suggested I 
try here as well, hopefully somebody knows what I'm doing wrong, and its 
probably something simple.

The system has been running fine for months until now when I've run into 
a problem with my system running Fedora 9 using a RAID-1 configuration.
The system partitions are laid out as follows:

All partitions are of type 0xfd and both disks have the identical 
partition table.
(same model drive for both sda and sdb)
/boot - /dev/md1 (/dev/sda1 & /dev/sdb1)
/ -     /dev/md6 (/dev/sda6 & /dev/sdb6)
swap -  /dev/md3 (/dev/sda3 & /dev/sdb3)
/var -  /dev/md5 (/dev/sda5 & /dev/sdb5)
/usr -  /dev/md2 (/dev/sda2 & /dev/sdb2)
/home - /dev/md7 (/dev/sda7 & /dev/sdb7)


The system gets to:

Waiting for driver initialization.
md: md6 stopped.
mdadm: no devices found for /dev/md6
md: md3 stopped.
mdadm: no devices found for /dev/md3
Trying to resume from /dev/md3
Creating root device.
Mounting root filesystem.
EXT3-fs: unable to read superblock
mount: error mounting /dev/root on /sysroot as ext3: Invalid argument
Setting up other filesystems.
Setting up noew root fs
setuproot: moving /dev failed: No such file or directory
no fstab.sys, mounting internal defaults
setuproot: error mounting /proc: No such file or directory
setuproot: error mounting /sys: No such file or directory
Mount failed for selinuxfs on /selinux:  No such file or directory
Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
switchroot: mount failed: No such file or directory
Booting has failed.

If boot the system recovery image, all the partitions are properly 
identified and started. 
I have verified the contents of the /etc/mdadm.conf file that the UUID's 
are correct
/etc/mdadm.conf:
DEVICE partitions
MAILADDR root
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=0a3ae9c2:721ef822:4b54f7c8:880b6e09
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=e947ca93:d82a9cdf:822a12f9:1933def1
ARRAY /dev/md3 level=raid1 num-devices=2 
UUID=4a043dd5:491bf412:1c85b194:2201cde1
ARRAY /dev/md5 level=raid1 num-devices=2 
UUID=e3db4f79:a56ae50f:9d59b238:9007d2f1
ARRAY /dev/md7 level=raid1 num-devices=2 
UUID=be5a2d25:27a4f476:8802baba:d9231a8e
ARRAY /dev/md6 level=raid1 num-devices=2 
UUID=2e90f785:6e825900:a9059c3b:8f883600

I extracted the init file from the initrd-2.6.26.5-45.fc9.x86_64.img (I 
removed the mknod and usb modprobe's):

#!/bin/nash

mount -t proc /proc /proc
setquiet
echo Mounting proc filesystem
echo Mounting sysfs filesystem
mount -t sysfs /sys /sys
echo Creating /dev
mount -o mode=0755 -t tmpfs /dev /dev
mkdir /dev/pts
mount -t devpts -o gid=5,mode=620 /dev/pts /dev/pts
mkdir /dev/shm
mkdir /dev/mapper
echo Creating initial device nodes
mknod ..... (a lot of them but nothing referring to /dev/mdX)
echo Setting up hotplug.
hotplug
echo Creating block device nodes.
mkblkdevs
echo "Loading raid1 module"
modprobe -q raid1
(usb modprobes)
echo "Loading ext3 module"
modprobe -q ext3
echo "Loading raid456 module"
modprobe -q raid456
echo "Loading scsi_mod module"
modprobe -q scsi_mod
echo "Loading sd_mod module"
modprobe -q sd_mod
echo "Loading libata module"
modprobe -q libata
echo "Loading ahci module"
modprobe -q ahci
echo Waiting for driver initialization. <- this is where the system fails!
stabilized --hash --interval 250 /proc/scsi/scsi
modprobe scsi_wait_scan
rmmod scsi_wait_scan
mkblkdevs
mdadm -As --auto=yes --run /dev/md6
mdadm -As --auto=yes --run /dev/md3
resume /dev/md3
echo Creating root device.
mkrootdev -t ext3 -o defaults,ro /dev/md6
echo Mounting root filesystem.
mount /sysroot
echo Setting up other filesystems.
setuproot
loadpolicy
echo Switching to new root and running init.
switchroot
echo Booting has failed.
sleep -1


What has changed?  Not 100% sure, I have installed a handful of new 
patches recently since the last reboot and unfortunately I don't know 
which ones so there are a lot of possibilities.

Also note that I had converted the system from a non raid to a raid 
system, I rebuilt the initrd at the time (which has been many reboots 
since) with the command:

mkinitrd --preload=raid1 initrd-2.6(something)

Any help would really be appreciated.

Thanks, Jeff

