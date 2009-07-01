From: Michael Ole Olsen <gnu@gmx.net>
Subject: device-mapper: ioctl error adding target to table, lvm will not mount
Date: Wed, 01 Jul 2009 17:43:01 +0200
Message-ID: <4A4B8405.4080607@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With a new compiled kernel from kernel.org 2.6.30 and
lvm2,dmsetup from lenny repos i keep getting:
# vgchange -a y

device-mapper ioctl: error adding target to table
table: device 9:0 too small for target
table: 253:11: linear: dm-linear Device lookup failed
device-mapper: reload ioctl failed: Invalid argument

I have everything compiled into the kernel, also DM, not as module.

but it did say:
12 logical volume(s) in volume group st1500 now active

and i can see them in /dev/mapper

if i tried to mount each of them it said:
mount: you must specify the filesystem type

 or some other weird error message
i do have xfs in my kernel and can mount other xfs filesystems
but all my dm filesystems fail for some reason

Here is my config

root@mlap:~/mfs# grep CONFIG_DM .config
CONFIG_DMI=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM9102 is not set
CONFIG_DMADEVICES=y
CONFIG_DMIID=y
# CONFIG_DMA_API_DEBUG is not set
root@mlap:~/mfs# grep CONFIG_XFS .config
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
root@mlap:~/mfs# grep CONFIG_MD .config
CONFIG_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_RAID6_PQ=y
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
# CONFIG_MDIO_BITBANG is not set

Any ideas what I am missing ?

mdadm is active on the raid, 10 of 10 disks are up and
 /dev/mapper/st1500-bigdaddy exists, i just cannot mount it,
i could do this before kernel and system upgrade
(i use an other lenny install now,  but i updated udev,dmsetup,
cryptsetup,lvm2 to most recent versions on it)
