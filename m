From: <me@heyjay.com>
Subject: Can't mount raid 1 partitions other than /
Date: Sun, 23 May 2004 11:34:17 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000b01c440e3$cd10f150$6705a8c0@a30>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've done this in the past and it's always worked, but for some reason this
time it's not, can't seem to figure it out.  I'm building 4 raid 1
partitions
/dev/md0   /
/dev/md1   swap
/dev/md2   /opt
/dev/md3   /home

I doing it by building my raid sets in degraded mode.  I'm using a drive
that I've used for raid in the past.  I'm running raid as a module, 2.6.5
kernel, and grub.  My /dev/md0 which is "/" mounts fine at boot, but on
/dev/md2,3 I get the error:

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

My procedure I followed is:

# partition hdc

mdadm -C /dev/md0 --level raid1 --raid-disks 2 missing /dev/hdc1  # I did
this for hdc2,3,4
mke2fs -j -b 4096 -R stride=8 /dev/md0 # I also did this for md2 and md3
mkswap /dev/md1
swapon /dev/md1
mkinitrd -r /dev/md0 -o /boot/initrd.img-2.6.5raid
cd boot
ln -s initrd.img-2.6.5raid /initrd.img
# added the following to /boot/grub/menu.lst
title           Debian GNU/Linux, kernel 2.6.5-1-k7raid
root            (hd1,0)
kernel          /boot/vmlinuz-2.6.5-1-k7 root=/dev/md0 ro
initrd          /boot/initrd.img-2.6.5raid
savedefault
boot
#then mounted my /dev/md(s) and copied my system onto the new partitions

#then updated my MBR via:
grub
root (hd0,0)
setup (hd0)
root (hd1,0)
setup (hd1)

#then editted my /mnt/etc/fstab to point at my new /dev/md(s)

# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
/dev/md1        none            swap    sw              0       0
/dev/md0        /               ext3    defaults,errors=remount-ro 0       1
/dev/md2        /opt            ext3    defaultS        0       2
/dev/md3        /home           ext3    defaults        0       2
/dev/hdb        /media/cdrom    iso9660 ro,user,noauto  0       0
/dev/fd0        /media/floppy   auto    rw,user,noauto  0       0
/dev/hdb        /cdrom          iso9660 ro,user,noauto  0       0
192.168.5.102:/mnt/hda3 /share nfs
soft,exec,intr,rsize=16384,wsize=16384,timeo=5


When I reboot, I'm running on /dev/md0, but my swap doesn't mount nor do
either of my other /dev/md2 or 3

platinum:~# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md0              34446012    820716  31875424   3% /
tmpfs                   517672         0    517672   0% /dev/shm
192.168.5.102:/mnt/hda3
                       7842996   3858780   3585804  52% /share
platinum:~# swapon -a
swapon: /dev/md1: Invalid argument

platinum:~# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hdc1[1]
      34997504 blocks [2/1] [_U]

unused devices: <none>

Can someone point me in the right direction?

Thanks
Jay

