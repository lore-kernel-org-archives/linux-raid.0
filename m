From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Converting system to raid
Date: Thu, 9 Apr 2009 16:44:25 -0700
Message-ID: <003801c9b96d$21a0f420$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have 2 computers that I am trying to convert to raid. Both where setup with debian netinst cd to hda. The first computer has 2
sata drives. They have been configured into 3 mirrored arrays. md0 is to replace hda and become the new boot. md1 will be the new
swap and md2 will be for storing recordings from vdr.

The second system which has been runing for awhile is basicly the same only it was setup with just 1 sata drive used for storage
which failed. It has been replaced with 3 sata drives setup with 2 mirrors + spare each and a raid5 array for storage. Currently the
first 2 arrays are not being used, the 3rd is mounted as /mnt/md2 and is used for the recordings folder and for some storage. Once I
figure out getting the 2 sata drive system booting with raid, I plan to do the same with the 3 sata drive system.

On the 2 sata drive system:
While booting with hda I have md0 mounted as /mnt/md0. I have marked the first partition bootable on both sda and sdb as bootable
and installed grub by doing the following:

sudo grub --no-floppy
Grub> device (hd0) /dev/sda
Grub> root (hd0,0)
Grub> setup (hd0)
Grub> device (hd0) /dev/sdb
Grub> root (hd0,0)
Grub> setup (hd0)
Grub> quit

I used "sudo cp -axu / /mnt/md0" to copy hda to md0. I changed /mnt/md0/etc/fstab so that "/" os /md0 instead of /hda. I also
changed /mnt/md0/boot/grub/menu.lst first kernel entry to md0:

title  Debian GNU/Linux, kernel 2.6.26.8.20090311.1
root  (hd0,0)
kernel  /boot/vmlinuz-2.6.26.8.20090311.1 root=/dev/md0 ro quiet

Changed kopt in  /mnt/md0/boot/grub/menu.lst
# kopt=root=/dev/md0 ro

I have raid built into the kernel so initrd shouldn't be needed:

CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=y
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=y
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set

I changed the grub boot menu color for md0 menu.lst to show which menu was being used.

When I boot up, I go into cmos amd move the ide to the bottom of the harddrive boot list so that it list sata 1, then sata 2, then
the ide.

When it boots, it should come up with the md0 array. I do get the md0 boot menu, but it hangs at booting kernel.  I some help in irc
freenode/#grub and was told grub seems ok, but there is some problem with the array when trying to boot from it. After booting the
array to the grub menu, he had me switch to grubs command line. Found that sda had become hd0, hda was now hd1 and sdb was still
hd2. Kernel started to boot and saw some md stuff go by:
....
md: considering sdb2...
[13:30] <Vorg> md: adding adb2
[13:30] <Vorg> md: sdb1 has different UUID to sdb2
[13:31] <Vorg> md: adding sda2..
.......

Ended with warning: unable to open an initial console. I was able to scroll back and didn't really see any errors. Don't know if I
missed a change to some config file or something else that should be built into the kernel. I have gone over a lot of "guides" and
don't see what is missing.

