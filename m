From: <me@heyjay.com>
Subject: Newbie - removing raid
Date: Sun, 2 May 2004 15:03:59 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <008b01c43080$9daa7e40$6705a8c0@a30>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm trying to build raid on Debian Sarge w/2.6.5 kernel, with grub.

I can't seem to get my second md to mount correctly at boot (ironically I
can mount an boot from md0, I thought that was supposed to be the hard
part).

Basically I'm trying to do (starting over with a clean hdc, and booting from
hda):

platinum:~# mdadm -C /dev/md1 --level raid1 --raid-disks 2 missing /dev/hdc2
mdadm: /dev/hdc2 appears to contain an ext2fs file system
    size=40001728K  mtime=Sun May  2 22:32:37 2004
mdadm: /dev/hdc2 appears to be part of a raid array:
    level=1 devices=2 ctime=Sun May  2 22:28:46 2004
Continue creating array? y
mdadm: array /dev/md1 started.
platinum:~# mke2fs -b 4096 -R stride=8 /dev/md1
mke2fs 1.35 (28-Feb-2004)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
5003712 inodes, 10000432 blocks
500021 blocks (5.00%) reserved for the super user
First data block=0
306 block groups
32768 blocks per group, 32768 fragments per group
16352 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,
2654208,
        4096000, 7962624

Writing inode tables: done
Writing superblocks and filesystem accounting information:

This filesystem will be automatically checked every 30 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
platinum:~# cd /boot
platinum:/boot# mkinitrd -r /dev/hda1 -o /boot/initrd.img-2.6.5raid

cd /boot/grub
vi menu.lst
# add this as the first section under the different boot options at the
# bottom
title           Debian GNU/Linux, kernel 2.6.3-1-k7 w/RAID
root            (hd0,0)
kernel          /boot/vmlinuz-2.6.3-1-k7 root=/dev/hda1 ro
initrd          /boot/initrd.img-2.6.5raid
savedefault
boot

platinum:/boot# cd /opt
platinum:/opt# mount /dev/md1 /mnt
platinum:/opt# find . -xdev | cpio -pm /mnt
0 blocks

platinum:/opt# grub
grub> root (hd0,0)
 Filesystem type is ext2fs, partition type 0x83

grub> setup (hd0)
 Checking if "/boot/grub/stage1" exists... yes
 Checking if "/boot/grub/stage2" exists... yes
 Checking if "/boot/grub/e2fs_stage1_5" exists... yes
 Running "embed /boot/grub/e2fs_stage1_5 (hd0)"...  15 sectors are embedded.
succeeded
 Running "install /boot/grub/stage1 (hd0) (hd0)1+15 p
(hd0,0)/boot/grub/stage2
/boot/grub/menu.lst"... succeeded
Done.

grub> quit

#then make my fstab look like:
platinum:/opt# cat /etc/fstab
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
/dev/hda3       none            swap    sw              0       0
/dev/hda1       /               ext3    defaults,errors=remount-ro 0       1
/dev/hda2       /var            ext3    defaults        0       2
/dev/hda5       /home           ext3    defaults        0       2
#/dev/hda6       /opt            ext3    defaults        0       2
/dev/md1       /opt            ext3    defaults        0       2
/dev/hda7       /usr/local      ext3    defaults        0       2

(reboot)

On boot if fails to mount that md1 and complains about invalid superblocks
and say hit control-d to boot normal or enter the root password.  If I boot
normal /opt doesn't mount.

What am I missing?
Also I feel like I have remnents from previous mdadm -C around.  How do I
remove my arrays, remove the filesystems from the hdc and start with a clean
slate?

Thanks
Jay

