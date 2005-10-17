From: "Paul Aviles" <paul.aviles@palei.com>
Subject: Diff between 2.4 and 2.6 kernels for raid
Date: Mon, 17 Oct 2005 00:08:05 -0400
Message-ID: <003b01c5d2d0$63601940$3224050a@avilespaxp>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a setup script that has worked great for configuring servers in the 
2.4 kernels. The scripts works from a pxe load, mounts a bunch of nfs drives 
and then partitions and formats the drives and later installs a rpms in a 
chroot mode. This works great for my Fedora Core 1 distribution, but when I 
changed the rpms for the CentOS it creates the partitions as needed, but 
when is time to boot the newly created server is gives the following error 
right after it starts checking the root filesystem

fsck.ext3 /dev/md1
invalid argument while trying to open /dev/md1

and it drops you to a shell to run maintenance on the drive. It passes all 
the test so I know the partition and formats are ok.  Are there differences 
between the way the 2.4 and 2.6 kernels handled this or anything else to 
look for?

Here is my configuration.

Thanks

Paul

/etc/fstab
/dev/md1              /         ext3    defaults                          1 
1
/dev/md2              /var      ext3    defaults,nosuid                   3 
3
/dev/md3              swap      swap    defaults                          0 
0
/dev/md4              /home     ext3    defaults,usrquota,grpquota        4 
4
none                  /proc     proc    defaults                          0 
0
none                  /dev/pts  devpts  gid=5,mode=0620                   0 
0
none                  /dev/shm  tmpfs   defaults                          0 
0

/etc/raidtab
raiddev               /dev/md1
raid-level            0
nr-raid-disks               1
nr-spare-disks        0
persistent-superblock 1
chunk-size      64
device  /dev/hda1
raid-disk       0

raiddev               /dev/md2
raid-level            0
nr-raid-disks               1
nr-spare-disks        0
persistent-superblock 1
chunk-size      64
device  /dev/hda2
raid-disk       0

raiddev               /dev/md3
raid-level            0
nr-raid-disks               1
nr-spare-disks        0
persistent-superblock 1
chunk-size      64
device  /dev/hda3
raid-disk       0

raiddev               /dev/md4
raid-level            0
nr-raid-disks               1
nr-spare-disks        0
persistent-superblock 1
chunk-size      64
device  /dev/hda4
raid-disk       0

/boot/grub/grub.conf
default=0
timeout=10
splashimage=(hd0,0)/boot/grub/splash.xpm.gz
title CentOS (2.6.9-11.EL)
        root (hd0,0)
        kernel /boot/vmlinuz-2.6.9-11.EL ro root=/dev/hda1 acpi=on
        initrd /boot/initrd-2.6.9-11.EL.img


